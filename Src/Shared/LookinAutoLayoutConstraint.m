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

- (void)setFirstAttribute:(NSLayoutAttribute)firstAttribute {
    _firstAttribute = firstAttribute;
    [self _assertUnknownAttribute:firstAttribute];
}

- (void)setSecondAttribute:(NSLayoutAttribute)secondAttribute {
    _secondAttribute = secondAttribute;
    [self _assertUnknownAttribute:secondAttribute];
}

- (void)_assertUnknownAttribute:(NSLayoutAttribute)attribute {
    // 以下几个 assert 用来帮助发现那些系统私有的定义，正式发布时应该去掉这几个 assert
    if (attribute > 21 && attribute < 32) {
        NSAssert(NO, nil);
    }
    if (attribute > 37) {
        NSAssert(NO, nil);
    }
}

#endif

+ (NSString *)descriptionWithItemObject:(LookinObject *)object type:(LookinConstraintItemType)type detailed:(BOOL)detailed {
    switch (type) {
        case LookinConstraintItemTypeNil:
            return detailed ? @"Nil" : @"nil";
            
        case LookinConstraintItemTypeSelf:
            return detailed ? @"Self" : @"self";
            
        case LookinConstraintItemTypeSuper:
            return detailed ? @"Superview" : @"super";
            
        case LookinConstraintItemTypeView:
        case LookinConstraintItemTypeLayoutGuide:
            return detailed ? [NSString stringWithFormat:@"<%@: %@>", object.shortSelfClassName, object.memoryAddress] : [NSString stringWithFormat:@"(%@*)", object.shortSelfClassName];
            
        default:
            NSAssert(NO, @"");
            return detailed ? [NSString stringWithFormat:@"<%@: %@>", object.shortSelfClassName, object.memoryAddress] : [NSString stringWithFormat:@"(%@*)", object.shortSelfClassName];
    }
}

+ (NSString *)descriptionWithAttribute:(NSLayoutAttribute)attribute {
    switch (attribute) {
        case 0 :
            // 在某些业务里确实会出现这种情况，在 Reveal 和 UI Debugger 里也是这么显示的
            return @"notAnAttribute";
        case 1:
            return @"left";
        case 2:
            return @"right";
        case 3:
            return @"top";
        case 4:
            return @"bottom";
        case 5:
            return @"leading";
        case 6:
            return @"trailing";
        case 7:
            return @"width";
        case 8:
            return @"height";
        case 9:
            return @"centerX";
        case 10:
            return @"centerY";
        case 11:
            return @"lastBaseline";
        case 12:
            return @"baseline";
        case 13:
            return @"firstBaseline";
        case 14:
            return @"leftMargin";
        case 15:
            return @"rightMargin";
        case 16:
            return @"topMargin";
        case 17:
            return @"bottomMargin";
        case 18:
            return @"leadingMargin";
        case 19:
            return @"trailingMargin";
        case 20:
            return @"centerXWithinMargins";
        case 21:
            return @"centerYWithinMargins";
            
            // 以下都是和 AutoResizingMask 有关的，这里的定义是从系统 UI Debugger 里抄过来的，暂时没在官方文档里发现它们的公开定义
        case 32:
            return @"minX";
        case 33:
            return @"minY";
        case 34:
            return @"midX";
        case 35:
            return @"midY";
        case 36:
            return @"maxX";
        case 37:
            return @"maxY";
        default:
            NSAssert(NO, @"");
            return [NSString stringWithFormat:@"unknownAttr(%@)", @(attribute)];
    }
}

+ (NSString *)symbolWithRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case -1:
            return @"<=";
        case 0:
            return @"=";
        case 1:
            return @">=";
        default:
            NSAssert(NO, @"");
            return @"?";
    }
}

+ (NSString *)descriptionWithRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case -1:
            return @"LessThanOrEqual";
        case 0:
            return @"Equal";
        case 1:
            return @"GreaterThanOrEqual";
        default:
            NSAssert(NO, @"");
            return @"?";
    }
}

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
