//
//  LKS_LocalInspectManager.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKS_LocalInspectContainerWindow : UIWindow

@end

@interface LKS_LocalInspectManager : NSObject

+ (instancetype)sharedInstance;

- (void)startLocalInspectWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows;

@end
