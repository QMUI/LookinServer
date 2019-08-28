//
//  LookinDashboardBlueprint.m
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import "LookinDashboardBlueprint.h"

@implementation LookinDashboardBlueprint

+ (NSArray<NSNumber *> *)groupIDs {
    static NSArray<NSNumber *> *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        array = @[
                  @(LookinAttrGroup_Class),
                  @(LookinAttrGroup_Relation),
                  @(LookinAttrGroup_Frame),
                  @(LookinAttrGroup_Bounds),
                  @(LookinAttrGroup_LayerView),
                  @(LookinAttrGroup_UILabel),
                  @(LookinAttrGroup_UIControl),
                  @(LookinAttrGroup_UIButton),
                  @(LookinAttrGroup_UIScrollView),
                  @(LookinAttrGroup_UITableView),
                  @(LookinAttrGroup_UITextView),
                  @(LookinAttrGroup_UITextField)
                  ];
    });
    return array;
}

+ (NSArray<NSNumber *> *)sectionIDsForGroupID:(LookinAttrGroupIdentifier)groupID {
    static NSDictionary<NSNumber *, NSArray<NSNumber *> *> *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        dict = @{
                 @(LookinAttrGroup_Class): @[@(LookinAttrSec_Class_Class)],
                 
                 @(LookinAttrGroup_Relation): @[@(LookinAttrSec_Relation_Relation)],
                 
                 @(LookinAttrGroup_Frame): @[@(LookinAttrSec_Frame_Basic)],
                 
                 @(LookinAttrGroup_Bounds): @[@(LookinAttrSec_Bounds_Basic)],
                 
                 @(LookinAttrGroup_LayerView): @[
                         @(LookinAttrSec_ViewLayer_Visibility),
                         @(LookinAttrSec_ViewLayer_InterationAndMasks),
                         @(LookinAttrSec_ViewLayer_BgColor),
                         @(LookinAttrSec_ViewLayer_Border),
                         @(LookinAttrSec_ViewLayer_Corner),
                         @(LookinAttrSec_ViewLayer_Shadow),
                         @(LookinAttrSec_ViewLayer_ContentMode),
                         @(LookinAttrSec_ViewLayer_SafeArea),
                         @(LookinAttrSec_ViewLayer_TintColor),
                         @(LookinAttrSec_ViewLayer_Position),
                         @(LookinAttrSec_ViewLayer_AnchorPoint),
                         @(LookinAttrSec_ViewLayer_Tag)
                         ],
                 
                 @(LookinAttrGroup_UILabel): @[@(LookinAttrSec_UILabel_NumberFont),
                                               @(LookinAttrSec_UILabel_TextColor),
                                               @(LookinAttrSec_UILabel_BreakMode),
                                               @(LookinAttrSec_UILabel_Alignment),
                                               @(LookinAttrSec_UILabel_CanAdjustFont)],
                 
                 @(LookinAttrGroup_UIControl): @[@(LookinAttrSec_UIControl_EnabledSelected),
                                                 @(LookinAttrSec_UIControl_VerAlignment),
                                                 @(LookinAttrSec_UIControl_HorAlignment)],
                 
                 @(LookinAttrGroup_UIButton): @[@(LookinAttrSec_UIButton_ContentInsets),
                                                @(LookinAttrSec_UIButton_TitleInsets),
                                                @(LookinAttrSec_UIButton_ImageInsets)],
                 
                 @(LookinAttrGroup_UIScrollView): @[@(LookinAttrSec_UIScrollView_ContentInset),
                                                    @(LookinAttrSec_UIScrollView_AdjustedInset),
                                                    @(LookinAttrSec_UIScrollView_IndicatorInset),
                                                    @(LookinAttrSec_UIScrollView_Offset),
                                                    @(LookinAttrSec_UIScrollView_ContentSize),
                                                    @(LookinAttrSec_UIScrollView_Behavior),
                                                    @(LookinAttrSec_UIScrollView_ShowsIndicator),
                                                    @(LookinAttrSec_UIScrollView_Bounce),
                                                    @(LookinAttrSec_UIScrollView_ScrollPaging),
                                                    @(LookinAttrSec_UIScrollView_ContentTouches),
                                                    @(LookinAttrSec_UIScrollView_Zoom)],
                 
                 @(LookinAttrGroup_UITableView): @[@(LookinAttrSec_UITableView_Style),
                                                   @(LookinAttrSec_UITableView_SectionsNumber),
                                                   @(LookinAttrSec_UITableView_RowsNumber),
                                                   @(LookinAttrSec_UITableView_SeparatorColor),
                                                   @(LookinAttrSec_UITableView_SeparatorInset)],
                 
                 @(LookinAttrGroup_UITextView): @[@(LookinAttrSec_UITextView_Basic),
                                                  @(LookinAttrSec_UITextView_FontSize),
                                                  @(LookinAttrSec_UITextView_TextColor),
                                                  @(LookinAttrSec_UITextView_Alignment),
                                                  @(LookinAttrSec_UITextView_ContainerInset)],
                 
                 @(LookinAttrGroup_UITextField): @[@(LookinAttrSec_UITextField_FontSize),
                                                   @(LookinAttrSec_UITextField_TextColor),
                                                   @(LookinAttrSec_UITextField_Alignment),
                                                   @(LookinAttrSec_UITextField_Clears),
                                                   @(LookinAttrSec_UITextField_CanAdjustFont),
                                                   @(LookinAttrSec_UITextField_ClearButtonMode)],
                 
                 };
    });
    return dict[@(groupID)];
}

