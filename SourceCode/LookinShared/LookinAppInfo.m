//
//  LookinAppInfo.m
//
//
//  
//

#import "LookinAppInfo.h"

static NSString * const CodingKey_AppIcon = @"1";
static NSString * const CodingKey_Screenshot = @"2";
static NSString * const CodingKey_DeviceDescription = @"3";
static NSString * const CodingKey_OsDescription = @"4";
static NSString * const CodingKey_AppName = @"5";
static NSString * const CodingKey_ScreenWidth = @"6";
static NSString * const CodingKey_ScreenHeight = @"7";
static NSString * const CodingKey_DeviceType = @"8";

@implementation LookinAppInfo

- (id)copyWithZone:(NSZone *)zone {
    LookinAppInfo *newAppInfo = [[LookinAppInfo allocWithZone:zone] init];
    newAppInfo.appName = self.appName;
    newAppInfo.deviceDescription = self.deviceDescription;
    newAppInfo.osDescription = self.osDescription;
    newAppInfo.deviceType = self.deviceType;
    return newAppInfo;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.serverVersion = [aDecoder decodeIntForKey:@"serverVersion"];

        NSData *screenshotData = [aDecoder decodeObjectForKey:CodingKey_Screenshot];
        self.screenshot = [[LookinImage alloc] initWithData:screenshotData];
        
        NSData *appIconData = [aDecoder decodeObjectForKey:CodingKey_AppIcon];
        self.appIcon = [[LookinImage alloc] initWithData:appIconData];
        
        self.appName = [aDecoder decodeObjectForKey:CodingKey_AppName];
        self.appBundleIdentifier = [aDecoder decodeObjectForKey:@"appBundleIdentifier"];
        self.deviceDescription = [aDecoder decodeObjectForKey:CodingKey_DeviceDescription];
        self.osDescription = [aDecoder decodeObjectForKey:CodingKey_OsDescription];
        self.osMainVersion = [aDecoder decodeIntegerForKey:@"osMainVersion"];
        self.deviceType = [aDecoder decodeIntegerForKey:CodingKey_DeviceType];
        self.screenWidth = [aDecoder decodeDoubleForKey:CodingKey_ScreenWidth];
        self.screenHeight = [aDecoder decodeDoubleForKey:CodingKey_ScreenHeight];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.serverVersion forKey:@"serverVersion"];
    
#if TARGET_OS_IPHONE
    NSData *screenshotData = UIImagePNGRepresentation(self.screenshot);
    [aCoder encodeObject:screenshotData forKey:CodingKey_Screenshot];
    
    NSData *appIconData = UIImagePNGRepresentation(self.appIcon);
    [aCoder encodeObject:appIconData forKey:CodingKey_AppIcon];
#elif TARGET_OS_MAC
    NSData *screenshotData = [self.screenshot TIFFRepresentation];
    [aCoder encodeObject:screenshotData forKey:CodingKey_Screenshot];
    
    NSData *appIconData = [self.appIcon TIFFRepresentation];
    [aCoder encodeObject:appIconData forKey:CodingKey_AppIcon];
#endif
    
    [aCoder encodeObject:self.appName forKey:CodingKey_AppName];
    [aCoder encodeObject:self.appBundleIdentifier forKey:@"appBundleIdentifier"];
    [aCoder encodeObject:self.deviceDescription forKey:CodingKey_DeviceDescription];
    [aCoder encodeObject:self.osDescription forKey:CodingKey_OsDescription];
    [aCoder encodeInteger:self.osMainVersion forKey:@"osMainVersion"];
    [aCoder encodeInteger:self.deviceType forKey:CodingKey_DeviceType];
    [aCoder encodeDouble:self.screenWidth forKey:CodingKey_ScreenWidth];
    [aCoder encodeDouble:self.screenHeight forKey:CodingKey_ScreenHeight];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinAppInfo class]]) {
        return NO;
    }
    if ([self isEqualToAppInfo:object]) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash {
    return self.appName.hash ^ self.deviceDescription.hash ^ self.osDescription.hash ^ self.deviceType;
}

- (BOOL)isEqualToAppInfo:(LookinAppInfo *)info {
    if (!info) {
        return NO;
    }
    if ([self.appName isEqualToString:info.appName] && [self.deviceDescription isEqualToString:info.deviceDescription] && [self.osDescription isEqualToString:info.osDescription] && self.deviceType == info.deviceType) {
        return YES;
    }
    return NO;
}

#if TARGET_OS_IPHONE

+ (LookinAppInfo *)currentInfoWithScreenshotType:(LookinAppsFetchScreenshotType)type appInfos:(NSArray<LookinAppInfo *> *)appInfos {
    LookinAppInfo *info = [[LookinAppInfo alloc] init];
    
    info.appIcon = [self appIcon];
    info.appName = [self appName];
    info.deviceDescription = [UIDevice currentDevice].name;
    info.appBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([self isSimulator]) {
        info.deviceType = LookinAppInfoDeviceSimulator;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        info.deviceType = LookinAppInfoDeviceIPad;
    } else {
        info.deviceType = LookinAppInfoDeviceOthers;
    }
    
    info.osDescription = [UIDevice currentDevice].systemVersion;
    
    NSString *mainVersionStr = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."].firstObject;
    info.osMainVersion = [mainVersionStr integerValue];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    info.screenWidth = screenSize.width;
    info.screenHeight = screenSize.height;
    
    if (type == LookinAppsFetchScreenshotTypeYES) {
        info.screenshot = [self screenshotImage];
    } else if (type == LookinAppsFetchScreenshotTypeUndetermined && ![appInfos containsObject:info]) {
        info.screenshot = [self screenshotImage];
    }
    
    return info;
}

+ (NSString *)appName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [info objectForKey:@"CFBundleDisplayName"];
    NSString *name = [info objectForKey:@"CFBundleName"];
    return displayName.length ? displayName : name;
}

+ (UIImage *)appIcon {
    return [UIImage imageNamed:[[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"] lastObject]];
}

+ (UIImage *)screenshotImage {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0.4);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)isSimulator {
    if (TARGET_OS_SIMULATOR) {
        return YES;
    }
    return NO;
}

#endif

@end
