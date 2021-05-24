//
//  LKS_ExportManager.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/13.
//  https://lookin.work
//

#import <Foundation/Foundation.h>

@interface LKS_ExportManager : NSObject

+ (instancetype)sharedInstance;

- (void)exportAndShare;

@end
