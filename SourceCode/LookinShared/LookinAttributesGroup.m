//
//  LookinAttributesGroup.m
//  Lookin
//
//  Created by Li Kai on 2018/11/19.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import "LookinAttributesGroup.h"
#import "LookinAttribute.h"
#import "LookinAttributesSection.h"

@implementation LookinAttributesGroup

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    LookinAttributesGroup *newGroup = [[LookinAttributesGroup allocWithZone:zone] init];
    newGroup.identifier = self.identifier;
    newGroup.attrSections = [self.attrSections lookin_map:^id(NSUInteger idx, LookinAttributesSection *value) {
        return value.copy;
    }];
    return newGroup;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.attrSections forKey:@"attrSections"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.attrSections = [aDecoder decodeObjectForKey:@"attrSections"];
    }
    return self;
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinAttributesGroup class]]) {
        return NO;
    }
    if (self.identifier == ((LookinAttributesGroup *)object).identifier) {
        return YES;
    }
    return NO;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif
