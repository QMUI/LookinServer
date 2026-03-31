#ifdef SHOULD_COMPILE_LOOKIN_SERVER

#import "LKS_HTTPHandler.h"
#import "LKS_HTTPServer.h"
#import "LookinHierarchyInfo.h"
#import "LookinDisplayItem.h"
#import "LookinObject.h"
#import "LookinAppInfo.h"
#import "LookinAttributesGroup.h"
#import "LookinAttributesSection.h"
#import "LookinAttribute.h"
#import "LookinAttributeModification.h"
#import "LKS_AttrGroupsMaker.h"
#import "LKS_InbuiltAttrModificationHandler.h"
#import "LKS_ConnectionManager.h"
#import "NSObject+LookinServer.h"
#import "LookinAttrType.h"
#import <UIKit/UIKit.h>

static const uint16_t kLKS_HTTPPort = 47190;

@interface LKS_HTTPHandler ()
@property(nonatomic, strong) LKS_HTTPServer *httpServer;
@end

@implementation LKS_HTTPHandler

- (void)startHTTPServer {
    if (self.httpServer.isRunning) return;

    self.httpServer = [LKS_HTTPServer new];
    __weak typeof(self) weakSelf = self;
    self.httpServer.requestHandler = ^(LKS_HTTPRequest *request, LKS_HTTPCompletionBlock completion) {
        [weakSelf handleRequest:request completion:completion];
    };

    NSError *error;
    if (![self.httpServer startWithPort:kLKS_HTTPPort error:&error]) {
        NSLog(@"LookinServer - Failed to start HTTP server on port %d: %@", kLKS_HTTPPort, error.localizedDescription);
    }
}

- (void)stopHTTPServer {
    [self.httpServer stop];
}

#pragma mark - Router

- (void)handleRequest:(LKS_HTTPRequest *)request completion:(LKS_HTTPCompletionBlock)completion {
    NSString *method = request.method;
    NSString *path = request.path;

    if ([method isEqualToString:@"GET"] && [path isEqualToString:@"/status"]) {
        completion([self _handleStatus]);
        return;
    }

    if ([method isEqualToString:@"GET"] && [path isEqualToString:@"/hierarchy"]) {
        completion([self _handleGetHierarchy]);
        return;
    }

    // /view/:oid/attributes
    if (request.oidParam > 0 && [path hasSuffix:@"/attributes"]) {
        if ([method isEqualToString:@"GET"]) {
            completion([self _handleGetAttributesForOid:request.oidParam]);
            return;
        }
        if ([method isEqualToString:@"POST"]) {
            [self _handleModifyAttributeForOid:request.oidParam body:request.jsonBody completion:completion];
            return;
        }
    }

    // /view/:oid/screenshot
    if (request.oidParam > 0 && [path hasSuffix:@"/screenshot"]) {
        if ([method isEqualToString:@"GET"]) {
            completion([self _handleGetScreenshotForOid:request.oidParam]);
            return;
        }
    }

    completion([LKS_HTTPResponse errorWithMessage:@"Not found" statusCode:404]);
}

#pragma mark - /status

- (LKS_HTTPResponse *)_handleStatus {
    BOOL isActive = [LKS_ConnectionManager sharedInstance].applicationIsActive;
    LookinAppInfo *appInfo = [LookinAppInfo currentInfoWithScreenshot:NO icon:NO localIdentifiers:nil];

    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"active"] = @(isActive);
    data[@"appName"] = appInfo.appName ?: @"";
    data[@"bundleId"] = appInfo.appBundleIdentifier ?: @"";
    data[@"osDescription"] = appInfo.osDescription ?: @"";
    data[@"deviceDescription"] = appInfo.deviceDescription ?: @"";
    data[@"screenWidth"] = @(appInfo.screenWidth);
    data[@"screenHeight"] = @(appInfo.screenHeight);
    data[@"screenScale"] = @(appInfo.screenScale);
    return [LKS_HTTPResponse okWithData:data];
}

#pragma mark - /hierarchy

- (LKS_HTTPResponse *)_handleGetHierarchy {
    LookinHierarchyInfo *info = [LookinHierarchyInfo staticInfoWithLookinVersion:nil];
    if (!info || info.displayItems.count == 0) {
        return [LKS_HTTPResponse errorWithMessage:@"Hierarchy is empty. Make sure the app is in the foreground." statusCode:503];
    }

    NSMutableArray *items = [NSMutableArray array];
    for (LookinDisplayItem *item in info.displayItems) {
        [items addObject:[self _serializeItem:item]];
    }

    return [LKS_HTTPResponse okWithData:@{
        @"appName": info.appInfo.appName ?: @"",
        @"items": items
    }];
}

