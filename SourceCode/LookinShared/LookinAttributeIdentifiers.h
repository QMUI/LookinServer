//
//  LookinAttrIdentifiers.h
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

typedef NS_ENUM(NSUInteger, LookinAttrGroupIdentifier) {
    LookinAttrGroup_None,
    
    LookinAttrGroup_Class,
    LookinAttrGroup_Relation,
    LookinAttrGroup_Frame,
    LookinAttrGroup_Bounds,
    LookinAttrGroup_SafeArea,
    LookinAttrGroup_LayerView,
    LookinAttrGroup_UILabel,
    LookinAttrGroup_UIControl,
    LookinAttrGroup_UIButton,
    LookinAttrGroup_UIScrollView,
    LookinAttrGroup_UITableView,
    LookinAttrGroup_UITextView,
    LookinAttrGroup_UITextField,
};

typedef NS_ENUM(NSInteger, LookinAttrSectionIdentifier) {
    LookinAttrSec_None,
    
    LookinAttrSec_Class_Class,
    
    LookinAttrSec_Relation_Relation,
    
    LookinAttrSec_Frame_Basic,
    
    LookinAttrSec_Bounds_Basic,
    
    LookinAttrSec_ViewLayer_Visibility,
    LookinAttrSec_ViewLayer_InterationAndMasks,
    LookinAttrSec_ViewLayer_Corner,
    LookinAttrSec_ViewLayer_BgColor,
    LookinAttrSec_ViewLayer_Border,
    LookinAttrSec_ViewLayer_Shadow,
    LookinAttrSec_ViewLayer_ContentMode,
    LookinAttrSec_ViewLayer_SafeArea,
    LookinAttrSec_ViewLayer_TintColor,
    LookinAttrSec_ViewLayer_Position,
    LookinAttrSec_ViewLayer_AnchorPoint,
    LookinAttrSec_ViewLayer_Tag,
    
    LookinAttrSec_UILabel_NumberFont,
    LookinAttrSec_UILabel_TextColor,
    LookinAttrSec_UILabel_BreakMode,
    LookinAttrSec_UILabel_Alignment,
    LookinAttrSec_UILabel_CanAdjustFont,
    
    LookinAttrSec_UIControl_EnabledSelected,
    LookinAttrSec_UIControl_VerAlignment,
    LookinAttrSec_UIControl_HorAlignment,
    
    LookinAttrSec_UIButton_ContentInsets,
    LookinAttrSec_UIButton_TitleInsets,
    LookinAttrSec_UIButton_ImageInsets,
    
    LookinAttrSec_UIScrollView_ContentInset,
    LookinAttrSec_UIScrollView_AdjustedInset,
    LookinAttrSec_UIScrollView_IndicatorInset,
    LookinAttrSec_UIScrollView_Offset,
    LookinAttrSec_UIScrollView_ContentSize,
    LookinAttrSec_UIScrollView_Behavior,
    LookinAttrSec_UIScrollView_ShowsIndicator,
    LookinAttrSec_UIScrollView_Bounce,
    LookinAttrSec_UIScrollView_ScrollPaging,
    LookinAttrSec_UIScrollView_ContentTouches,
    LookinAttrSec_UIScrollView_Zoom,
    
    LookinAttrSec_UITableView_Style,
    LookinAttrSec_UITableView_SectionsNumber,
    LookinAttrSec_UITableView_RowsNumber,
    LookinAttrSec_UITableView_SeparatorColor,
    LookinAttrSec_UITableView_SeparatorInset,
    
    LookinAttrSec_UITextView_Basic,
    LookinAttrSec_UITextView_FontSize,
    LookinAttrSec_UITextView_TextColor,
    LookinAttrSec_UITextView_Alignment,
    LookinAttrSec_UITextView_ContainerInset,
    
    LookinAttrSec_UITextField_FontSize,
    LookinAttrSec_UITextField_TextColor,
    LookinAttrSec_UITextField_Alignment,
    LookinAttrSec_UITextField_Clears,
    LookinAttrSec_UITextField_CanAdjustFont,
    LookinAttrSec_UITextField_ClearButtonMode,
    
    LookinAttrSec_Max = LookinAttrSec_UITextField_ClearButtonMode
};

