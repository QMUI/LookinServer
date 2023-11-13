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
#import "LookinDashboardBlueprint.h"
#import "NSArray+Lookin.h"

@implementation LookinAttributesGroup

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    LookinAttributesGroup *newGroup = [[LookinAttributesGroup allocWithZone:zone] init];
    newGroup.userCustomTitle = self.userCustomTitle;
    newGroup.identifier = self.identifier;
    newGroup.attrSections = [self.attrSections lookin_map:^id(NSUInteger idx, LookinAttributesSection *value) {
        return value.copy;
    }];
    return newGroup;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userCustomTitle forKey:@"userCustomTitle"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.attrSections forKey:@"attrSections"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.userCustomTitle = [aDecoder decodeObjectForKey:@"userCustomTitle"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.attrSections = [aDecoder decodeObjectForKey:@"attrSections"];
    }
    return self;
}

- (NSUInteger)hash {
    return self.uniqueKey.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinAttributesGroup class]]) {
        return NO;
    }
    LookinAttributesGroup *targetObject = object;
    
    if (![self.identifier isEqualToString:targetObject.identifier]) {
        return false;
    }
    if ([self.identifier isEqualToString:LookinAttrGroup_UserCustom]) {
        BOOL ret = [self.userCustomTitle isEqualToString:targetObject.userCustomTitle];
        return ret;
    } else {
        return true;
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSString *)uniqueKey {
    if ([self.identifier isEqualToString:LookinAttrGroup_UserCustom]) {
        return self.userCustomTitle;
    } else {
        return self.identifier;
    }
}

- (BOOL)isUserCustom {
    return [self.identifier isEqualToString:LookinAttrSec_UserCustom];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
