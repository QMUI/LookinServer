//
//  LKS_MethodTraceManager.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/22.
//  https://lookin.work
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
