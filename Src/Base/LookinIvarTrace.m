#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinIvarTrace.m
//  Lookin
//
//  Created by Li Kai on 2019/4/30.
//  https://lookin.work
//

#import "LookinIvarTrace.h"

NSString *const LookinIvarTraceRelationValue_Self = @"self";

@implementation LookinIvarTrace

#pragma mark - Equal

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

#pragma mark - <NSCopying>
    
- (id)copyWithZone:(NSZone *)zone {
    LookinIvarTrace *newTrace = [[LookinIvarTrace allocWithZone:zone] init];
    newTrace.relation = self.relation;
    newTrace.hostClassName = self.hostClassName;
    newTrace.ivarName = self.ivarName;
    return newTrace;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.relation forKey:@"relation"];
    [aCoder encodeObject:self.hostClassName forKey:@"hostClassName"];
    [aCoder encodeObject:self.ivarName forKey:@"ivarName"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.relation = [aDecoder decodeObjectForKey:@"relation"];
        self.hostClassName = [aDecoder decodeObjectForKey:@"hostClassName"];
        self.ivarName = [aDecoder decodeObjectForKey:@"ivarName"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
