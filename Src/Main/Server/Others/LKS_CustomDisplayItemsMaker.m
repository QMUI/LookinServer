#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_CustomDisplayItemsMaker.m
//  LookinServer
//
//  Created by likai.123 on 2023/11/1.
//

#import "LKS_CustomDisplayItemsMaker.h"
#import "CALayer+LookinServer.h"
#import "LookinDisplayItem.h"
#import "NSArray+Lookin.h"
#import "LKS_CustomAttrGroupsMaker.h"

@interface LKS_CustomDisplayItemsMaker ()

@property(nonatomic, weak) CALayer *layer;

@end

@implementation LKS_CustomDisplayItemsMaker

- (instancetype)initWithLayer:(CALayer *)layer {
    if (self = [super init]) {
        self.layer = layer;
    }
    return self;
}

- (NSArray<LookinDisplayItem *> *)make {
    if (!self.layer) {
        NSAssert(NO, @"");
        return nil;
    }
    NSMutableArray<NSString *> *selectors = [NSMutableArray array];
    [selectors addObject:@"lookin_customDebugInfos"];
    for (int i = 0; i < 5; i++) {
        [selectors addObject:[NSString stringWithFormat:@"lookin_customDebugInfos_%@", @(i)]];
    }
    
    for (NSString *name in selectors) {
        [self makeSubitemsForViewOrLayer:self.layer selectorName:name];
        
        UIView *view = self.layer.lks_hostView;
        if (view) {
            [self makeSubitemsForViewOrLayer:view selectorName:name];
        }
    }
    
    return nil;
}

- (void)makeSubitemsForViewOrLayer:(id)viewOrLayer selectorName:(NSString *)selectorName {
    if (!viewOrLayer || !selectorName.length) {
        return;
    }
    if (![viewOrLayer isKindOfClass:[UIView class]] && ![viewOrLayer isKindOfClass:[CALayer class]]) {
        return;
    }
    SEL selector = NSSelectorFromString(selectorName);
    if (![viewOrLayer respondsToSelector:selector]) {
        return;
    }
    NSMethodSignature *signature = [viewOrLayer methodSignatureForSelector:selector];
    if (signature.numberOfArguments > 2) {
        NSAssert(NO, @"LookinServer - There should be no explicit parameters.");
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:viewOrLayer];
    [invocation setSelector:selector];
    [invocation invoke];
    
    // 小心这里的内存管理
    NSDictionary<NSString *, id> * __unsafe_unretained tempRawData;
    [invocation getReturnValue:&tempRawData];
    NSDictionary<NSString *, id> *rawData = tempRawData;
    
    [self makeSubitemsFromRawData:rawData];
}

- (void)makeSubitemsFromRawData:(NSDictionary<NSString *, id> *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *rawSubviews = data[@"subviews"];
    NSArray<LookinDisplayItem *> *subitems = [self displayItemsFromRawArray:rawSubviews];
}

- (NSArray<LookinDisplayItem *> *)displayItemsFromRawArray:(NSArray<NSDictionary *> *)rawArray {
    if (!rawArray || ![rawArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSArray *items = [rawArray lookin_map:^id(NSUInteger idx, NSDictionary *rawDict) {
        if (![rawDict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        return [self displayItemFromRawDict:rawDict];
    }];
    return items;
}

- (LookinDisplayItem *)displayItemFromRawDict:(NSDictionary<NSString *, id> *)dict {
    NSString *title = dict[@"title"];
    NSString *subtitle = dict[@"subtitle"];
    NSValue *frameValue = dict[@"frameInWindow"];
    NSArray *properties = dict[@"properties"];
    NSArray *subviews = dict[@"subviews"];
    
    if (![title isKindOfClass:[NSString class]]) {
        return nil;
    }
    LookinDisplayItem *newItem = [LookinDisplayItem new];
    if (subviews && [subviews isKindOfClass:[NSArray class]]) {
        newItem.subitems = [self displayItemsFromRawArray:subviews];
    }
    newItem.isHidden = NO;
    newItem.alpha = 1.0;
    newItem.customInfo = [LookinCustomDisplayItemInfo new];
    newItem.customInfo.frameInWindow = frameValue;
    newItem.customAttrGroupList = [[[LKS_CustomAttrGroupsMaker alloc] initWithLayer:self.layer] make];
    
    return newItem;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
