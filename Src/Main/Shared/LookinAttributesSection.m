#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAttributesSection.m
//  Lookin
//
//  Created by Li Kai on 2019/3/2.
//  https://lookin.work
//



#import "LookinAttributesSection.h"
#import "LookinAttribute.h"

#import "NSArray+Lookin.h"

@implementation LookinAttributesSection

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    LookinAttributesSection *newSection = [[LookinAttributesSection allocWithZone:zone] init];
    newSection.identifier = self.identifier;
    newSection.attributes = [self.attributes lookin_map:^id(NSUInteger idx, LookinAttribute *value) {
        return value.copy;
    }];
    return newSection;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.attributes forKey:@"attributes"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.attributes = [aDecoder decodeObjectForKey:@"attributes"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isUserCustom {
    return [self.identifier isEqualToString:LookinAttrSec_UserCustom];
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
