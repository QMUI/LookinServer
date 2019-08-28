//
//  NSObject+LookinServer.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinIvarTrace;

@interface NSObject (LookinServer)

#pragma mark - oid

/// 如果 oid 已经存在，则该方法不会产生任何作用
- (void)lks_registerOid;

/// 0 表示不存在
@property(nonatomic, assign) unsigned long lks_oid;

+ (NSObject *)lks_objectWithOid:(unsigned long)oid;

#pragma mark - trace

@property(nonatomic, copy) NSArray<LookinIvarTrace *> *lks_ivarTraces;

@property(nonatomic, copy) NSString *lks_specialTrace;

+ (void)lks_clearAllObjectsTraces;

/**
 获取当前对象的 Class 层级树，如 @[@"UIView", @"UIResponder", @"NSObject"];
 */
- (NSArray<NSString *> *)lks_classChainList;

@end
