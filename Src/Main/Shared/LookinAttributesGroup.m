#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAttributesGroup.m
//  Lookin
//
//  Created by Li Kai on 2018/11/19.
//  https://lookin.work
//



#import "LookinAttributesGroup.h"
#import "LookinAttribute.h"
#import "LookinAttributesSection.h"

#import "NSArray+Lookin.h"

@implementation LookinAttributesGroup

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    LookinAttributesGroup *newGroup = [[LookinAttributesGroup allocWithZone:zone] init];
    newGroup.isUserCustom = self.isUserCustom;
    newGroup.userCustomTitle = self.userCustomTitle;
    newGroup.identifier = self.identifier;
    newGroup.attrSections = [self.attrSections lookin_map:^id(NSUInteger idx, LookinAttributesSection *value) {
        return value.copy;
    }];
    return newGroup;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.isUserCustom forKey:@"isUserCustom"];
    [aCoder encodeObject:self.userCustomTitle forKey:@"userCustomTitle"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.attrSections forKey:@"attrSections"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.isUserCustom = [aDecoder decodeBoolForKey:@"isUserCustom"];
        self.userCustomTitle = [aDecoder decodeObjectForKey:@"userCustomTitle"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.attrSections = [aDecoder decodeObjectForKey:@"attrSections"];
    }
    return self;
}

- (NSUInteger)hash {
    if (self.isUserCustom) {
        return self.userCustomTitle.hash;
    } else {
        return self.identifier.hash;
    }
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinAttributesGroup class]]) {
        return NO;
    }
    LookinAttributesGroup *targetObject = object;
    
    if (self.isUserCustom != targetObject.isUserCustom) {
        return false;
    }
    if (self.isUserCustom) {
        BOOL ret = [self.userCustomTitle isEqualToString:targetObject.userCustomTitle];
        return ret;
    } else {
        BOOL ret = (self.identifier == targetObject.identifier);
        return ret;
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