- (NSDictionary *)_serializeItem:(LookinDisplayItem *)item {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    unsigned long oid = item.layerObject ? item.layerObject.oid : (item.viewObject ? item.viewObject.oid : 0);
    dict[@"oid"] = @(oid);

    NSString *className = item.layerObject ? [item.layerObject rawClassName] : (item.viewObject ? [item.viewObject rawClassName] : @"");
    dict[@"className"] = className ?: @"";

    if (item.isHidden) dict[@"hidden"] = @YES;
    if (item.alpha < 0.999f) dict[@"alpha"] = @(item.alpha);

    CGRect frame = item.frame;
    dict[@"frame"] = @[@(frame.origin.x), @(frame.origin.y), @(frame.size.width), @(frame.size.height)];

    if (item.customDisplayTitle.length > 0) {
        dict[@"customTitle"] = item.customDisplayTitle;
    }

    // 交互信息：仅 UIView 有意义
    if (item.viewObject) {
        NSObject *obj = [NSObject lks_objectWithOid:item.viewObject.oid];
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)obj;
            dict[@"userInteractionEnabled"] = @(view.userInteractionEnabled);
            dict[@"isControl"] = @([view isKindOfClass:[UIControl class]]);
            dict[@"gestureRecognizerCount"] = @(view.gestureRecognizers.count);
        }
    }

    NSMutableArray *children = [NSMutableArray array];
    for (LookinDisplayItem *child in item.subitems) {
        [children addObject:[self _serializeItem:child]];
    }
    dict[@"children"] = children;

    return dict;
}

#pragma mark - /view/:oid/attributes (GET)

- (LKS_HTTPResponse *)_handleGetAttributesForOid:(unsigned long)oid {
    NSObject *obj = [NSObject lks_objectWithOid:oid];
    if (!obj) {
        return [LKS_HTTPResponse errorWithMessage:[NSString stringWithFormat:@"Object with oid %lu not found or already released", oid] statusCode:404];
    }

    CALayer *layer = nil;
    if ([obj isKindOfClass:[CALayer class]]) {
        layer = (CALayer *)obj;
    } else if ([obj isKindOfClass:[UIView class]]) {
        layer = ((UIView *)obj).layer;
    }

    if (!layer) {
        return [LKS_HTTPResponse errorWithMessage:@"Object is not a UIView or CALayer" statusCode:400];
    }

    NSArray<LookinAttributesGroup *> *groups = [LKS_AttrGroupsMaker attrGroupsForLayer:layer];
    NSMutableArray *groupsJSON = [NSMutableArray array];

    for (LookinAttributesGroup *group in groups) {
        NSMutableDictionary *groupDict = [NSMutableDictionary dictionary];
        groupDict[@"identifier"] = group.identifier ?: @"";
        groupDict[@"title"] = group.userCustomTitle ?: group.identifier ?: @"";

        NSMutableArray *sectionsJSON = [NSMutableArray array];
        for (LookinAttributesSection *section in group.attrSections) {
            NSMutableDictionary *secDict = [NSMutableDictionary dictionary];
            secDict[@"identifier"] = section.identifier ?: @"";

            NSMutableArray *attrsJSON = [NSMutableArray array];
            for (LookinAttribute *attr in section.attributes) {
                NSDictionary *attrDict = [self _serializeAttribute:attr];
                if (attrDict) [attrsJSON addObject:attrDict];
            }
            secDict[@"attributes"] = attrsJSON;
            [sectionsJSON addObject:secDict];
        }
        groupDict[@"sections"] = sectionsJSON;
        [groupsJSON addObject:groupDict];
    }

    return [LKS_HTTPResponse okWithData:@{ @"oid": @(oid), @"groups": groupsJSON }];
}

- (nullable NSDictionary *)_serializeAttribute:(LookinAttribute *)attr {
    if (!attr.identifier) return nil;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"identifier"] = attr.identifier;
    dict[@"attrType"] = @(attr.attrType);
    dict[@"typeDescription"] = [self _descriptionForAttrType:attr.attrType];

    id jsonValue = [self _jsonValueForAttrValue:attr.value type:attr.attrType];
    dict[@"value"] = jsonValue ?: [NSNull null];

    if (attr.displayTitle.length > 0) {
        dict[@"displayTitle"] = attr.displayTitle;
    }

    return dict;
}

