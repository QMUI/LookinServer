//
//  LKS_AttrGroupsMaker.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/6.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <Foundation/Foundation.h>

@class LookinAttributesGroup;

@interface LKS_AttrGroupsMaker : NSObject

+ (NSArray<LookinAttributesGroup *> *)attrGroupsForLayer:(CALayer *)layer;

@end

#endif
