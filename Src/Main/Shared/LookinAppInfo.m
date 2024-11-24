#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAppInfo.m
//  qmuidemo
//
//  Created by Li Kai on 2018/11/3.
//  Copyright © 2018 QMUI Team. All rights reserved.
//



#import "LookinAppInfo.h"
#import "LKS_MultiplatformAdapter.h"

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
    newAppInfo.appIcon = self.appIcon;
    newAppInfo.appName = self.appName;
    newAppInfo.deviceDescription = self.deviceDescription;
    newAppInfo.osDescription = self.osDescription;
    newAppInfo.osMainVersion = self.osMainVersion;
    newAppInfo.deviceType = self.deviceType;
    newAppInfo.screenWidth = self.screenWidth;
    newAppInfo.screenHeight = self.screenHeight;
    newAppInfo.screenScale = self.screenScale;
    newAppInfo.appInfoIdentifier = self.appInfoIdentifier;
    return newAppInfo;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.serverVersion = [aDecoder decodeIntForKey:@"serverVersion"];
        self.serverReadableVersion = [aDecoder decodeObjectForKey:@"serverReadableVersion"];
        self.swiftEnabledInLookinServer = [aDecoder decodeIntForKey:@"swiftEnabledInLookinServer"];
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
        self.screenScale = [aDecoder decodeDoubleForKey:@"screenScale"];
        self.appInfoIdentifier = [aDecoder decodeIntegerForKey:@"appInfoIdentifier"];
        self.shouldUseCache = [aDecoder decodeBoolForKey:@"shouldUseCache"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.serverVersion forKey:@"serverVersion"];
    [aCoder encodeObject:self.serverReadableVersion forKey:@"serverReadableVersion"];
    [aCoder encodeInt:self.swiftEnabledInLookinServer forKey:@"swiftEnabledInLookinServer"];
    
#if TARGET_OS_IPHONE
    NSData *screenshotData = UIImagePNGRepresentation(self.screenshot);
    [aCoder encodeObject:screenshotData forKey:CodingKey_Screenshot];
    
    NSData *appIconData = UIImagePNGRepresentation(self.appIcon);
    [aCoder encodeObject:appIconData forKey:CodingKey_AppIcon];
#elif TARGET_OS_OSX
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
    [aCoder encodeDouble:self.screenScale forKey:@"screenScale"];
    [aCoder encodeInteger:self.appInfoIdentifier forKey:@"appInfoIdentifier"];
    [aCoder encodeBool:self.shouldUseCache forKey:@"shouldUseCache"];
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


+ (LookinAppInfo *)currentInfoWithScreenshot:(BOOL)hasScreenshot icon:(BOOL)hasIcon localIdentifiers:(NSArray<NSNumber *> *)localIdentifiers {
    NSInteger selfIdentifier = [self getAppInfoIdentifier];
    if ([localIdentifiers containsObject:@(selfIdentifier)]) {
        LookinAppInfo *info = [LookinAppInfo new];
        info.appInfoIdentifier = selfIdentifier;
        info.shouldUseCache = YES;
        return info;
    }
    
    LookinAppInfo *info = [[LookinAppInfo alloc] init];
    info.serverReadableVersion = LOOKIN_SERVER_READABLE_VERSION;
#ifdef LOOKIN_SERVER_SWIFT_ENABLED
    info.swiftEnabledInLookinServer = 1;
#else
    info.swiftEnabledInLookinServer = -1;
#endif
    info.appInfoIdentifier = selfIdentifier;
    info.appName = [self appName];
#if TARGET_OS_IPHONE
    info.deviceDescription = [UIDevice currentDevice].name;
#endif
    
#if TARGET_OS_OSX
    info.deviceDescription = [NSHost currentHost].localizedName;
#endif
    info.appBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([self isSimulator]) {
        info.deviceType = LookinAppInfoDeviceSimulator;
    } else if ([LKS_MultiplatformAdapter isiPad]) {
        info.deviceType = LookinAppInfoDeviceIPad;
    } else if ([LKS_MultiplatformAdapter isMac]) {
        info.deviceType = LookinAppInfoDeviceMac;
    } else {
        info.deviceType = LookinAppInfoDeviceOthers;
    }
    
#if TARGET_OS_IPHONE
    info.osDescription = [NSString stringWithFormat:@"iOS %@", [UIDevice currentDevice].systemVersion];
    NSString *mainVersionStr = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."].firstObject;
    info.osMainVersion = [mainVersionStr integerValue];
#elif TARGET_OS_OSX
    NSOperatingSystemVersion operatingSystemVersion = [NSProcessInfo processInfo].operatingSystemVersion;
    if (operatingSystemVersion.patchVersion) {
        info.osDescription = [NSString stringWithFormat:@"macOS %ld.%ld.%ld", operatingSystemVersion.majorVersion, operatingSystemVersion.minorVersion, operatingSystemVersion.patchVersion];
    } else {
        info.osDescription = [NSString stringWithFormat:@"macOS %ld.%ld", operatingSystemVersion.majorVersion, operatingSystemVersion.minorVersion];
    }
    info.osMainVersion = operatingSystemVersion.majorVersion;
#endif

    
    CGSize screenSize = [LKS_MultiplatformAdapter mainScreenBounds].size;
    info.screenWidth = screenSize.width;
    info.screenHeight = screenSize.height;
    info.screenScale = [LKS_MultiplatformAdapter mainScreenScale];

    if (hasScreenshot) {
        info.screenshot = [self screenshotImage];
    }
    if (hasIcon) {
        info.appIcon = [self appIcon];
    }
    
    return info;
}

