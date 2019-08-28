//
//  LookinAttributesGroup.m
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import "LookinAttributesGroup.h"
#import "LookinAttribute.h"
#import "LookinAttributesSection.h"

@implementation LookinAttributesGroup

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.identifier) forKey:@"identifier"];
    [aCoder encodeObject:self.attrSections forKey:@"attrSections"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] unsignedIntegerValue];
        self.attrSections = [aDecoder decodeObjectForKey:@"attrSections"];
    }
    return self;
}

- (NSUInteger)hash {
    return self.identifier;
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

+ (NSString *)titleWithIdentifier:(LookinAttrGroupIdentifier)identifier {
    switch (identifier) {
        case LookinAttrGroup_Class:
            return @"Class";
        case LookinAttrGroup_Relation:
            return @"Relation";
        case LookinAttrGroup_Frame:
            return @"Frame";
        case LookinAttrGroup_Bounds:
            return @"Bounds";
        case LookinAttrGroup_SafeArea:
            return @"Safe Area";
        case LookinAttrGroup_LayerView:
            return @"CALayer / UIView";
        case LookinAttrGroup_UILabel:
            return @"UILabel";
        case LookinAttrGroup_UIControl:
            return @"UIControl";
        case LookinAttrGroup_UIButton:
            return @"UIButton";
        case LookinAttrGroup_UIScrollView:
            return @"UIScrollView";
        case LookinAttrGroup_UITableView:
            return @"UITableView";
        case LookinAttrGroup_UITextView:
            return @"UITextView";
        case LookinAttrGroup_UITextField:
            return @"UITextField";
        default:
            NSAssert(NO, @"");
            return @"";
    }
}

@end
