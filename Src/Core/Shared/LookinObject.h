#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinObject.h
//  Lookin
//
//  Created by Li Kai on 2019/4/20.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

@class LookinObjectIvar, LookinIvarTrace;

@interface LookinObject : NSObject <NSSecureCoding, NSCopying>

#if TARGET_OS_IPHONE
+ (instancetype)instanceWithObject:(NSObject *)object;
#endif

@property(nonatomic, assign) unsigned long oid;

@property(nonatomic, copy) NSString *memoryAddress;

/**
 比如有一个 UILabel 对象，则它的 classChainList 为 @[@"UILabel", @"UIView", @"UIResponder", @"NSObject"]，而它的 ivarList 长度为 4，idx 从小到大分别是 UILabel 层级的 ivars, UIView 层级的 ivars.....
 */
@property(nonatomic, copy) NSArray<NSString *> *classChainList;

@property(nonatomic, copy) NSString *specialTrace;

@property(nonatomic, copy) NSArray<LookinIvarTrace *> *ivarTraces;

#pragma mark - Non Coding

/// 在 OC 中，completedSelfClassName 和 shortSelfClassName 返回值一样。在 Swift 中，completedSelfClassName 返回的是带命名空间的（比如 LBFM_Swift.LBFMHomeController 或 _TtC 11TestRuntime14ViewController），而 shortSelfClassName 返回的是没有命名空间的（比如 LBFMHomeController）
@property(nonatomic, copy, readonly) NSString *completedSelfClassName;
@property(nonatomic, copy, readonly) NSString *shortSelfClassName;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
