//
//  LKS_LocalInspectManager.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/8.
//  https://lookin.work
//

#import "LookinDefines.h"

@interface LKS_LocalInspectContainerWindow : UIWindow

@end

@interface LKS_LocalInspectManager : NSObject

+ (instancetype)sharedInstance;

- (void)startLocalInspectWithIncludedWindows:(NSArray<UIWindow *> *)includedWindows excludedWindows:(NSArray<UIWindow *> *)excludedWindows;

@end
