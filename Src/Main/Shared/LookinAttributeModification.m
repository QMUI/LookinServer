#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAttributeModification.m
//  Lookin
//
//  Created by Li Kai on 2018/11/20.
//  https://lookin.work
//

#import "LookinAttributeModification.h"

@implementation LookinAttributeModification

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.targetOid) forKey:@"targetOid"];
    [aCoder encodeObject:NSStringFromSelector(self.setterSelector) forKey:@"setterSelector"];
    [aCoder encodeInteger:self.attrType forKey:@"attrType"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.clientReadableVersion forKey:@"clientReadableVersion"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.targetOid = [[aDecoder decodeObjectForKey:@"targetOid"] unsignedLongValue];
        self.setterSelector = NSSelectorFromString([aDecoder decodeObjectForKey:@"setterSelector"]);
        self.attrType = [aDecoder decodeIntegerForKey:@"attrType"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.clientReadableVersion = [aDecoder decodeObjectForKey:@"clientReadableVersion"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
