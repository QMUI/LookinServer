#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinStaticAsyncUpdateTask.h
//  Lookin
//
//  Created by Li Kai on 2019/6/21.
//  https://lookin.work
//



#import "LookinDefines.h"

typedef NS_ENUM(NSInteger, LookinStaticAsyncUpdateTaskType) {
    LookinStaticAsyncUpdateTaskTypeNoScreenshot,
    LookinStaticAsyncUpdateTaskTypeSoloScreenshot,
    LookinStaticAsyncUpdateTaskTypeGroupScreenshot
};

typedef NS_ENUM(NSInteger, LookinDetailUpdateTaskAttrRequest) {
    /// 由 Server 端自己决定：同一批 task 里，server 端会保证同一个 layer 只会构造一次 attr
    /// 在 Lookin turbo 模式下，由于同一个 layer 的 task 可能位于不同批的 task 里，因此这会导致冗余的 attr 构造行为、浪费一定时间
    LookinDetailUpdateTaskAttrRequest_Automatic,
    /// 需要返回 attr
    LookinDetailUpdateTaskAttrRequest_Need,
    /// 不需要返回 attr
    LookinDetailUpdateTaskAttrRequest_NotNeed
};

/// 业务重写了 isEqual
@interface LookinStaticAsyncUpdateTask : NSObject <NSSecureCoding>

@property(nonatomic, assign) unsigned long oid;

@property(nonatomic, assign) LookinStaticAsyncUpdateTaskType taskType;

/// 是否需要返回 attr 数据，默认为 Automatic
/// Client 1.0.7 & Server 1.2.7 开始支持这个参数
@property(nonatomic, assign) LookinDetailUpdateTaskAttrRequest attrRequest;

/// 如果置为 YES，则 server 侧会返回这些基础信息：frameValue, boundsValue, hiddenValue, alphaValue
/// 默认为 NO
/// Client 1.0.7 & Server 1.2.7 开始支持这个参数
@property(nonatomic, assign) BOOL needBasisVisualInfo;

/// 如果置为 YES，则 server 侧会返回 subitems
/// 默认为 NO
/// Client 1.0.7 & Server 1.2.7 开始支持这个参数
@property(nonatomic, assign) BOOL needSubitems;

/// Client 1.0.4 开始加入这个参数
@property(nonatomic, copy) NSString *clientReadableVersion;

#pragma mark - Non Coding

@property(nonatomic, assign) CGSize frameSize;

@end

@interface LookinStaticAsyncUpdateTasksPackage : NSObject <NSSecureCoding>

@property(nonatomic, copy) NSArray<LookinStaticAsyncUpdateTask *> *tasks;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
