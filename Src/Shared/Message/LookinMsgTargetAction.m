//
//  LookinMsgTargetAction.m
//  Lookin
//
//  Created by Li Kai on 2019/8/19.
//  https://lookin.work
//

#import "LookinMsgTargetAction.h"



@implementation LookinMsgTargetAction

- (NSUInteger)hash {
    return [self.target hash] ^ NSStringFromSelector(self.action).hash ^ [self.relatedObject hash];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinMsgTargetAction class]]) {
        return NO;
    }
    LookinMsgTargetAction *comparedObj = object;
    if (self.target == comparedObj.target && [NSStringFromSelector(self.action) isEqual:NSStringFromSelector(comparedObj.action)] && self.relatedObject == comparedObj.relatedObject) {
        return YES;
    }
    return NO;
}

@end
