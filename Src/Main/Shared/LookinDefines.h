#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinMessageProtocol.h
//  Lookin
//
//  Created by Li Kai on 2018/8/6.
//  https://lookin.work
//

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Appkit/Appkit.h>
#endif

#include <stdint.h>

#pragma mark - Version

/// current connection protocol version of LookinServer
static const int LOOKIN_SERVER_VERSION = 7;

/// current release version of LookinServer
static NSString * const LOOKIN_SERVER_READABLE_VERSION = @"1.2.5";

/// current connection protocol version of LookinClient
static const int LOOKIN_CLIENT_VERSION = 7;

/// the minimum connection protocol version supported by current LookinClient
static const int LOOKIN_SUPPORTED_SERVER_MIN = 7;
/// the maximum connection protocol version supported by current LookinClient
static const int LOOKIN_SUPPORTED_SERVER_MAX = 7;

#pragma mark - Connection

/// LookinServer 在真机上会依次尝试监听 47175 ~ 47179 这几个端口
static const int LookinUSBDeviceIPv4PortNumberStart = 47175;
static const int LookinUSBDeviceIPv4PortNumberEnd = 47179;

/// LookinServer 在模拟器中会依次尝试监听 47164 ~ 47169 这几个端口
static const int LookinSimulatorIPv4PortNumberStart = 47164;
static const int LookinSimulatorIPv4PortNumberEnd = 47169;

enum {
    /// 确认两端是否可以响应通讯
    LookinRequestTypePing = 200,
    /// 请求 App 的截图、设备型号等信息
    LookinRequestTypeApp = 201,
    /// 请求 Hierarchy 信息
    LookinRequestTypeHierarchy = 202,
    /// 请求 screenshots 和 attrGroups 信息
    LookinRequestTypeHierarchyDetails = 203,
    /// 请求修改某个内置的 Attribute 的值
    LookinRequestTypeInbuiltAttrModification = 204,
    /// 修改某个 attr 后，请求一系列最新的 Screenshots、属性值等信息
    LookinRequestTypeAttrModificationPatch = 205,
    /// 执行某个方法
    LookinRequestTypeInvokeMethod = 206,
    /**
     @request: @{@"oid":}
     @response: LookinObject *
     */
    LookinRequestTypeFetchObject = 207,
    
    LookinRequestTypeFetchImageViewImage = 208,
    
    LookinRequestTypeModifyRecognizerEnable = 209,
    
    /// 请求 attribute group list
    LookinRequestTypeAllAttrGroups = 210,
    
    /// 请求 iOS App 里某个 class 的所有 selector 名字列表（包括 superclass）
    LookinRequestTypeAllSelectorNames = 213,
    
    /// 请求修改某个自定义 Attribute 的值
    LookinRequestTypeCustomAttrModification = 214,
    
    LookinPush_BringForwardScreenshotTask = 303,
    // 用户在 Lookin 客户端取消了之前 HierarchyDetails 的拉取
    LookinPush_CanceHierarchyDetails = 304,
};

static NSString * const LookinParam_ViewLayerTag = @"tag";

static NSString * const LookinParam_SelectorName = @"sn";
static NSString * const LookinParam_MethodType = @"mt";
static NSString * const LookinParam_SelectorClassName = @"scn";

static NSString * const LookinStringFlag_VoidReturn = @"LOOKIN_TAG_RETURN_VALUE_VOID";

#pragma mark - Error

static NSString * const LookinErrorDomain = @"LookinError";

enum {
    LookinErrCode_Default = -400,
    /// Lookin 内部业务逻辑错误
    LookinErrCode_Inner = -401,
    /// PeerTalk 内部错误
    LookinErrCode_PeerTalk = -402,
    /// 连接不存在或已断开
    LookinErrCode_NoConnect = -403,
    /// ping 失败了，原因是 ping 请求超时
    LookinErrCode_PingFailForTimeout = -404,
    /// 请求超时未返回
    LookinErrCode_Timeout = -405,
    /// 有相同 Type 的新请求被发出，因此旧请求被丢弃
    LookinErrCode_Discard = -406,
    /// ping 失败了，原因是 app 主动报告自身正处于后台模式
    LookinErrCode_PingFailForBackgroundState = -407,
    
    /// 没有找到对应的对象，可能已被释放
    LookinErrCode_ObjectNotFound = -500,
    /// 不支持修改当前类型的 LookinCodingValueType
    LookinErrCode_ModifyValueTypeInvalid = -501,
    LookinErrCode_Exception = -502,
    
    // LookinServer 版本过高，要升级 client
    LookinErrCode_ServerVersionTooHigh = -600,
    // LookinServer 版本过低，要升级 server
    LookinErrCode_ServerVersionTooLow = -601,
    
    // 不支持的文件类型
    LookinErrCode_UnsupportedFileType = -700,
};

#define LookinErr_ObjNotFound [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_ObjectNotFound userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Failed to get target object in iOS app", nil), NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Perhaps the related object was deallocated. You can reload Lookin to get newest data.", nil)}]

#define LookinErr_NoConnect [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_NoConnect userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"The operation failed due to disconnection with the iOS app.", nil)}]

#define LookinErr_Inner [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_Inner userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"The operation failed due to an inner error.", nil)}]

#define LookinErrorMake(errorTitle, errorDetail) [NSError errorWithDomain:LookinErrorDomain code:LookinErrCode_Default userInfo:@{NSLocalizedDescriptionKey:errorTitle, NSLocalizedRecoverySuggestionErrorKey:errorDetail}]

#define LookinErrorText_Timeout NSLocalizedString(@"Perhaps your iOS app is paused with breakpoint in Xcode, blocked by other tasks in main thread, or moved to background state.", nil)

#pragma mark - Colors

#if TARGET_OS_IPHONE
#define LookinColor UIColor
#define LookinInsets UIEdgeInsets
#define LookinImage UIImage
#elif TARGET_OS_MAC
#define LookinColor NSColor
#define LookinInsets NSEdgeInsets
#define LookinImage NSImage
#endif

#define LookinColorRGBAMake(r, g, b, a) [LookinColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define LookinColorMake(r, g, b) [LookinColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#pragma mark - Preview

/// SCNNode 所允许的图片的最大的长和宽，单位是 px，这个值是 Scenekit 自身指定的
/// Max pixel size of a SCNNode object. It is designated by SceneKit.
static const double LookinNodeImageMaxLengthInPx = 16384;

typedef NS_OPTIONS(NSUInteger, LookinPreviewBitMask) {
    LookinPreviewBitMask_None = 0,
    
    LookinPreviewBitMask_Selectable = 1 << 1,
    LookinPreviewBitMask_Unselectable = 1 << 2,
    
    LookinPreviewBitMask_HasLight = 1 << 3,
    LookinPreviewBitMask_NoLight = 1 << 4
};

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
