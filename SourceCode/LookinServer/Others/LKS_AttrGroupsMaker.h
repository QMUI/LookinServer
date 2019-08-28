//
//  LKS_AttrGroupsMaker.h
//  LookinServer
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinAttributesGroup;

@interface LKS_AttrGroupsMaker : NSObject

+ (NSArray<LookinAttributesGroup *> *)attrGroupsForLayer:(CALayer *)layer;

@end
