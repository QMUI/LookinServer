//
//  LookinAttributesSection.m
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LookinAttributesSection.h"
#import "LookinAttribute.h"

@implementation LookinAttributesSection

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.attributes forKey:@"attributes"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeIntegerForKey:@"identifier"];
        self.attributes = [aDecoder decodeObjectForKey:@"attributes"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (NSString *)titleWithIdentifier:(LookinAttrSectionIdentifier)identifier {
    switch (identifier) {
        case LookinAttrSec_ViewLayer_Corner:
            return @"CornerRadius";
        case LookinAttrSec_ViewLayer_BgColor:
            return @"BackgroundColor";
        case LookinAttrSec_ViewLayer_Border:
            return @"Border";
        case LookinAttrSec_ViewLayer_Shadow:
            return @"Shadow";
        case LookinAttrSec_ViewLayer_ContentMode:
            return @"ContentMode";
        case LookinAttrSec_ViewLayer_SafeArea:
            return @"SafeArea";
        case LookinAttrSec_ViewLayer_TintColor:
            return @"TintColor";
        case LookinAttrSec_ViewLayer_Position:
            return @"Position";
        case LookinAttrSec_ViewLayer_AnchorPoint:
            return @"AnchorPoint";
        case LookinAttrSec_ViewLayer_Tag:
            return @"Tag";
        case LookinAttrSec_UILabel_TextColor:
        case LookinAttrSec_UITextView_TextColor:
        case LookinAttrSec_UITextField_TextColor:
            return @"TextColor";
        case LookinAttrSec_UILabel_BreakMode:
            return @"LineBreakMode";
        case LookinAttrSec_UILabel_Alignment:
        case LookinAttrSec_UITextView_Alignment:
        case LookinAttrSec_UITextField_Alignment:
            return @"TextAlignment";
        case LookinAttrSec_UIControl_HorAlignment:
            return @"HorizontalAlignment";
        case LookinAttrSec_UIControl_VerAlignment:
            return @"VerticalAlignment";
        case LookinAttrSec_UIButton_ContentInsets:
            return @"ContentInsets";
        case LookinAttrSec_UIButton_TitleInsets:
            return @"TitleInsets";
        case LookinAttrSec_UIButton_ImageInsets:
            return @"ImageInsets";
        case LookinAttrSec_UIScrollView_ContentInset:
            return @"ContentInset";
        case LookinAttrSec_UIScrollView_AdjustedInset:
            return @"AdjustedContentInset";
        case LookinAttrSec_UIScrollView_IndicatorInset:
            return @"ScrollIndicatorInsets";
        case LookinAttrSec_UIScrollView_Offset:
            return @"ContentOffset";
        case LookinAttrSec_UIScrollView_ContentSize:
            return @"ContentSize";
        case LookinAttrSec_UIScrollView_Behavior:
            return @"InsetAdjustmentBehavior";
        case LookinAttrSec_UIScrollView_ShowsIndicator:
            return @"ShowsScrollIndicator";
        case LookinAttrSec_UIScrollView_Bounce:
            return @"AlwaysBounce";
        case LookinAttrSec_UIScrollView_Zoom:
            return @"Zoom";
        case LookinAttrSec_UITableView_Style:
            return @"Style";
        case LookinAttrSec_UITableView_SectionsNumber:
            return @"NumberOfSections";
        case LookinAttrSec_UITableView_RowsNumber:
            return @"NumberOfRows";
        case LookinAttrSec_UITableView_SeparatorColor:
            return @"SeparatorColor";
        case LookinAttrSec_UITableView_SeparatorInset:
            return @"SeparatorInset";
        case LookinAttrSec_UITextField_FontSize:
        case LookinAttrSec_UITextView_FontSize:
            return @"FontSize";
        case LookinAttrSec_UITextView_ContainerInset:
            return @"ContainerInset";
        case LookinAttrSec_UITextField_ClearButtonMode:
            return @"ClearButtonMode";
        default:
            return nil;
    }
}

+ (NSString *)introductionWithIdentifier:(LookinAttrSectionIdentifier)identifier {
    switch (identifier) {
        case LookinAttrSec_ViewLayer_Visibility:
            return @"Hidden / Opacity";
        case LookinAttrSec_ViewLayer_InterationAndMasks:
            return @"InteractionEnabled / MasksToBounds";
        case LookinAttrSec_UILabel_NumberFont:
            return @"NumberOfLines / Font";
        case LookinAttrSec_UILabel_CanAdjustFont:
            return @"AdjustsFontSizeToFitWidth";
        case LookinAttrSec_UIControl_EnabledSelected:
            return @"Enabled / Selected";
        case LookinAttrSec_UIScrollView_ScrollPaging:
            return @"ScrollEnabled / PagingEnabled";
        case LookinAttrSec_UIScrollView_ContentTouches:
            return @"ContentTouches";
        case LookinAttrSec_UITextView_Basic:
            return @"Editable / Selectable";
        case LookinAttrSec_UITextField_Clears:
            return @"ClearsOnBeginEditing / Insertion";
        case LookinAttrSec_UITextField_CanAdjustFont:
            return @"adjustsFontSizeToFitWidth";
            
        default:
            return [self titleWithIdentifier:identifier];
    }
}

- (NSString *)introduction {
    return nil;
}

@end