- (id)_jsonValueForAttrValue:(id)value type:(LookinAttrType)type {
    if (!value || [value isKindOfClass:[NSNull class]]) return [NSNull null];

    switch (type) {
        case LookinAttrTypeBOOL:
            return @([(NSNumber *)value boolValue]);

        case LookinAttrTypeFloat:
        case LookinAttrTypeDouble:
        case LookinAttrTypeLong:
        case LookinAttrTypeEnumInt:
        case LookinAttrTypeEnumLong:
            if ([value isKindOfClass:[NSNumber class]]) return value;
            return [NSNull null];

        case LookinAttrTypeNSString:
            return [value isKindOfClass:[NSString class]] ? value : [value description];

        case LookinAttrTypeCGPoint: {
            if (![value isKindOfClass:[NSValue class]]) return [NSNull null];
            CGPoint p = [(NSValue *)value CGPointValue];
            return @{ @"x": @(p.x), @"y": @(p.y) };
        }
        case LookinAttrTypeCGSize: {
            if (![value isKindOfClass:[NSValue class]]) return [NSNull null];
            CGSize s = [(NSValue *)value CGSizeValue];
            return @{ @"width": @(s.width), @"height": @(s.height) };
        }
        case LookinAttrTypeCGRect: {
            if (![value isKindOfClass:[NSValue class]]) return [NSNull null];
            CGRect r = [(NSValue *)value CGRectValue];
            return @{ @"x": @(r.origin.x), @"y": @(r.origin.y), @"width": @(r.size.width), @"height": @(r.size.height) };
        }
        case LookinAttrTypeUIEdgeInsets: {
            if (![value isKindOfClass:[NSValue class]]) return [NSNull null];
            UIEdgeInsets insets = [(NSValue *)value UIEdgeInsetsValue];
            return @{ @"top": @(insets.top), @"left": @(insets.left), @"bottom": @(insets.bottom), @"right": @(insets.right) };
        }
        case LookinAttrTypeUIColor: {
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray<NSNumber *> *components = (NSArray *)value;
                if (components.count >= 4) {
                    return @{ @"r": components[0], @"g": components[1], @"b": components[2], @"a": components[3] };
                }
            }
            if ([value isKindOfClass:[UIColor class]]) {
                CGFloat r, g, b, a;
                if ([(UIColor *)value getRed:&r green:&g blue:&b alpha:&a]) {
                    return @{ @"r": @(r), @"g": @(g), @"b": @(b), @"a": @(a) };
                }
            }
            return [value description];
        }
        case LookinAttrTypeEnumString:
            return [value isKindOfClass:[NSString class]] ? value : [value description];
        default:
            if ([value isKindOfClass:[NSString class]]) return value;
            if ([value isKindOfClass:[NSNumber class]]) return value;
            return [value description];
    }
}

- (NSString *)_descriptionForAttrType:(LookinAttrType)type {
    switch (type) {
        case LookinAttrTypeBOOL:         return @"BOOL";
        case LookinAttrTypeFloat:        return @"float";
        case LookinAttrTypeDouble:       return @"double";
        case LookinAttrTypeLong:         return @"NSInteger";
        case LookinAttrTypeCGRect:       return @"CGRect";
        case LookinAttrTypeCGPoint:      return @"CGPoint";
        case LookinAttrTypeCGSize:       return @"CGSize";
        case LookinAttrTypeUIEdgeInsets: return @"UIEdgeInsets";
        case LookinAttrTypeUIColor:      return @"UIColor";
        case LookinAttrTypeEnumInt:      return @"enum(int)";
        case LookinAttrTypeEnumLong:     return @"enum(long)";
        case LookinAttrTypeEnumString:   return @"enum(string)";
        case LookinAttrTypeNSString:     return @"NSString";
        default:                         return @"unknown";
    }
}

#pragma mark - /view/:oid/attributes (POST)

- (void)_handleModifyAttributeForOid:(unsigned long)oid
                                 body:(NSDictionary *)body
                           completion:(LKS_HTTPCompletionBlock)completion {
    if (!body[@"setterSelector"] || !body[@"attrType"] || body[@"value"] == nil) {
        completion([LKS_HTTPResponse errorWithMessage:@"Required fields: setterSelector, attrType, value" statusCode:400]);
        return;
    }

    // 根据 oid 找到对象，优先当作 layer oid，找不到再当作 view oid
    NSObject *obj = [NSObject lks_objectWithOid:oid];
    if (!obj) {
        completion([LKS_HTTPResponse errorWithMessage:[NSString stringWithFormat:@"Object with oid %lu not found", oid] statusCode:404]);
        return;
    }

    // 确定实际 targetOid（如果传入的是 view oid，需要找到 layer）
    unsigned long targetOid = oid;

    LookinAttributeModification *mod = [LookinAttributeModification new];
    mod.clientReadableVersion = @"mcp";
    mod.targetOid = targetOid;
    mod.setterSelector = NSSelectorFromString(body[@"setterSelector"]);
    mod.attrType = (LookinAttrType)[body[@"attrType"] integerValue];
    mod.value = [self _objcValueFromJSON:body[@"value"] type:mod.attrType];

    if (!mod.value) {
        completion([LKS_HTTPResponse errorWithMessage:@"Failed to parse 'value' for the given attrType" statusCode:400]);
        return;
    }

    [LKS_InbuiltAttrModificationHandler handleModification:mod completion:^(LookinDisplayItemDetail *data, NSError *error) {
        if (error) {
            completion([LKS_HTTPResponse errorWithMessage:error.localizedDescription statusCode:500]);
        } else {
            completion([LKS_HTTPResponse okWithData:@{ @"modified": @YES }]);
        }
    }];
}

