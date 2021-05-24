//
//  LKS_PerspectiveManager.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//



#import "LookinDefines.h"

@interface LKS_PerspectiveContainerWindow : UIWindow

@end

@interface LKS_PerspectiveManager : NSObject

+ (instancetype)sharedInstance;

- (void)showWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows;

@end
