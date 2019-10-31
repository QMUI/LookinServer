//
//  LookinAttribute.m
//  qmuidemo
//
//  Created by Li Kai on 2018/11/17.
//  Copyright © 2018 QMUI Team. All rights reserved.
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import "LookinAttribute.h"
#import "LookinDisplayItem.h"

@implementation LookinAttribute

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    LookinAttribute *newAttr = [[LookinAttribute allocWithZone:zone] init];
    newAttr.identifier = self.identifier;
    newAttr.value = self.value;
    newAttr.attrType = self.attrType;
    return newAttr;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeInteger:self.attrType forKey:@"attrType"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.attrType = [aDecoder decodeIntegerForKey:@"attrType"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif
