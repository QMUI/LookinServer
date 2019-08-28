//
//  LKS_PerspectiveItemLayer.h
//  LookinServer
//

//  Copyright © 2019 hughkli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LookinDisplayItem.h"

@interface LKS_PerspectiveItemLayer : CALayer

@property(nonatomic, strong) LookinDisplayItem *displayItem;

- (void)reRender;

@end
