//
//  LookinMsgAttribute.h
//  Lookin
//
//  Created by Li Kai on 2019/8/19.
//  https://lookin.work
//



#import "LookinDefines.h"

@interface LookinMsgActionParams : NSObject

@property(nonatomic, strong) id value;
@property(nonatomic, assign) double doubleValue;
@property(nonatomic, assign) NSInteger integerValue;
@property(nonatomic, assign) BOOL boolValue;

@property(nonatomic, weak) id relatedObject;
@property(nonatomic, strong) id userInfo;

@end

@interface LookinMsgAttribute : NSObject

/// 创建一个示例并给予一个初始值
+ (instancetype)attributeWithValue:(id)value;

/// 当前的值
@property(nonatomic, strong, readonly) id currentValue;

/**
 使用 value 作为 currentValue 属性的值
 调用该方法后，所有此前通过 subscribe:action: 相关方法注册的 subscriber 的 action 都会被调用，参数是一个 LookinMsgActionParams 对象
 如果传入了 ignoreSubscriber，则 ignoreSubscriber 这个对象不会收到这次通知
 如果传入的 value 和之前已有的 value 是 equal 的，则该方法不会产生任何效果
 传入的 userInfo 对象可在 LookinMsgActionParams 中被读取
 */
- (void)setValue:(id)value ignoreSubscriber:(id)ignoreSubscriber userInfo:(id)userInfo;

/// target, relatedObject 均不会被强引用，action 方法的参数是一个 LookinMsgActionParams
/// 即使多次调用该方法添加同一个 target，target 也只会收到一次通知
- (void)subscribe:(id)target action:(SEL)action relatedObject:(id)relatedObject;

/// 如果 sendAtOnce 为 YES，则在该方法调用后，会立即收到一条消息
- (void)subscribe:(id)target action:(SEL)action relatedObject:(id)relatedObject sendAtOnce:(BOOL)sendAtOnce;

@end

@interface LookinDoubleMsgAttribute : LookinMsgAttribute

@property(nonatomic, assign, readonly) double currentDoubleValue;

+ (instancetype)attributeWithDouble:(double)value;

- (void)setDoubleValue:(double)doubleValue ignoreSubscriber:(id)ignoreSubscriber;

@end

@interface LookinIntegerMsgAttribute : LookinMsgAttribute

@property(nonatomic, assign, readonly) NSInteger currentIntegerValue;

+ (instancetype)attributeWithInteger:(NSInteger)value;

- (void)setIntegerValue:(NSInteger)integerValue ignoreSubscriber:(id)ignoreSubscriber;

@end

@interface LookinBOOLMsgAttribute : LookinMsgAttribute

@property(nonatomic, assign, readonly) BOOL currentBOOLValue;

+ (instancetype)attributeWithBOOL:(BOOL)value;

- (void)setBOOLValue:(BOOL)BOOLValue ignoreSubscriber:(id)ignoreSubscriber;

@end
