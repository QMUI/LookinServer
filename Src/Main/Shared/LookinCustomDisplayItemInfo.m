#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LookinCustomDisplayItemInfo.m
//  LookinServer
//
//  Created by likai.123 on 2023/11/1.
//

#import "LookinCustomDisplayItemInfo.h"

@implementation LookinCustomDisplayItemInfo

- (id)copyWithZone:(NSZone *)zone {
    LookinCustomDisplayItemInfo *newInstance = [[LookinCustomDisplayItemInfo allocWithZone:zone] init];
    
    if (self.frameInWindow) {
        CGRect rect = [self.frameInWindow CGRectValue];
        newInstance.frameInWindow = [NSValue valueWithCGRect:rect];
    }
    
    return newInstance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.frameInWindow forKey:@"frameInWindow"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.frameInWindow = [aDecoder decodeObjectForKey:@"frameInWindow"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
