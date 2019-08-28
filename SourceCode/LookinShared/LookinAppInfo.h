//
//  LookinAppInfo.h
//  
//
//
//

#import "LookinDefines.h"

typedef NS_ENUM(NSInteger, LookinAppInfoDevice) {
    LookinAppInfoDeviceSimulator,   // 模拟器
    LookinAppInfoDeviceIPad,    // iPad 真机
    LookinAppInfoDeviceOthers   // 应该视为 iPhone 真机
};

typedef NS_ENUM(NSInteger, LookinAppsFetchScreenshotType) {
    LookinAppsFetchScreenshotTypeNo,
    LookinAppsFetchScreenshotTypeYES,
    LookinAppsFetchScreenshotTypeUndetermined
};

@interface LookinAppInfo : NSObject <NSSecureCoding, NSCopying>

@property(nonatomic, assign) int serverVersion;

@property(nonatomic, strong) LookinImage *screenshot;
/// 可能为 nil，比如新建的 iOS 空项目
@property(nonatomic, strong) LookinImage *appIcon;

@property(nonatomic, copy) NSString *appName;   // e.g. @"微信读书"
@property(nonatomic, copy) NSString *appBundleIdentifier;   // e.g. hughkli.lookin
@property(nonatomic, copy) NSString *deviceDescription; // e.g. @"iPhone X"
@property(nonatomic, copy) NSString *osDescription; // e.g. @"12.1"
@property(nonatomic, assign) NSUInteger osMainVersion; // 返回 os 的主版本号，比如 iOS 12.1 的设备将返回 12，iOS 13.2.1 的设备将返回 13
@property(nonatomic, assign) LookinAppInfoDevice deviceType;

@property(nonatomic, assign) double screenWidth;
@property(nonatomic, assign) double screenHeight;

- (BOOL)isEqualToAppInfo:(LookinAppInfo *)info;

#if TARGET_OS_IPHONE

+ (LookinAppInfo *)currentInfoWithScreenshotType:(LookinAppsFetchScreenshotType)type appInfos:(NSArray<LookinAppInfo *> *)appInfos;

#endif

@end
