//
//  LookinAttribute.m
//  
//
//  
//

#import "LookinAttribute.h"
#import "LookinDisplayItem.h"

@implementation LookinAttribute

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.identifier forKey:@"identifier"];
    [aCoder encodeInteger:self.attrType forKey:@"attrType"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeIntegerForKey:@"identifier"];
        self.attrType = [aDecoder decodeIntegerForKey:@"attrType"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (LookinAttrType)objectAttrTypeWithIdentifer:(LookinAttrIdentifier)identifier {
    switch (identifier) {
        case LookinAttr_ViewLayer_BgColor_BgColor:
        case LookinAttr_ViewLayer_Border_Color:
        case LookinAttr_ViewLayer_Shadow_Color:
        case LookinAttr_ViewLayer_TintColor_Color:
        case LookinAttr_UILabel_TextColor_Color:
        case LookinAttr_UITableView_SeparatorColor_Color:
        case LookinAttr_UITextView_TextColor_Color:
        case LookinAttr_UITextField_TextColor_Color:
            return LookinAttrTypeUIColor;
        default:
            NSAssert(NO, @"");
            return LookinAttrTypeNone;
    }
}

+ (NSString *)hostClassNameWithIdentifier:(LookinAttrIdentifier)identifier {
    switch (identifier) {
        case LookinAttr_None:
            NSAssert(NO, @"");
            return nil;
        
        case LookinAttr_Class_Class_Class:
        case LookinAttr_Relation_Relation_Relation:
            return @"NSObject";
            
        case LookinAttr_Frame_Basic_Basic:
        case LookinAttr_Bounds_Basic_Basic:
        case LookinAttr_ViewLayer_Visibility_Hidden:
        case LookinAttr_ViewLayer_Visibility_Opacity:
        case LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds:
        case LookinAttr_ViewLayer_Corner_Radius:
        case LookinAttr_ViewLayer_BgColor_BgColor:
        case LookinAttr_ViewLayer_Border_Color:
        case LookinAttr_ViewLayer_Border_Width:
        case LookinAttr_ViewLayer_Shadow_Color:
        case LookinAttr_ViewLayer_Shadow_Opacity:
        case LookinAttr_ViewLayer_Shadow_Radius:
        case LookinAttr_ViewLayer_Shadow_OffsetW:
        case LookinAttr_ViewLayer_Shadow_OffsetH:
        case LookinAttr_ViewLayer_Position_Position:
        case LookinAttr_ViewLayer_AnchorPoint_Point:
            return @"CALayer";
            
        case LookinAttr_ViewLayer_InterationAndMasks_Interaction:
        case LookinAttr_ViewLayer_ContentMode_Mode:
        case LookinAttr_ViewLayer_SafeArea_Area:
        case LookinAttr_ViewLayer_TintColor_Color:
        case LookinAttr_ViewLayer_TintColor_Mode:
        case LookinAttr_ViewLayer_Tag_Tag:
            return @"UIView";
            
        case LookinAttr_UILabel_NumberFont_NumberOfLines:
        case LookinAttr_UILabel_NumberFont_FontSize:
        case LookinAttr_UILabel_TextColor_Color:
        case LookinAttr_UILabel_Alignment_Alignment:
        case LookinAttr_UILabel_BreakMode_Mode:
        case LookinAttr_UILabel_CanAdjustFont_CanAdjustFont:
            return @"UILabel";
            
        case LookinAttr_UIControl_EnabledSelected_Enabled:
        case LookinAttr_UIControl_EnabledSelected_Selected:
        case LookinAttr_UIControl_VerAlignment_Alignment:
        case LookinAttr_UIControl_HorAlignment_Alignment:
            return @"UIControl";
            
        case LookinAttr_UIButton_ContentInsets_Insets:
        case LookinAttr_UIButton_TitleInsets_Insets:
        case LookinAttr_UIButton_ImageInsets_Insets:
            return @"UIButton";
            
        case LookinAttr_UIScrollView_Offset_Offset:
        case LookinAttr_UIScrollView_ContentSize_Size:
        case LookinAttr_UIScrollView_ContentInset_Inset:
        case LookinAttr_UIScrollView_AdjustedInset_Inset:
        case LookinAttr_UIScrollView_Behavior_Behavior:
        case LookinAttr_UIScrollView_IndicatorInset_Inset:
        case LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled:
        case LookinAttr_UIScrollView_ScrollPaging_PagingEnabled:
        case LookinAttr_UIScrollView_Bounce_Ver:
        case LookinAttr_UIScrollView_Bounce_Hor:
        case LookinAttr_UIScrollView_ShowsIndicator_Hor:
        case LookinAttr_UIScrollView_ShowsIndicator_Ver:
        case LookinAttr_UIScrollView_ContentTouches_Delay:
        case LookinAttr_UIScrollView_ContentTouches_CanCancel:
        case LookinAttr_UIScrollView_Zoom_MinScale:
        case LookinAttr_UIScrollView_Zoom_MaxScale:
        case LookinAttr_UIScrollView_Zoom_Scale:
        case LookinAttr_UIScrollView_Zoom_Bounce:
            return @"UIScrollView";
            
        case LookinAttr_UITableView_Style_Style:
        case LookinAttr_UITableView_SectionsNumber_Number:
        case LookinAttr_UITableView_RowsNumber_Number:
        case LookinAttr_UITableView_SeparatorInset_Inset:
        case LookinAttr_UITableView_SeparatorColor_Color:
            return @"UITableView";
            
        case LookinAttr_UITextView_FontSize_Size:
        case LookinAttr_UITextView_Basic_Editable:
        case LookinAttr_UITextView_Basic_Selectable:
        case LookinAttr_UITextView_TextColor_Color:
        case LookinAttr_UITextView_Alignment_Alignment:
        case LookinAttr_UITextView_ContainerInset_Inset:
            return @"UITextView";
            
        case LookinAttr_UITextField_FontSize_Size:
        case LookinAttr_UITextField_TextColor_Color:
        case LookinAttr_UITextField_Alignment_Alignment:
        case LookinAttr_UITextField_Clears_ClearsOnBeginEditing:
        case LookinAttr_UITextField_Clears_ClearsOnInsertion:
        case LookinAttr_UITextField_CanAdjustFont_CanAdjustFont:
        case LookinAttr_UITextField_CanAdjustFont_MinSize:
        case LookinAttr_UITextField_ClearButtonMode_Mode:
            return @"UITextField";
    }
}

+ (NSString *)enumListNameWithIdentifier:(LookinAttrIdentifier)identifier {
    switch (identifier) {
        case LookinAttr_ViewLayer_ContentMode_Mode:
            return @"UIViewContentMode";
            
        case LookinAttr_ViewLayer_TintColor_Mode:
            return @"UIViewTintAdjustmentMode";
            
        case LookinAttr_UILabel_Alignment_Alignment:
        case LookinAttr_UITextView_Alignment_Alignment:
        case LookinAttr_UITextField_Alignment_Alignment:
            return @"NSTextAlignment";
            
        case LookinAttr_UILabel_BreakMode_Mode:
            return @"NSLineBreakMode";
            
        case LookinAttr_UIScrollView_Behavior_Behavior:
            return @"UIScrollViewContentInsetAdjustmentBehavior";
            
        case LookinAttr_UITableView_Style_Style:
            return @"UITableViewStyle";
            
        case LookinAttr_UITextField_ClearButtonMode_Mode:
            return @"UITextFieldViewMode";
            
        case LookinAttr_UIControl_VerAlignment_Alignment:
            return @"UIControlContentVerticalAlignment";
            
        case LookinAttr_UIControl_HorAlignment_Alignment:
            return @"UIControlContentHorizontalAlignment";
            
        default:
            return nil;
    }
}

+ (LookinAttributeHostType)hostTypeWithIdentifier:(LookinAttrIdentifier)identifier {
    switch (identifier) {
        case LookinAttr_None:
            NSAssert(NO, @"");
            return LookinAttributeHostTypeNone;
            
        case LookinAttr_Class_Class_Class:
        case LookinAttr_Relation_Relation_Relation:
        case LookinAttr_Frame_Basic_Basic:
        case LookinAttr_Bounds_Basic_Basic:
        case LookinAttr_ViewLayer_Visibility_Hidden:
        case LookinAttr_ViewLayer_Visibility_Opacity:
        case LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds:
        case LookinAttr_ViewLayer_Corner_Radius:
        case LookinAttr_ViewLayer_BgColor_BgColor:
        case LookinAttr_ViewLayer_Border_Color:
        case LookinAttr_ViewLayer_Border_Width:
        case LookinAttr_ViewLayer_Shadow_Color:
        case LookinAttr_ViewLayer_Shadow_Opacity:
        case LookinAttr_ViewLayer_Shadow_Radius:
        case LookinAttr_ViewLayer_Shadow_OffsetW:
        case LookinAttr_ViewLayer_Shadow_OffsetH:
        case LookinAttr_ViewLayer_Position_Position:
        case LookinAttr_ViewLayer_AnchorPoint_Point:
            return LookinAttributeHostTypeLayer;
            
        default:
            return LookinAttributeHostTypeView;
    }
}

- (BOOL)needPatchAfterModification {
    if (!self.setter) {
        NSAssert(NO, @"");
        return NO;
    }
    
    switch (self.identifier) {
        case LookinAttr_None:
            NSAssert(NO, @"");
            return NO;
            
        case LookinAttr_ViewLayer_InterationAndMasks_Interaction:
        case LookinAttr_ViewLayer_Tag_Tag:
        case LookinAttr_UIScrollView_IndicatorInset_Inset:
        case LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled:
        case LookinAttr_UIScrollView_ScrollPaging_PagingEnabled:
        case LookinAttr_UIScrollView_Bounce_Ver:
        case LookinAttr_UIScrollView_Bounce_Hor:
        case LookinAttr_UIScrollView_ShowsIndicator_Hor:
        case LookinAttr_UIScrollView_ShowsIndicator_Ver:
        case LookinAttr_UIScrollView_ContentTouches_Delay:
        case LookinAttr_UIScrollView_ContentTouches_CanCancel:
        case LookinAttr_UIScrollView_Zoom_MinScale:
        case LookinAttr_UIScrollView_Zoom_MaxScale:
        case LookinAttr_UIScrollView_Zoom_Bounce:
        case LookinAttr_UITextView_Basic_Editable:
        case LookinAttr_UITextView_Basic_Selectable:
        case LookinAttr_UITextField_Clears_ClearsOnBeginEditing:
        case LookinAttr_UITextField_Clears_ClearsOnInsertion:
        case LookinAttr_UITextField_ClearButtonMode_Mode:
            return NO;
            
        default:
            return YES;
    }
}

- (NSString *)title {
    switch (self.identifier) {
        case LookinAttr_None:
            NSAssert(NO, @"");
            return nil;
        case LookinAttr_ViewLayer_Visibility_Hidden:
            return @"Hidden";
        case LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds:
            return @"MasksToBounds";
        case LookinAttr_ViewLayer_Visibility_Opacity:
            return @"Opacity / Alpha";
        case LookinAttr_ViewLayer_Border_Width:
            return @"BorderWidth";
        case LookinAttr_ViewLayer_Shadow_Opacity:
            return @"Opacity";
        case LookinAttr_ViewLayer_Shadow_Radius:
            return @"Radius";
        case LookinAttr_ViewLayer_Shadow_OffsetW:
            return @"OffsetW";
        case LookinAttr_ViewLayer_Shadow_OffsetH:
            return @"OffsetH";
        case LookinAttr_ViewLayer_InterationAndMasks_Interaction:
            return @"UserInteractionEnabled";
        case LookinAttr_UILabel_NumberFont_FontSize:
            return @"FontSize";
        case LookinAttr_UILabel_NumberFont_NumberOfLines:
            return @"NumberOfLines";
        case LookinAttr_UILabel_CanAdjustFont_CanAdjustFont:
            return @"AdjustsFontSizeToFitWidth";
        case LookinAttr_UIControl_EnabledSelected_Enabled:
            return @"enabled";
        case LookinAttr_UIControl_EnabledSelected_Selected:
            return @"selected";
        case LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled:
            return @"ScrollEnabled";
        case LookinAttr_UIScrollView_Bounce_Ver:
            return @"Vertical";
        case LookinAttr_UIScrollView_Bounce_Hor:
            return @"Horizontal";
        case LookinAttr_UIScrollView_ScrollPaging_PagingEnabled:
            return @"PagingEnabled";
        case LookinAttr_UIScrollView_ShowsIndicator_Hor:
            return @"Horizontal";
        case LookinAttr_UIScrollView_ShowsIndicator_Ver:
            return @"Vertical";
        case LookinAttr_UIScrollView_ContentTouches_Delay:
            return @"DelaysContentTouches";
        case LookinAttr_UIScrollView_ContentTouches_CanCancel:
            return @"CanCancelContentTouches";
        case LookinAttr_UIScrollView_Zoom_MinScale:
            return @"MinScale";
        case LookinAttr_UIScrollView_Zoom_MaxScale:
            return @"MaxScale";
        case LookinAttr_UIScrollView_Zoom_Scale:
            return @"Scale";
        case LookinAttr_UIScrollView_Zoom_Bounce:
            return @"BouncesZoom";
        case LookinAttr_UITextView_Basic_Editable:
            return @"Editable";
        case LookinAttr_UITextView_Basic_Selectable:
            return @"Selectable";
        case LookinAttr_UITextField_Clears_ClearsOnBeginEditing:
            return @"ClearsOnBeginEditing";
        case LookinAttr_UITextField_Clears_ClearsOnInsertion:
            return @"ClearsOnInsertion";
        case LookinAttr_UITextField_CanAdjustFont_CanAdjustFont:
            return @"AdjustsFontSizeToFitWidth";
        case LookinAttr_UITextField_CanAdjustFont_MinSize:
            return @"MinimumFontSize";
        default:
            return nil;
    }
}

- (SEL)setter {
    NSString *setterString = [self _setterString];
    if (setterString.length) {
        return NSSelectorFromString(setterString);
    } else {
        return nil;
    }
}

- (SEL)getter {
    NSString *getterString = [self _getterString];
    if (getterString.length) {
        return NSSelectorFromString(getterString);
    } else {
        return nil;
    }
}

- (NSString *)_setterString {
    switch (self.identifier) {
        case LookinAttr_None:
            NSAssert(NO, @"");
            return nil;
        case LookinAttr_Frame_Basic_Basic:
            return @"setFrame:";
        case LookinAttr_Bounds_Basic_Basic:
            return @"setBounds:";
        case LookinAttr_ViewLayer_Position_Position:
            return @"setPosition:";
        case LookinAttr_ViewLayer_AnchorPoint_Point:
            return @"setAnchorPoint:";
        case LookinAttr_ViewLayer_Visibility_Hidden:
            return @"setHidden:";
        case LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds:
            return @"setMasksToBounds:";
        case LookinAttr_ViewLayer_Visibility_Opacity:
            return @"setOpacity:";
        case LookinAttr_ViewLayer_BgColor_BgColor:
            return @"setLks_backgroundColor:";
        case LookinAttr_ViewLayer_Border_Color:
            return @"setLks_borderColor:";
        case LookinAttr_ViewLayer_Border_Width:
            return @"setBorderWidth:";
        case LookinAttr_ViewLayer_Corner_Radius:
            return @"setCornerRadius:";
        case LookinAttr_ViewLayer_Shadow_Color:
            return @"setLks_shadowColor:";
        case LookinAttr_ViewLayer_Shadow_Opacity:
            return @"setShadowOpacity:";
        case LookinAttr_ViewLayer_Shadow_Radius:
            return @"setShadowRadius:";
        case LookinAttr_ViewLayer_Shadow_OffsetW:
            return @"setLks_shadowOffsetWidth:";
        case LookinAttr_ViewLayer_Shadow_OffsetH:
            return @"setLks_shadowOffsetHeight:";
        case LookinAttr_ViewLayer_InterationAndMasks_Interaction:
            return @"setUserInteractionEnabled:";
        case LookinAttr_ViewLayer_Tag_Tag:
            return @"setTag:";
        case LookinAttr_ViewLayer_TintColor_Color:
            return @"setTintColor:";
        case LookinAttr_ViewLayer_ContentMode_Mode:
            return @"setContentMode:";
        case LookinAttr_ViewLayer_TintColor_Mode:
            return @"setTintAdjustmentMode:";
        case LookinAttr_UIControl_EnabledSelected_Enabled:
            return @"setEnabled:";
        case LookinAttr_UIControl_EnabledSelected_Selected:
            return @"setSelected:";
        case LookinAttr_UIControl_VerAlignment_Alignment:
            return @"setContentVerticalAlignment:";
        case LookinAttr_UIControl_HorAlignment_Alignment:
            return @"setContentHorizontalAlignment:";
        case LookinAttr_UIButton_ContentInsets_Insets:
            return @"setContentEdgeInsets:";
        case LookinAttr_UIButton_TitleInsets_Insets:
            return @"setTitleEdgeInsets:";
        case LookinAttr_UIButton_ImageInsets_Insets:
            return @"setImageEdgeInsets:";
        case LookinAttr_UILabel_NumberFont_FontSize:
            return @"setLks_fontSize:";
        case LookinAttr_UILabel_TextColor_Color:
            return @"setTextColor:";
        case LookinAttr_UILabel_Alignment_Alignment:
            return @"setTextAlignment:";
        case LookinAttr_UILabel_BreakMode_Mode:
            return @"setLineBreakMode:";
        case LookinAttr_UILabel_NumberFont_NumberOfLines:
            return @"setNumberOfLines:";
        case LookinAttr_UILabel_CanAdjustFont_CanAdjustFont:
            return @"setAdjustsFontSizeToFitWidth:";
        case LookinAttr_UIScrollView_Behavior_Behavior:
            return @"setContentInsetAdjustmentBehavior:";
        case LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled:
            return @"setScrollEnabled:";
        case LookinAttr_UIScrollView_Bounce_Ver:
            return @"setAlwaysBounceVertical:";
        case LookinAttr_UIScrollView_Bounce_Hor:
            return @"setAlwaysBounceHorizontal:";
        case LookinAttr_UIScrollView_ScrollPaging_PagingEnabled:
            return @"setPagingEnabled:";
        case LookinAttr_UIScrollView_ShowsIndicator_Hor:
            return @"setShowsHorizontalScrollIndicator:";
        case LookinAttr_UIScrollView_ShowsIndicator_Ver:
            return @"setShowsVerticalScrollIndicator:";
        case LookinAttr_UIScrollView_ContentTouches_Delay:
            return @"setDelaysContentTouches:";
        case LookinAttr_UIScrollView_ContentTouches_CanCancel:
            return @"setCanCancelContentTouches:";
        case LookinAttr_UIScrollView_Zoom_Bounce:
            return @"setBouncesZoom:";
        case LookinAttr_UIScrollView_Offset_Offset:
            return @"setContentOffset:";
        case LookinAttr_UIScrollView_ContentSize_Size:
            return @"setContentSize:";
        case LookinAttr_UIScrollView_ContentInset_Inset:
            return @"setContentInset:";
        case LookinAttr_UIScrollView_IndicatorInset_Inset:
            return @"setScrollIndicatorInsets:";
        case LookinAttr_UITableView_SeparatorColor_Color:
            return @"setSeparatorColor:";
        case LookinAttr_UITableView_SeparatorInset_Inset:
            return @"setSeparatorInset:";
        case LookinAttr_UITextView_FontSize_Size:
            return @"setLks_fontSize:";
        case LookinAttr_UITextView_TextColor_Color:
            return @"setTextColor:";
        case LookinAttr_UITextView_Alignment_Alignment:
            return @"setTextAlignment:";
        case LookinAttr_UITextView_Basic_Editable:
            return @"setEditable:";
        case LookinAttr_UITextView_Basic_Selectable:
            return @"setSelectable:";
        case LookinAttr_UITextView_ContainerInset_Inset:
            return @"setTextContainerInset:";
        case LookinAttr_UITextField_FontSize_Size:
            return @"setLks_fontSize:";
        case LookinAttr_UITextField_TextColor_Color:
            return @"setTextColor:";
        case LookinAttr_UITextField_Alignment_Alignment:
            return @"setTextAlignment:";
        case LookinAttr_UITextField_Clears_ClearsOnBeginEditing:
            return @"setClearsOnBeginEditing:";
        case LookinAttr_UITextField_Clears_ClearsOnInsertion:
            return @"setClearsOnBeginEditing:";
        case LookinAttr_UITextField_CanAdjustFont_CanAdjustFont:
            return @"setAdjustsFontSizeToFitWidth:";
        case LookinAttr_UITextField_CanAdjustFont_MinSize:
            return @"setMinimumFontSize:";
        case LookinAttr_UITextField_ClearButtonMode_Mode:
            return @"setClearButtonMode:";
        
        default:
            return nil;
    }
    return nil;
}

- (NSString *)_getterString {
    switch (self.identifier) {
        case LookinAttr_None:
            NSAssert(NO, @"");
            return nil;
        case LookinAttr_Frame_Basic_Basic:
            return @"frame";
        case LookinAttr_Bounds_Basic_Basic:
            return @"bounds";
        case LookinAttr_ViewLayer_Visibility_Hidden:
            return @"isHidden";
        case LookinAttr_ViewLayer_InterationAndMasks_Interaction:
            return @"isUserInteractionEnabled";
        case LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds:
            return @"masksToBounds";
        case LookinAttr_ViewLayer_Visibility_Opacity:
            return @"opacity";
        case LookinAttr_ViewLayer_BgColor_BgColor:
            return @"lks_backgroundColor";
        case LookinAttr_ViewLayer_Border_Color:
            return @"lks_borderColor";
        case LookinAttr_ViewLayer_Border_Width:
            return @"borderWidth";
        case LookinAttr_ViewLayer_Corner_Radius:
            return @"cornerRadius";
        case LookinAttr_ViewLayer_Shadow_Color:
            return @"lks_shadowColor";
        case LookinAttr_ViewLayer_Shadow_Opacity:
            return @"shadowOpacity";
        case LookinAttr_ViewLayer_Shadow_Radius:
            return @"shadowRadius";
        case LookinAttr_ViewLayer_Shadow_OffsetW:
            return @"lks_shadowOffsetWidth";
        case LookinAttr_ViewLayer_Shadow_OffsetH:
            return @"lks_shadowOffsetHeight";
        case LookinAttr_ViewLayer_SafeArea_Area:
            return @"safeAreaInsets";
        case LookinAttr_ViewLayer_Position_Position:
            return @"position";
        case LookinAttr_ViewLayer_AnchorPoint_Point:
            return @"anchorPoint";
        case LookinAttr_ViewLayer_Tag_Tag:
            return @"tag";
        case LookinAttr_ViewLayer_TintColor_Color:
            return @"tintColor";
        case LookinAttr_ViewLayer_ContentMode_Mode:
            return @"contentMode";
        case LookinAttr_ViewLayer_TintColor_Mode:
            return @"tintAdjustmentMode";
        case LookinAttr_UILabel_NumberFont_FontSize:
            return @"lks_fontSize";
        case LookinAttr_UILabel_TextColor_Color:
            return @"textColor";
        case LookinAttr_UILabel_Alignment_Alignment:
            return @"textAlignment";
        case LookinAttr_UILabel_BreakMode_Mode:
            return @"lineBreakMode";
        case LookinAttr_UILabel_NumberFont_NumberOfLines:
            return @"numberOfLines";
        case LookinAttr_UILabel_CanAdjustFont_CanAdjustFont:
            return @"adjustsFontSizeToFitWidth";
        case LookinAttr_UIControl_EnabledSelected_Enabled:
            return @"isEnabled";
        case LookinAttr_UIControl_EnabledSelected_Selected:
            return @"isSelected";
        case LookinAttr_UIControl_VerAlignment_Alignment:
            return @"contentVerticalAlignment";
        case LookinAttr_UIControl_HorAlignment_Alignment:
            return @"contentHorizontalAlignment";
        case LookinAttr_UIButton_ContentInsets_Insets:
            return @"contentEdgeInsets";
        case LookinAttr_UIButton_TitleInsets_Insets:
            return @"titleEdgeInsets";
        case LookinAttr_UIButton_ImageInsets_Insets:
            return @"imageEdgeInsets";
        case LookinAttr_UIScrollView_Offset_Offset:
            return @"contentOffset";
        case LookinAttr_UIScrollView_ContentSize_Size:
            return @"contentSize";
        case LookinAttr_UIScrollView_ContentInset_Inset:
            return @"contentInset";
        case LookinAttr_UIScrollView_AdjustedInset_Inset:
            return @"adjustedContentInset";
        case LookinAttr_UIScrollView_IndicatorInset_Inset:
            return @"scrollIndicatorInsets";
        case LookinAttr_UIScrollView_Behavior_Behavior:
            return @"contentInsetAdjustmentBehavior";
        case LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled:
            return @"isScrollEnabled";
        case LookinAttr_UIScrollView_Bounce_Ver:
            return @"alwaysBounceVertical";
        case LookinAttr_UIScrollView_Bounce_Hor:
            return @"alwaysBounceHorizontal";
        case LookinAttr_UIScrollView_ScrollPaging_PagingEnabled:
            return @"isPagingEnabled";
        case LookinAttr_UIScrollView_ShowsIndicator_Hor:
            return @"showsHorizontalScrollIndicator";
        case LookinAttr_UIScrollView_ShowsIndicator_Ver:
            return @"showsVerticalScrollIndicator";
        case LookinAttr_UIScrollView_ContentTouches_Delay:
            return @"delaysContentTouches";
        case LookinAttr_UIScrollView_ContentTouches_CanCancel:
            return @"canCancelContentTouches";
        case LookinAttr_UIScrollView_Zoom_Bounce:
            return @"bouncesZoom";
        case LookinAttr_UIScrollView_Zoom_MinScale:
            return @"minimumZoomScale";
        case LookinAttr_UIScrollView_Zoom_MaxScale:
            return @"maximumZoomScale";
        case LookinAttr_UIScrollView_Zoom_Scale:
            return @"zoomScale";
        case LookinAttr_UITableView_Style_Style:
            return @"style";
        case LookinAttr_UITableView_SectionsNumber_Number:
            return @"numberOfSections";
        case LookinAttr_UITableView_SeparatorInset_Inset:
            return @"separatorInset";
        case LookinAttr_UITableView_SeparatorColor_Color:
            return @"separatorColor";
        case LookinAttr_UITextView_FontSize_Size:
            return @"lks_fontSize";
        case LookinAttr_UITextView_TextColor_Color:
            return @"textColor";
        case LookinAttr_UITextView_Alignment_Alignment:
            return @"textAlignment";
        case LookinAttr_UITextView_Basic_Editable:
            return @"isEditable";
        case LookinAttr_UITextView_Basic_Selectable:
            return @"isSelectable";
        case LookinAttr_UITextView_ContainerInset_Inset:
            return @"textContainerInset";
        case LookinAttr_UITextField_FontSize_Size:
            return @"lks_fontSize";
        case LookinAttr_UITextField_TextColor_Color:
            return @"textColor";
        case LookinAttr_UITextField_Alignment_Alignment:
            return @"textAlignment";
        case LookinAttr_UITextField_Clears_ClearsOnBeginEditing:
            return @"clearsOnBeginEditing";
        case LookinAttr_UITextField_Clears_ClearsOnInsertion:
            return @"clearsOnInsertion";
        case LookinAttr_UITextField_CanAdjustFont_CanAdjustFont:
            return @"adjustsFontSizeToFitWidth";
        case LookinAttr_UITextField_CanAdjustFont_MinSize:
            return @"minimumFontSize";
        case LookinAttr_UITextField_ClearButtonMode_Mode:
            return @"clearButtonMode";
        case LookinAttr_Class_Class_Class:
        case LookinAttr_Relation_Relation_Relation:
        case LookinAttr_UITableView_RowsNumber_Number:
        {
            return nil;
        }
    }
}

@end

