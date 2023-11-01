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

- (instancetype)initWithLayer:(CALayer *)layer;

- (NSArray<LookinAttributesGroup *> *)make;

+ (NSArray<LookinAttributesGroup *> *)makeGroupsFromRawProperties:(NSArray *)rawProperties;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
