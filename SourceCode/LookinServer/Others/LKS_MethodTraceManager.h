//
//  LKS_MethodTraceManager.h
//  LookinServer
//
//  
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKS_MethodTraceManager : NSObject

+ (instancetype)sharedInstance;

/// selName 不可以是 "dealloc"
- (void)addWithClassName:(NSString *)className selName:(NSString *)selName;

- (void)removeWithClassName:(NSString *)className selName:(NSString *)selName;

/**
 @[
    @{@"class": @"UIViewController", @"sels": @[@"init", @"viewDidAppear:"]},
    @{@"class": @"UIView", @"sels": @[@"init", @"layoutSubviews"]}
 ];
 */
- (NSArray<NSDictionary<NSString *, id> *> *)currentActiveTraceList;

- (NSArray<NSString *> *)allClassesListInApp;

@end
