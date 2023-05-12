#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinIvarTrace.h
//  Lookin
//
//  Created by Li Kai on 2019/4/30.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

extern NSString *const LookinIvarTraceRelationValue_Self;

/// 如果 hostClassName 和 ivarName 均 equal，则认为两个 LookinIvarTrace 对象彼此 equal
/// 比如 A 是 B 的 superview，且 A 的 "_stageView" 指向 B，则 B 会有一个 LookinIvarTrace：hostType 为 “superview”，hostClassName 为 A 的 class，ivarName 为 “_stageView”
@interface LookinIvarTrace : NSObject <NSSecureCoding, NSCopying>

/// 该值可能是 "superview"、"superlayer"、“self” 或 nil
@property(nonatomic, copy) NSString *relation;

@property(nonatomic, copy) NSString *hostClassName;

@property(nonatomic, copy) NSString *ivarName;

#pragma mark - No Coding

#if TARGET_OS_IPHONE
@property(nonatomic, weak) id hostObject;
#endif

@end

@interface NSObject (LookinServerTrace)

@property(nonatomic, copy) NSArray<LookinIvarTrace *> *lks_ivarTraces;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
