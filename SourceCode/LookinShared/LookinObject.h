//
//  LookinObject.h
//  LookinClient
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinObjectIvar, LookinIvarTrace;

@interface LookinObject : NSObject <NSSecureCoding>

#if TARGET_OS_IPHONE
+ (instancetype)instanceWithObject:(NSObject *)object;
#endif

@property(nonatomic, assign) unsigned long oid;

@property(nonatomic, copy) NSString *memoryAddress;

/**
 比如有一个 UILabel 对象，则它的 classChainList 为 @[@"UILabel", @"UIView", @"UIResponder", @"NSObject"]，而它的 ivarList 长度为 4，idx 从小到大分别是 UILabel 层级的 ivars, UIView 层级的 ivars.....
 */
@property(nonatomic, copy) NSArray<NSString *> *classChainList;

/// 当该属性为 nil 时，说明尚未拉取
@property(nonatomic, copy) NSArray<NSArray<LookinObjectIvar *> *> *ivarList;

@property(nonatomic, copy) NSString *specialTrace;

@property(nonatomic, copy) NSArray<LookinIvarTrace *> *ivarTraces;

#pragma mark - Non Coding

/// 在 OC 中，selfClassName 和 nonNamespaceSelfClassName 返回值一样。在 Swift 中，selfClassName 返回的是带命名空间的（比如 LBFM_Swift.LBFMHomeController），而 nonNamespaceSelfClassName 返回的是没有命名空间的（比如 LBFMHomeController）
@property(nonatomic, copy, readonly) NSString *selfClassName;
@property(nonatomic, copy, readonly) NSString *nonNamespaceSelfClassName;

@property(nonatomic, copy) NSString *introduction;

@end
