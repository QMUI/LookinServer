//
//  LKS_TraceManager.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/5.
//  https://lookin.work
//



#import <Foundation/Foundation.h>

@class LookinIvarTrace;

@interface LKS_TraceManager : NSObject

+ (instancetype)sharedInstance;

- (void)reload;

@end
