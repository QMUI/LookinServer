#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAutoLayoutConstraint.m
//  Lookin
//
//  Created by Li Kai on 2019/9/28.
//  https://lookin.work
//



#import "LookinAutoLayoutConstraint.h"
#import "LookinObject.h"

@implementation LookinAutoLayoutConstraint

#if TARGET_OS_IPHONE

+ (instancetype)instanceFromNSConstraint:(NSLayoutConstraint *)constraint isEffective:(BOOL)isEffective firstItemType:(LookinConstraintItemType)firstItemType secondItemType:(LookinConstraintItemType)secondItemType {
    LookinAutoLayoutConstraint *instance = [LookinAutoLayoutConstraint new];
    instance.effective = isEffective;
    instance.active = constraint.active;
    instance.shouldBeArchived = constraint.shouldBeArchived;
    instance.firstItem = [LookinObject instanceWithObject:constraint.firstItem];
    instance.firstItemType = firstItemType;
    instance.firstAttribute = constraint.firstAttribute;
    instance.relation = constraint.relation;
    instance.secondItem = [LookinObject instanceWithObject:constraint.secondItem];
    instance.secondItemType = secondItemType;
    instance.secondAttribute = constraint.secondAttribute;
    instance.multiplier = constraint.multiplier;
    instance.constant = constraint.constant;
    instance.priority = constraint.priority;
    instance.identifier = constraint.identifier;
    
    return instance;
}

- (void)setFirstAttribute:(NSInteger)firstAttribute {
    _firstAttribute = firstAttribute;
    [self _assertUnknownAttribute:firstAttribute];
}

- (void)setSecondAttribute:(NSInteger)secondAttribute {
    _secondAttribute = secondAttribute;
    [self _assertUnknownAttribute:secondAttribute];
}

- (void)_assertUnknownAttribute:(NSInteger)attribute {
    // 以下几个 assert 用来帮助发现那些系统私有的定义，正式发布时应该去掉这几个 assert
    if (attribute > 20 && attribute < 32) {
        NSAssert(NO, nil);
    }
    if (attribute > 37) {
        NSAssert(NO, nil);
    }
}

#endif

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.effective forKey:@"effective"];
    [aCoder encodeBool:self.active forKey:@"active"];
    [aCoder encodeBool:self.shouldBeArchived forKey:@"shouldBeArchived"];
    [aCoder encodeObject:self.firstItem forKey:@"firstItem"];
    [aCoder encodeInteger:self.firstItemType forKey:@"firstItemType"];
    [aCoder encodeInteger:self.firstAttribute forKey:@"firstAttribute"];
    [aCoder encodeInteger:self.relation forKey:@"relation"];
    [aCoder encodeObject:self.secondItem forKey:@"secondItem"];
    [aCoder encodeInteger:self.secondItemType forKey:@"secondItemType"];
    [aCoder encodeInteger:self.secondAttribute forKey:@"secondAttribute"];
    [aCoder encodeDouble:self.multiplier forKey:@"multiplier"];
    [aCoder encodeDouble:self.constant forKey:@"constant"];
    [aCoder encodeDouble:self.priority forKey:@"priority"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.effective = [aDecoder decodeBoolForKey:@"effective"];
        self.active = [aDecoder decodeBoolForKey:@"active"];
        self.shouldBeArchived = [aDecoder decodeBoolForKey:@"shouldBeArchived"];
        self.firstItem = [aDecoder decodeObjectForKey:@"firstItem"];
        self.firstItemType = [aDecoder decodeIntegerForKey:@"firstItemType"];
        self.firstAttribute = [aDecoder decodeIntegerForKey:@"firstAttribute"];
        self.relation = [aDecoder decodeIntegerForKey:@"relation"];
        self.secondItem = [aDecoder decodeObjectForKey:@"secondItem"];
        self.secondItemType = [aDecoder decodeIntegerForKey:@"secondItemType"];
        self.secondAttribute = [aDecoder decodeIntegerForKey:@"secondAttribute"];
        self.multiplier = [aDecoder decodeDoubleForKey:@"multiplier"];
        self.constant = [aDecoder decodeDoubleForKey:@"constant"];
        self.priority = [aDecoder decodeDoubleForKey:@"priority"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
    }
    return self;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
