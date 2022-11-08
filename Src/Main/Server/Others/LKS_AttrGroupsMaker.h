#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_AttrGroupsMaker.h
//  LookinServer
//
//  Created by Li Kai on 2019/6/6.
//  https://lookin.work
//

#import "LookinDefines.h"

@class LookinAttributesGroup;

@interface LKS_AttrGroupsMaker : NSObject

+ (NSArray<LookinAttributesGroup *> *)attrGroupsForLayer:(CALayer *)layer;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
