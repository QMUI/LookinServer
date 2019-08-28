//
//  LookinIvarTrace.m
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LookinIvarTrace.h"

@implementation LookinIvarTrace

- (NSUInteger)hash {
    return self.hostClassName.hash ^ self.ivarName.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinIvarTrace class]]) {
        return NO;
    }
    LookinIvarTrace *comparedObj = object;
    if ([self.hostClassName isEqualToString:comparedObj.hostClassName] && [self.ivarName isEqualToString:comparedObj.ivarName]) {
        return YES;
    }
    return NO;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.hostClassName forKey:@"hostClassName"];
    [aCoder encodeObject:self.ivarName forKey:@"ivarName"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.hostClassName = [aDecoder decodeObjectForKey:@"hostClassName"];
        self.ivarName = [aDecoder decodeObjectForKey:@"ivarName"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
