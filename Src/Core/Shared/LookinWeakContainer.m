//
//  LookinWeakContainer.m
//  Lookin
//
//  Created by Li Kai on 2019/8/14.
//  https://lookin.work
//



#import "LookinWeakContainer.h"

@implementation LookinWeakContainer

+ (instancetype)containerWithObject:(id)object {
    LookinWeakContainer *container = [LookinWeakContainer new];
    container.object = object;
    return container;
}

- (NSUInteger)hash {
    return [self.object hash];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinWeakContainer class]]) {
        return NO;
    }
    LookinWeakContainer *comparedObj = object;
    if ([self.object isEqual:comparedObj.object]) {
        return YES;
    }
    return NO;
}

@end
