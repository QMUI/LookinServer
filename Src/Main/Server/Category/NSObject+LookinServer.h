#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  NSObject+LookinServer.h
//  LookinServer
//
//  Created by Li Kai on 2019/4/21.
//  https://lookin.work
//

#import "LookinDefines.h"
#import <Foundation/Foundation.h>

@class LookinIvarTrace;

@interface NSObject (LookinServer)

#pragma mark - oid

/// 如果 oid 不存在则会创建新的 oid
- (unsigned long)lks_registerOid;

/// 0 表示不存在
@property(nonatomic, assign) unsigned long lks_oid;

+ (NSObject *)lks_objectWithOid:(unsigned long)oid;

#pragma mark - trace

@property(nonatomic, copy) NSString *lks_specialTrace;

+ (void)lks_clearAllObjectsTraces;

/**
 获取当前对象的 Class 层级树，如 @[@"UIView", @"UIResponder", @"NSObject"]。未 demangle，有 Swift Module Name
 */
- (NSArray<NSString *> *)lks_classChainList;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
