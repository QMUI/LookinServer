//
//  LKS_ExportManager.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKS_ExportManager : NSObject

+ (instancetype)sharedInstance;

- (void)exportAndShare;

@end
