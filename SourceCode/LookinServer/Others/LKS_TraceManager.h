//
//  LKS_TraceManager.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinIvarTrace;

@interface LKS_TraceManager : NSObject

+ (instancetype)sharedInstance;

- (void)reload;

@end