+ (NSArray<NSNumber *> *)attrIDsForSectionID:(LookinAttrSectionIdentifier)sectionID {
    static NSDictionary<NSNumber *, NSArray<NSNumber *> *> *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        dict = @{
                 @(LookinAttrSec_Class_Class): @[@(LookinAttr_Class_Class_Class)],
                 
                 @(LookinAttrSec_Relation_Relation): @[@(LookinAttr_Relation_Relation_Relation)],
                 
                 @(LookinAttrSec_Frame_Basic): @[@(LookinAttr_Frame_Basic_Basic)],
                                  
                 @(LookinAttrSec_Bounds_Basic): @[@(LookinAttr_Bounds_Basic_Basic)],
                 
                 @(LookinAttrSec_ViewLayer_Visibility): @[@(LookinAttr_ViewLayer_Visibility_Hidden),
                                                          @(LookinAttr_ViewLayer_Visibility_Opacity)],
                 
                 @(LookinAttrSec_ViewLayer_InterationAndMasks): @[@(LookinAttr_ViewLayer_InterationAndMasks_Interaction),
                                                               @(LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds)],
                 
                 @(LookinAttrSec_ViewLayer_Corner): @[@(LookinAttr_ViewLayer_Corner_Radius)],
                 
                 @(LookinAttrSec_ViewLayer_BgColor): @[@(LookinAttr_ViewLayer_BgColor_BgColor)],
                 
                 @(LookinAttrSec_ViewLayer_Border): @[@(LookinAttr_ViewLayer_Border_Color),
                                                      @(LookinAttr_ViewLayer_Border_Width)],
                 
                 @(LookinAttrSec_ViewLayer_Shadow): @[@(LookinAttr_ViewLayer_Shadow_Color),
                                                      @(LookinAttr_ViewLayer_Shadow_Opacity),
                                                      @(LookinAttr_ViewLayer_Shadow_Radius),
                                                      @(LookinAttr_ViewLayer_Shadow_OffsetW),
                                                      @(LookinAttr_ViewLayer_Shadow_OffsetH)],
                 
                 @(LookinAttrSec_ViewLayer_ContentMode): @[@(LookinAttr_ViewLayer_ContentMode_Mode)],
                 
                 @(LookinAttrSec_ViewLayer_SafeArea): @[@(LookinAttr_ViewLayer_SafeArea_Area)],
                 
                 @(LookinAttrSec_ViewLayer_TintColor): @[@(LookinAttr_ViewLayer_TintColor_Color),
                                                         @(LookinAttr_ViewLayer_TintColor_Mode)],
                 
                 @(LookinAttrSec_ViewLayer_Position): @[@(LookinAttr_ViewLayer_Position_Position)],
                 
                 @(LookinAttrSec_ViewLayer_AnchorPoint): @[@(LookinAttr_ViewLayer_AnchorPoint_Point)],
                 
                 @(LookinAttrSec_ViewLayer_Tag): @[@(LookinAttr_ViewLayer_Tag_Tag)],
                 
                 @(LookinAttrSec_UILabel_NumberFont): @[@(LookinAttr_UILabel_NumberFont_NumberOfLines),
                                                        @(LookinAttr_UILabel_NumberFont_FontSize)],
                 
                 @(LookinAttrSec_UILabel_TextColor): @[@(LookinAttr_UILabel_TextColor_Color)],
                 
                 @(LookinAttrSec_UILabel_BreakMode): @[@(LookinAttr_UILabel_BreakMode_Mode)],
                 
                 @(LookinAttrSec_UILabel_Alignment): @[@(LookinAttr_UILabel_Alignment_Alignment)],
                 
                 @(LookinAttrSec_UILabel_CanAdjustFont): @[@(LookinAttr_UILabel_CanAdjustFont_CanAdjustFont)],
                 
                 @(LookinAttrSec_UIControl_EnabledSelected): @[@(LookinAttr_UIControl_EnabledSelected_Enabled),
                                                               @(LookinAttr_UIControl_EnabledSelected_Selected)],
                 
                 @(LookinAttrSec_UIControl_VerAlignment): @[@(LookinAttr_UIControl_VerAlignment_Alignment)],
                 
                 @(LookinAttrSec_UIControl_HorAlignment): @[@(LookinAttr_UIControl_HorAlignment_Alignment)],
                 
                 @(LookinAttrSec_UIButton_ContentInsets): @[@(LookinAttr_UIButton_ContentInsets_Insets)],
                 
                 @(LookinAttrSec_UIButton_TitleInsets): @[@(LookinAttr_UIButton_TitleInsets_Insets)],
                 
                 @(LookinAttrSec_UIButton_ImageInsets): @[@(LookinAttr_UIButton_ImageInsets_Insets)],
                 
                 @(LookinAttrSec_UIScrollView_ContentInset): @[@(LookinAttr_UIScrollView_ContentInset_Inset)],
                 
                 @(LookinAttrSec_UIScrollView_AdjustedInset): @[@(LookinAttr_UIScrollView_AdjustedInset_Inset)],
                 
                 @(LookinAttrSec_UIScrollView_IndicatorInset): @[@(LookinAttr_UIScrollView_IndicatorInset_Inset)],
                 
                 @(LookinAttrSec_UIScrollView_Offset): @[@(LookinAttr_UIScrollView_Offset_Offset)],
                 
                 @(LookinAttrSec_UIScrollView_ContentSize): @[@(LookinAttr_UIScrollView_ContentSize_Size)],
                 
                 @(LookinAttrSec_UIScrollView_Behavior): @[@(LookinAttr_UIScrollView_Behavior_Behavior)],
                 
                 @(LookinAttrSec_UIScrollView_ShowsIndicator): @[@(LookinAttr_UIScrollView_ShowsIndicator_Hor),
                                                                 @(LookinAttr_UIScrollView_ShowsIndicator_Ver)],
                 
                 @(LookinAttrSec_UIScrollView_Bounce): @[@(LookinAttr_UIScrollView_Bounce_Hor),
                                                         @(LookinAttr_UIScrollView_Bounce_Ver)],
                 
                 @(LookinAttrSec_UIScrollView_ScrollPaging): @[@(LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled),
                                                               @(LookinAttr_UIScrollView_ScrollPaging_PagingEnabled)],
                 
                 @(LookinAttrSec_UIScrollView_ContentTouches): @[@(LookinAttr_UIScrollView_ContentTouches_Delay),
                                                                 @(LookinAttr_UIScrollView_ContentTouches_CanCancel)],
                 
                 @(LookinAttrSec_UIScrollView_Zoom): @[@(LookinAttr_UIScrollView_Zoom_Bounce),
                                                       @(LookinAttr_UIScrollView_Zoom_Scale),
                                                       @(LookinAttr_UIScrollView_Zoom_MinScale),
                                                       @(LookinAttr_UIScrollView_Zoom_MaxScale)],
                 
                 @(LookinAttrSec_UITableView_Style): @[@(LookinAttr_UITableView_Style_Style)],
                 
                 @(LookinAttrSec_UITableView_SectionsNumber): @[@(LookinAttr_UITableView_SectionsNumber_Number)],
                 
                 @(LookinAttrSec_UITableView_RowsNumber): @[@(LookinAttr_UITableView_RowsNumber_Number)],
                 
                 @(LookinAttrSec_UITableView_SeparatorInset): @[@(LookinAttr_UITableView_SeparatorInset_Inset)],
                 
                 @(LookinAttrSec_UITableView_SeparatorColor): @[@(LookinAttr_UITableView_SeparatorColor_Color)],
                 
                 @(LookinAttrSec_UITextView_Basic): @[@(LookinAttr_UITextView_Basic_Editable),
                                                      @(LookinAttr_UITextView_Basic_Selectable)],
                 
                 @(LookinAttrSec_UITextView_FontSize): @[@(LookinAttr_UITextView_FontSize_Size)],
                 
                 @(LookinAttrSec_UITextView_TextColor): @[@(LookinAttr_UITextView_TextColor_Color)],
                 
                 @(LookinAttrSec_UITextView_Alignment): @[@(LookinAttr_UITextView_Alignment_Alignment)],
                 
                 @(LookinAttrSec_UITextView_ContainerInset): @[@(LookinAttr_UITextView_ContainerInset_Inset)],
                 
                 @(LookinAttrSec_UITextField_FontSize): @[@(LookinAttr_UITextField_FontSize_Size)],
                 
                 @(LookinAttrSec_UITextField_TextColor): @[@(LookinAttr_UITextField_TextColor_Color)],
                 
                 @(LookinAttrSec_UITextField_Alignment): @[@(LookinAttr_UITextField_Alignment_Alignment)],
                 
                 @(LookinAttrSec_UITextField_Clears): @[@(LookinAttr_UITextField_Clears_ClearsOnBeginEditing),
                                                        @(LookinAttr_UITextField_Clears_ClearsOnInsertion)],
                 
                 @(LookinAttrSec_UITextField_CanAdjustFont): @[@(LookinAttr_UITextField_CanAdjustFont_CanAdjustFont),
                                                               @(LookinAttr_UITextField_CanAdjustFont_MinSize)],
                 
                 @(LookinAttrSec_UITextField_ClearButtonMode): @[@(LookinAttr_UITextField_ClearButtonMode_Mode)]
                 };
    });
    return dict[@(sectionID)];
}

@end
