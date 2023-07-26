//
//  ECOChannelAppInfo.m
//  EchoSDK
//
//  Created by 陈爱彬 on 2019/10/30. Maintain by 陈爱彬
//  Description 
//

#import "ECOChannelAppInfo.h"

static NSString *_ecoUniqueAppId = nil;
static NSString *_ecoUniqueAppName = nil;

@implementation ECOChannelAppInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        if (_ecoUniqueAppId) {
            self.appId = _ecoUniqueAppId;
        }else{
            self.appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleIdentifierKey];
        }
        if (_ecoUniqueAppName) {
            self.appName = _ecoUniqueAppName;
        }else{
            NSString *displayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
            self.appName = displayName ?: bundleName;
        }
        self.appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
        self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ?: @"";
#if TARGET_OS_IPHONE
        NSString *icon = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        UIImage *appIcon = [UIImage imageNamed:icon];
        if (appIcon) {
            NSData *iconData = UIImageJPEGRepresentation(appIcon, 1.0f);
            NSString *encodedImageStr = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            self.appIcon = encodedImageStr;
        }
#endif
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.appId = dict[@"appId"] ?: @"";
        self.appName = dict[@"appName"] ?: @"";
        self.appShortVersion = dict[@"sVer"] ?: @"";
        self.appVersion = dict[@"ver"] ?: @"";
        self.appIcon = dict[@"appIcon"] ?: @"";
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return @{@"appId": self.appId ?: @"",
             @"appName": self.appName ?: @"",
             @"sVer": self.appShortVersion ?: @"",
             @"ver": self.appVersion ?: @"",
             @"appIcon": self.appIcon ?: @""
             };
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ECOChannelAppInfo class]]) {
        return NO;
    }
    ECOChannelAppInfo *project = (ECOChannelAppInfo *)object;
    if (![project.appId isEqual:self.appId]) {
        return NO;
    }
    return YES;
}

//由外部设置通用的appid和appname
+ (void)setUniqueAppId:(NSString *)appId
               appName:(NSString *)appName {
    _ecoUniqueAppId = appId;
    _ecoUniqueAppName = appName;
}

@end
