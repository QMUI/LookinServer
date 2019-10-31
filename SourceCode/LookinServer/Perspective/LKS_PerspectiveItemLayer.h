//
//  LKS_PerspectiveItemLayer.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <QuartzCore/QuartzCore.h>
#import "LookinDisplayItem.h"

@interface LKS_PerspectiveItemLayer : CALayer

@property(nonatomic, strong) LookinDisplayItem *displayItem;

- (void)reRender;

@end

#endif
