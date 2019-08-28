//
//  LKS_PerspectiveManager.h
//  LookinServer
//

//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKS_PerspectiveContainerWindow : UIWindow

@end

@interface LKS_PerspectiveManager : NSObject

+ (instancetype)sharedInstance;

- (void)showWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows;

@end
