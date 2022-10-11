#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinHierarchyFile.h
//  Lookin
//
//  Created by Li Kai on 2019/5/12.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

@class LookinHierarchyInfo;

@interface LookinHierarchyFile : NSObject <NSSecureCoding>

/// 记录创建该文件的 LookinServer 的版本
@property(nonatomic, assign) int serverVersion;

@property(nonatomic, strong) LookinHierarchyInfo *hierarchyInfo;

@property(nonatomic, copy) NSDictionary<NSNumber *, NSData *> *soloScreenshots;
@property(nonatomic, copy) NSDictionary<NSNumber *, NSData *> *groupScreenshots;

/// 验证 file 的版本之类的是否和当前 Lookin 客户端匹配，如果没有问题则返回 nil，如果有问题则返回 error
+ (NSError *)verifyHierarchyFile:(LookinHierarchyFile *)file;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
