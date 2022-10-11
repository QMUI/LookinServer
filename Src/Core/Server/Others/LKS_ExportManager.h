#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

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

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
