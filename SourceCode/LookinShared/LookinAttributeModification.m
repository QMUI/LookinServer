//
//  LookinAttributeModification.m
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import "LookinAttributeModification.h"

@implementation LookinAttributeModification

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.targetOid) forKey:@"targetOid"];
    [aCoder encodeObject:NSStringFromSelector(self.setterSelector) forKey:@"setterSelector"];
    [aCoder encodeInteger:self.attrType forKey:@"attrType"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.targetOid = [[aDecoder decodeObjectForKey:@"targetOid"] unsignedLongValue];
        self.setterSelector = NSSelectorFromString([aDecoder decodeObjectForKey:@"setterSelector"]);
        self.attrType = [aDecoder decodeIntegerForKey:@"attrType"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