typedef NS_ENUM(NSInteger, LookinAttrIdentifier) {
    LookinAttr_None,
    
    LookinAttr_Class_Class_Class,
    
    LookinAttr_Relation_Relation_Relation,
    
    LookinAttr_Frame_Basic_Basic,
    
    LookinAttr_Bounds_Basic_Basic,
    
    LookinAttr_ViewLayer_Visibility_Hidden,
    LookinAttr_ViewLayer_Visibility_Opacity,
    LookinAttr_ViewLayer_InterationAndMasks_Interaction,
    LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds,
    LookinAttr_ViewLayer_Corner_Radius,
    LookinAttr_ViewLayer_BgColor_BgColor,
    LookinAttr_ViewLayer_Border_Color,
    LookinAttr_ViewLayer_Border_Width,
    LookinAttr_ViewLayer_Shadow_Color,
    LookinAttr_ViewLayer_Shadow_Opacity,
    LookinAttr_ViewLayer_Shadow_Radius,
    LookinAttr_ViewLayer_Shadow_OffsetW,
    LookinAttr_ViewLayer_Shadow_OffsetH,
    LookinAttr_ViewLayer_ContentMode_Mode,
    LookinAttr_ViewLayer_SafeArea_Area,
    LookinAttr_ViewLayer_TintColor_Color,
    LookinAttr_ViewLayer_TintColor_Mode,
    LookinAttr_ViewLayer_Position_Position,
    LookinAttr_ViewLayer_AnchorPoint_Point,
    LookinAttr_ViewLayer_Tag_Tag,
    
    LookinAttr_UILabel_NumberFont_NumberOfLines,
    LookinAttr_UILabel_NumberFont_FontSize,
    LookinAttr_UILabel_TextColor_Color,
    LookinAttr_UILabel_Alignment_Alignment,
    LookinAttr_UILabel_BreakMode_Mode,
    LookinAttr_UILabel_CanAdjustFont_CanAdjustFont,
    
    LookinAttr_UIControl_EnabledSelected_Enabled,
    LookinAttr_UIControl_EnabledSelected_Selected,
    LookinAttr_UIControl_VerAlignment_Alignment,
    LookinAttr_UIControl_HorAlignment_Alignment,
    
    LookinAttr_UIButton_ContentInsets_Insets,
    LookinAttr_UIButton_TitleInsets_Insets,
    LookinAttr_UIButton_ImageInsets_Insets,
    
    LookinAttr_UIScrollView_Offset_Offset,
    LookinAttr_UIScrollView_ContentSize_Size,
    LookinAttr_UIScrollView_ContentInset_Inset,
    LookinAttr_UIScrollView_AdjustedInset_Inset,
    LookinAttr_UIScrollView_Behavior_Behavior,
    LookinAttr_UIScrollView_IndicatorInset_Inset,
    LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled,
    LookinAttr_UIScrollView_ScrollPaging_PagingEnabled,
    LookinAttr_UIScrollView_Bounce_Ver,
    LookinAttr_UIScrollView_Bounce_Hor,
    LookinAttr_UIScrollView_ShowsIndicator_Hor,
    LookinAttr_UIScrollView_ShowsIndicator_Ver,
    LookinAttr_UIScrollView_ContentTouches_Delay,
    LookinAttr_UIScrollView_ContentTouches_CanCancel,
    LookinAttr_UIScrollView_Zoom_MinScale,
    LookinAttr_UIScrollView_Zoom_MaxScale,
    LookinAttr_UIScrollView_Zoom_Scale,
    LookinAttr_UIScrollView_Zoom_Bounce,
    
    LookinAttr_UITableView_Style_Style,
    LookinAttr_UITableView_SectionsNumber_Number,
    LookinAttr_UITableView_RowsNumber_Number,
    LookinAttr_UITableView_SeparatorInset_Inset,
    LookinAttr_UITableView_SeparatorColor_Color,
    
    LookinAttr_UITextView_FontSize_Size,
    LookinAttr_UITextView_Basic_Editable,
    LookinAttr_UITextView_Basic_Selectable,
    LookinAttr_UITextView_TextColor_Color,
    LookinAttr_UITextView_Alignment_Alignment,
    LookinAttr_UITextView_ContainerInset_Inset,
    
    LookinAttr_UITextField_FontSize_Size,
    LookinAttr_UITextField_TextColor_Color,
    LookinAttr_UITextField_Alignment_Alignment,
    LookinAttr_UITextField_Clears_ClearsOnBeginEditing,
    LookinAttr_UITextField_Clears_ClearsOnInsertion,
    LookinAttr_UITextField_CanAdjustFont_CanAdjustFont,
    LookinAttr_UITextField_CanAdjustFont_MinSize,
    LookinAttr_UITextField_ClearButtonMode_Mode
};