+ (NSString *)appName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [info objectForKey:@"CFBundleDisplayName"];
    NSString *name = [info objectForKey:@"CFBundleName"];
    return displayName.length ? displayName : name;
}

+ (LookinImage *)appIcon {
#if TARGET_OS_TV
    return nil;
#elif TARGET_OS_IPHONE
    NSString *imageName;
    id CFBundleIcons = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"];
    if ([CFBundleIcons respondsToSelector:@selector(objectForKey:)]) {
        id CFBundlePrimaryIcon = [CFBundleIcons objectForKey:@"CFBundlePrimaryIcon"];
        if ([CFBundlePrimaryIcon respondsToSelector:@selector(objectForKey:)]) {
            imageName = [[CFBundlePrimaryIcon objectForKey:@"CFBundleIconFiles"] lastObject];
        } else if ([CFBundlePrimaryIcon isKindOfClass:NSString.class]) {
            imageName = CFBundlePrimaryIcon;
        }
    }
    if (!imageName.length) {
        // 正常情况下拿到的 name 可能比如 “AppIcon60x60”。但某些情况可能为 nil，此时直接 return 否则 [UIImage imageNamed:nil] 可能导致 console 报 "CUICatalog: Invalid asset name supplied: '(null)'" 的错误信息
        return nil;
    }
    return [UIImage imageNamed:imageName];
#elif TARGET_OS_OSX
    return [[NSApplication sharedApplication] applicationIconImage];
#endif
}

+ (LookinImage *)screenshotImage {
    LookinWindow *window = [LKS_MultiplatformAdapter keyWindow];
    if (!window) {
        return nil;
    }
#if TARGET_OS_IPHONE
    CGSize size = window.bounds.size;
    if (size.width <= 0 || size.height <= 0) {
        // *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'UIGraphicsBeginImageContext() failed to allocate CGBitampContext: size={0, 0}, scale=3.000000, bitmapInfo=0x2002. Use UIGraphicsImageRenderer to avoid this assert.'

        // https://github.com/hughkli/Lookin/issues/21
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.4);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#elif TARGET_OS_OSX
    if (!window) {
        return nil;
    }
    CGImageRef cgImage = CGWindowListCreateImage(CGRectZero, kCGWindowListOptionIncludingWindow, (int)window.windowNumber, kCGWindowImageBoundsIgnoreFraming);
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:window.frame.size];
    CGImageRelease(cgImage);
#endif
    
    return image;
}

+ (BOOL)isSimulator {
    if (TARGET_OS_SIMULATOR) {
        return YES;
    }
    return NO;
}


+ (NSInteger)getAppInfoIdentifier {
    static dispatch_once_t onceToken;
    static NSInteger identifier = 0;
    dispatch_once(&onceToken,^{
        identifier = [[NSDate date] timeIntervalSince1970];
    });
    return identifier;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
