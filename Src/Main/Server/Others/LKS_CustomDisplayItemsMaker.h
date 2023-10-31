#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LKS_CustomDisplayItemsMaker.h
//  LookinServer
//
//  Created by likai.123 on 2023/11/1.
//

#import <Foundation/Foundation.h>

@class LookinDisplayItem;

@interface LKS_CustomDisplayItemsMaker : NSObject

- (instancetype)initWithLayer:(CALayer *)layer;

- (NSArray<LookinDisplayItem *> *)make;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
