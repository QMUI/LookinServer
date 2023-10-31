#ifdef SHOULD_COMPILE_LOOKIN_SERVER
//
//  LKS_CustomAttrGroupsMaker.h
//  LookinServer
//
//  Created by LikaiMacStudioWork on 2023/10/31.
//

#import "LookinDefines.h"

@class LookinAttributesGroup;

@interface LKS_CustomAttrGroupsMaker : NSObject

+ (NSArray<LookinAttributesGroup *> *)customAttrGroupsForLayer:(CALayer *)layer;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
