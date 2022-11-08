#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAppInfo.h
//  qmuidemo
//
//  Created by Li Kai on 2018/11/3.
//  Copyright © 2018 QMUI Team. All rights reserved.
//



#import "LookinDefines.h"

typedef NS_ENUM(NSInteger, LookinAppInfoDevice) {
    LookinAppInfoDeviceSimulator,   // 模拟器
    LookinAppInfoDeviceIPad,    // iPad 真机
    LookinAppInfoDeviceOthers   // 应该视为 iPhone 真机
};

@interface LookinAppInfo : NSObject <NSSecureCoding, NSCopying>

/// 每次启动 app 时都会随机生成一个 appInfoIdentifier 直到 app 被 kill 掉
@property(nonatomic, assign) NSUInteger appInfoIdentifier;
/// mac 端应该先读取该属性，如果为 YES 则表示应该使用之前保存的旧 appInfo 对象即可
@property(nonatomic, assign) BOOL shouldUseCache;
/// LookinServer 的版本
@property(nonatomic, assign) int serverVersion;
/// app 的当前截图
@property(nonatomic, strong) LookinImage *screenshot;
/// 可能为 nil，比如新建的 iOS 空项目
@property(nonatomic, strong) LookinImage *appIcon;
/// @"微信读书"
@property(nonatomic, copy) NSString *appName;
/// hughkli.lookin
@property(nonatomic, copy) NSString *appBundleIdentifier;
/// @"iPhone X"
@property(nonatomic, copy) NSString *deviceDescription;
/// @"12.1"
@property(nonatomic, copy) NSString *osDescription;
/// 返回 os 的主版本号，比如 iOS 12.1 的设备将返回 12，iOS 13.2.1 的设备将返回 13
@property(nonatomic, assign) NSUInteger osMainVersion;
/// 设备类型
@property(nonatomic, assign) LookinAppInfoDevice deviceType;
/// 屏幕的宽度
@property(nonatomic, assign) double screenWidth;
/// 屏幕的高度
@property(nonatomic, assign) double screenHeight;
/// 是几倍的屏幕
@property(nonatomic, assign) double screenScale;

- (BOOL)isEqualToAppInfo:(LookinAppInfo *)info;

#if TARGET_OS_IPHONE

+ (LookinAppInfo *)currentInfoWithScreenshot:(BOOL)hasScreenshot icon:(BOOL)hasIcon localIdentifiers:(NSArray<NSNumber *> *)localIdentifiers;

#else

@property(nonatomic, assign) NSTimeInterval cachedTimestamp;

#endif

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