- (nullable id)_objcValueFromJSON:(id)jsonValue type:(LookinAttrType)type {
    if (!jsonValue || [jsonValue isKindOfClass:[NSNull class]]) return nil;

    switch (type) {
        case LookinAttrTypeBOOL:
            return @([jsonValue boolValue]);
        case LookinAttrTypeFloat:
        case LookinAttrTypeDouble:
        case LookinAttrTypeLong:
        case LookinAttrTypeEnumInt:
        case LookinAttrTypeEnumLong:
            return @([jsonValue doubleValue]);
        case LookinAttrTypeNSString:
            return [jsonValue isKindOfClass:[NSString class]] ? jsonValue : [jsonValue description];
        case LookinAttrTypeCGPoint: {
            if (![jsonValue isKindOfClass:[NSDictionary class]]) return nil;
            CGPoint p = CGPointMake([jsonValue[@"x"] doubleValue], [jsonValue[@"y"] doubleValue]);
            return [NSValue valueWithCGPoint:p];
        }
        case LookinAttrTypeCGSize: {
            if (![jsonValue isKindOfClass:[NSDictionary class]]) return nil;
            CGSize s = CGSizeMake([jsonValue[@"width"] doubleValue], [jsonValue[@"height"] doubleValue]);
            return [NSValue valueWithCGSize:s];
        }
        case LookinAttrTypeCGRect: {
            if (![jsonValue isKindOfClass:[NSDictionary class]]) return nil;
            CGRect r = CGRectMake([jsonValue[@"x"] doubleValue], [jsonValue[@"y"] doubleValue],
                                  [jsonValue[@"width"] doubleValue], [jsonValue[@"height"] doubleValue]);
            return [NSValue valueWithCGRect:r];
        }
        case LookinAttrTypeUIEdgeInsets: {
            if (![jsonValue isKindOfClass:[NSDictionary class]]) return nil;
            UIEdgeInsets insets = UIEdgeInsetsMake(
                [jsonValue[@"top"] doubleValue],
                [jsonValue[@"left"] doubleValue],
                [jsonValue[@"bottom"] doubleValue],
                [jsonValue[@"right"] doubleValue]
            );
            return [NSValue valueWithUIEdgeInsets:insets];
        }
        case LookinAttrTypeUIColor: {
            if (![jsonValue isKindOfClass:[NSDictionary class]]) return nil;
            return [UIColor colorWithRed:[jsonValue[@"r"] doubleValue]
                                   green:[jsonValue[@"g"] doubleValue]
                                    blue:[jsonValue[@"b"] doubleValue]
                                   alpha:[jsonValue[@"a"] doubleValue]];
        }
        default:
            return jsonValue;
    }
}

#pragma mark - /view/:oid/screenshot (GET)

- (LKS_HTTPResponse *)_handleGetScreenshotForOid:(unsigned long)oid {
    NSObject *obj = [NSObject lks_objectWithOid:oid];
    if (!obj) {
        return [LKS_HTTPResponse errorWithMessage:[NSString stringWithFormat:@"Object with oid %lu not found", oid] statusCode:404];
    }

    UIView *view = nil;
    CALayer *layer = nil;
    if ([obj isKindOfClass:[UIView class]]) {
        view = (UIView *)obj;
        layer = view.layer;
    } else if ([obj isKindOfClass:[CALayer class]]) {
        layer = (CALayer *)obj;
    }

    if (!layer) {
        return [LKS_HTTPResponse errorWithMessage:@"Object is not a UIView or CALayer" statusCode:400];
    }

    CGRect bounds = layer.bounds;
    if (CGRectIsEmpty(bounds)) {
        return [LKS_HTTPResponse errorWithMessage:@"Layer has empty bounds, cannot capture screenshot" statusCode:400];
    }

    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) {
        UIGraphicsEndImageContext();
        return [LKS_HTTPResponse errorWithMessage:@"Failed to create graphics context" statusCode:500];
    }

    [layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (!image) {
        return [LKS_HTTPResponse errorWithMessage:@"Failed to render layer" statusCode:500];
    }

    NSData *pngData = UIImagePNGRepresentation(image);
    NSString *base64 = [pngData base64EncodedStringWithOptions:0];

    return [LKS_HTTPResponse okWithData:@{
        @"imageBase64": base64 ?: [NSNull null],
        @"mimeType": @"image/png",
        @"width": @(bounds.size.width),
        @"height": @(bounds.size.height)
    }];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
