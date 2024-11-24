#ifdef SHOULD_COMPILE_LOOKIN_SERVER

//
//  LookinDashboardBlueprint.m
//  Lookin
//
//  Created by Li Kai on 2019/6/5.
//  https://lookin.work
//



#import "LookinDashboardBlueprint.h"

@implementation LookinDashboardBlueprint

+ (NSArray<LookinAttrGroupIdentifier> *)groupIDs {
    static NSArray<LookinAttrGroupIdentifier> *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        array = @[
            LookinAttrGroup_Class,
            LookinAttrGroup_Relation,
            LookinAttrGroup_Layout,
            LookinAttrGroup_AutoLayout,
            LookinAttrGroup_ViewLayer,
#if TARGET_OS_IPHONE
            LookinAttrGroup_UIStackView,
            LookinAttrGroup_UIVisualEffectView,
            LookinAttrGroup_UIImageView,
            LookinAttrGroup_UILabel,
            LookinAttrGroup_UIControl,
            LookinAttrGroup_UIButton,
            LookinAttrGroup_UIScrollView,
            LookinAttrGroup_UITableView,
            LookinAttrGroup_UITextView,
            LookinAttrGroup_UITextField
#endif
#if TARGET_OS_OSX
            LookinAttrGroup_NSImageView,
            LookinAttrGroup_NSControl,
            LookinAttrGroup_NSButton,
            LookinAttrGroup_NSScrollView,
            LookinAttrGroup_NSTableView,
            LookinAttrGroup_NSTextView,
            LookinAttrGroup_NSTextField,
            LookinAttrGroup_NSVisualEffectView,
            LookinAttrGroup_NSStackView,
#endif
        ];
    });
    return array;
}

+ (NSArray<LookinAttrSectionIdentifier> *)sectionIDsForGroupID:(LookinAttrGroupIdentifier)groupID {
    static NSDictionary<LookinAttrGroupIdentifier, NSArray<LookinAttrSectionIdentifier> *> *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        dict = @{
            LookinAttrGroup_Class: @[LookinAttrSec_Class_Class],
            
            LookinAttrGroup_Relation: @[LookinAttrSec_Relation_Relation],
            
            LookinAttrGroup_Layout: @[LookinAttrSec_Layout_Frame,
                                      LookinAttrSec_Layout_Bounds,
                                      LookinAttrSec_Layout_SafeArea,
                                      LookinAttrSec_Layout_Position,
                                      LookinAttrSec_Layout_AnchorPoint],
            
            LookinAttrGroup_AutoLayout: @[LookinAttrSec_AutoLayout_Constraints,
                                          LookinAttrSec_AutoLayout_IntrinsicSize,
                                          LookinAttrSec_AutoLayout_Hugging,
                                          LookinAttrSec_AutoLayout_Resistance],
            
            LookinAttrGroup_ViewLayer: @[
                LookinAttrSec_ViewLayer_Visibility,
                LookinAttrSec_ViewLayer_InterationAndMasks,
                LookinAttrSec_ViewLayer_BgColor,
                LookinAttrSec_ViewLayer_Border,
                LookinAttrSec_ViewLayer_Corner,
                LookinAttrSec_ViewLayer_Shadow,
                LookinAttrSec_ViewLayer_Tag,
#if TARGET_OS_IPHONE
                LookinAttrSec_ViewLayer_ContentMode,
                LookinAttrSec_ViewLayer_TintColor,
#endif
            ],
            
#if TARGET_OS_IPHONE
            LookinAttrGroup_UIStackView: @[
                LookinAttrSec_UIStackView_Axis,
                LookinAttrSec_UIStackView_Distribution,
                LookinAttrSec_UIStackView_Alignment,
                LookinAttrSec_UIStackView_Spacing
            ],
            
            LookinAttrGroup_UIVisualEffectView: @[
                LookinAttrSec_UIVisualEffectView_Style,
                LookinAttrSec_UIVisualEffectView_QMUIForegroundColor
            ],
            
            LookinAttrGroup_UIImageView: @[LookinAttrSec_UIImageView_Name,
                                           LookinAttrSec_UIImageView_Open],
            
            LookinAttrGroup_UILabel: @[
                LookinAttrSec_UILabel_Text,
                LookinAttrSec_UILabel_Font,
                LookinAttrSec_UILabel_NumberOfLines,
                LookinAttrSec_UILabel_TextColor,
                LookinAttrSec_UILabel_BreakMode,
                LookinAttrSec_UILabel_Alignment,
                LookinAttrSec_UILabel_CanAdjustFont],
            
            LookinAttrGroup_UIControl: @[LookinAttrSec_UIControl_EnabledSelected,
                                         LookinAttrSec_UIControl_QMUIOutsideEdge,
                                         LookinAttrSec_UIControl_VerAlignment,
                                         LookinAttrSec_UIControl_HorAlignment],
            
            LookinAttrGroup_UIButton: @[LookinAttrSec_UIButton_ContentInsets,
                                        LookinAttrSec_UIButton_TitleInsets,
                                        LookinAttrSec_UIButton_ImageInsets],
            
            LookinAttrGroup_UIScrollView: @[LookinAttrSec_UIScrollView_ContentInset,
                                            LookinAttrSec_UIScrollView_AdjustedInset,
                                            LookinAttrSec_UIScrollView_QMUIInitialInset,
                                            LookinAttrSec_UIScrollView_IndicatorInset,
                                            LookinAttrSec_UIScrollView_Offset,
                                            LookinAttrSec_UIScrollView_ContentSize,
                                            LookinAttrSec_UIScrollView_Behavior,
                                            LookinAttrSec_UIScrollView_ShowsIndicator,
                                            LookinAttrSec_UIScrollView_Bounce,
                                            LookinAttrSec_UIScrollView_ScrollPaging,
                                            LookinAttrSec_UIScrollView_ContentTouches,
                                            LookinAttrSec_UIScrollView_Zoom],
            
            LookinAttrGroup_UITableView: @[LookinAttrSec_UITableView_Style,
                                           LookinAttrSec_UITableView_SectionsNumber,
                                           LookinAttrSec_UITableView_RowsNumber,
                                           LookinAttrSec_UITableView_SeparatorStyle,
                                           LookinAttrSec_UITableView_SeparatorColor,
                                           LookinAttrSec_UITableView_SeparatorInset],
            
            LookinAttrGroup_UITextView: @[LookinAttrSec_UITextView_Basic,
                                          LookinAttrSec_UITextView_Text,
                                          LookinAttrSec_UITextView_Font,
                                          LookinAttrSec_UITextView_TextColor,
                                          LookinAttrSec_UITextView_Alignment,
                                          LookinAttrSec_UITextView_ContainerInset],
            
            LookinAttrGroup_UITextField: @[LookinAttrSec_UITextField_Text,
                                           LookinAttrSec_UITextField_Placeholder,
                                           LookinAttrSec_UITextField_Font,
                                           LookinAttrSec_UITextField_TextColor,
                                           LookinAttrSec_UITextField_Alignment,
                                           LookinAttrSec_UITextField_Clears,
                                           LookinAttrSec_UITextField_CanAdjustFont,
                                           LookinAttrSec_UITextField_ClearButtonMode],
#endif
#if TARGET_OS_OSX
            LookinAttrGroup_NSImageView: @[
                LookinAttrSec_NSImageView_Name,
                LookinAttrSec_NSImageView_Open
            ],
            
            LookinAttrGroup_NSControl: @[
                LookinAttrSec_NSControl_State,
                LookinAttrSec_NSControl_ControlSize,
                LookinAttrSec_NSControl_Font,
                LookinAttrSec_NSControl_Alignment,
                LookinAttrSec_NSControl_Misc,
                LookinAttrSec_NSControl_Value,
            ],
            
            LookinAttrGroup_NSButton: @[
                LookinAttrSec_NSButton_ButtonType,
                LookinAttrSec_NSButton_Title,
                LookinAttrSec_NSButton_BezelStyle,
                LookinAttrSec_NSButton_Bordered,
                LookinAttrSec_NSButton_Transparent,
                LookinAttrSec_NSButton_BezelColor,
                LookinAttrSec_NSButton_ContentTintColor,
                LookinAttrSec_NSButton_Misc,
            ],
            
            LookinAttrGroup_NSScrollView: @[
                LookinAttrSec_NSScrollView_ContentOffset,
                LookinAttrSec_NSScrollView_ContentSize,
                LookinAttrSec_NSScrollView_ContentInset,
                LookinAttrSec_NSScrollView_BorderType,
                LookinAttrSec_NSScrollView_Scroller,
                LookinAttrSec_NSScrollView_Ruler,
                LookinAttrSec_NSScrollView_LineScroll,
                LookinAttrSec_NSScrollView_PageScroll,
                LookinAttrSec_NSScrollView_ScrollElasiticity,
                LookinAttrSec_NSScrollView_Misc,
                LookinAttrSec_NSScrollView_Magnification,
            ],
            
            LookinAttrGroup_NSTableView: @[
                LookinAttrSec_NSTableView_RowHeight,
                LookinAttrSec_NSTableView_AutomaticRowHeights,
                LookinAttrSec_NSTableView_IntercellSpacing,
                LookinAttrSec_NSTableView_Style,
                LookinAttrSec_NSTableView_ColumnAutoresizingStyle,
                LookinAttrSec_NSTableView_GridStyleMask,
                LookinAttrSec_NSTableView_SelectionHighlightStyle,
                LookinAttrSec_NSTableView_GridColor,
                LookinAttrSec_NSTableView_RowSizeStyle,
                LookinAttrSec_NSTableView_NumberOfRows,
                LookinAttrSec_NSTableView_NumberOfColumns,
                LookinAttrSec_NSTableView_UseAlternatingRowBackgroundColors,
                LookinAttrSec_NSTableView_AllowsColumnReordering,
                LookinAttrSec_NSTableView_AllowsColumnResizing,
                LookinAttrSec_NSTableView_AllowsMultipleSelection,
                LookinAttrSec_NSTableView_AllowsEmptySelection,
                LookinAttrSec_NSTableView_AllowsColumnSelection,
                LookinAttrSec_NSTableView_AllowsTypeSelect,
                LookinAttrSec_NSTableView_DraggingDestinationFeedbackStyle,
                LookinAttrSec_NSTableView_Autosave,
                LookinAttrSec_NSTableView_FloatsGroupRows,
                LookinAttrSec_NSTableView_RowActionsVisible,
                LookinAttrSec_NSTableView_UsesStaticContents,
                LookinAttrSec_NSTableView_UserInterfaceLayoutDirection,
                LookinAttrSec_NSTableView_VerticalMotionCanBeginDrag,
            ],
            
            LookinAttrGroup_NSTextView: @[
                LookinAttrSec_NSTextView_Font,
                LookinAttrSec_NSTextView_Basic,
                LookinAttrSec_NSTextView_String,
                LookinAttrSec_NSTextView_TextColor,
                LookinAttrSec_NSTextView_Alignment,
                LookinAttrSec_NSTextView_ContainerInset,
                LookinAttrSec_NSTextView_BaseWritingDirection,
                LookinAttrSec_NSTextView_Size,
                LookinAttrSec_NSTextView_Resizable,
            ],
            
            LookinAttrGroup_NSTextField: @[
                LookinAttrSec_NSTextField_Bordered,
                LookinAttrSec_NSTextField_Bezeled,
                LookinAttrSec_NSTextField_BezelStyle,
                LookinAttrSec_NSTextField_Editable,
                LookinAttrSec_NSTextField_Selectable,
                LookinAttrSec_NSTextField_DrawsBackground,
                LookinAttrSec_NSTextField_PreferredMaxLayoutWidth,
                LookinAttrSec_NSTextField_MaximumNumberOfLines,
                LookinAttrSec_NSTextField_AllowsDefaultTighteningForTruncation,
                LookinAttrSec_NSTextField_LineBreakStrategy,
                LookinAttrSec_NSTextField_Placeholder,
                LookinAttrSec_NSTextField_TextColor,
            ],
            
            
            LookinAttrGroup_NSVisualEffectView: @[
                LookinAttrSec_NSVisualEffectView_Material,
                LookinAttrSec_NSVisualEffectView_InteriorBackgroundStyle,
                LookinAttrSec_NSVisualEffectView_BlendingMode,
                LookinAttrSec_NSVisualEffectView_State,
                LookinAttrSec_NSVisualEffectView_Emphasized,
            ],
            
            LookinAttrGroup_NSStackView: @[
                LookinAttrSec_NSStackView_Orientation,
                LookinAttrSec_NSStackView_EdgeInsets,
                LookinAttrSec_NSStackView_DetachesHiddenViews,
                LookinAttrSec_NSStackView_Distribution,
                LookinAttrSec_NSStackView_Alignment,
                LookinAttrSec_NSStackView_Spacing,
            ],
#endif
            
        };
    });
    return dict[groupID];
}

+ (NSArray<LookinAttrIdentifier> *)attrIDsForSectionID:(LookinAttrSectionIdentifier)sectionID {
    static NSDictionary<LookinAttrSectionIdentifier, NSArray<LookinAttrIdentifier> *> *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        dict = @{
            LookinAttrSec_Class_Class: @[LookinAttr_Class_Class_Class],
            
            LookinAttrSec_Relation_Relation: @[LookinAttr_Relation_Relation_Relation],
            
            LookinAttrSec_Layout_Frame: @[LookinAttr_Layout_Frame_Frame],
            LookinAttrSec_Layout_Bounds: @[LookinAttr_Layout_Bounds_Bounds],
            LookinAttrSec_Layout_SafeArea: @[LookinAttr_Layout_SafeArea_SafeArea],
            LookinAttrSec_Layout_Position: @[LookinAttr_Layout_Position_Position],
            LookinAttrSec_Layout_AnchorPoint: @[LookinAttr_Layout_AnchorPoint_AnchorPoint],
            
            LookinAttrSec_AutoLayout_Hugging: @[LookinAttr_AutoLayout_Hugging_Hor,
                                                LookinAttr_AutoLayout_Hugging_Ver],
            LookinAttrSec_AutoLayout_Resistance: @[LookinAttr_AutoLayout_Resistance_Hor,
                                                   LookinAttr_AutoLayout_Resistance_Ver],
            LookinAttrSec_AutoLayout_Constraints: @[LookinAttr_AutoLayout_Constraints_Constraints],
            LookinAttrSec_AutoLayout_IntrinsicSize: @[LookinAttr_AutoLayout_IntrinsicSize_Size],
            
            LookinAttrSec_ViewLayer_Visibility: @[LookinAttr_ViewLayer_Visibility_Hidden,
                                                  LookinAttr_ViewLayer_Visibility_Opacity],
            
            LookinAttrSec_ViewLayer_InterationAndMasks:@[
#if TARGET_OS_IPHONE
            LookinAttr_ViewLayer_InterationAndMasks_Interaction,
#endif
                                                          LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds],
            
            LookinAttrSec_ViewLayer_Corner: @[LookinAttr_ViewLayer_Corner_Radius],
            
            LookinAttrSec_ViewLayer_BgColor: @[LookinAttr_ViewLayer_BgColor_BgColor],
            
            LookinAttrSec_ViewLayer_Border: @[LookinAttr_ViewLayer_Border_Color,
                                              LookinAttr_ViewLayer_Border_Width],
            
            LookinAttrSec_ViewLayer_Shadow: @[LookinAttr_ViewLayer_Shadow_Color,
                                              LookinAttr_ViewLayer_Shadow_Opacity,
                                              LookinAttr_ViewLayer_Shadow_Radius,
                                              LookinAttr_ViewLayer_Shadow_OffsetW,
                                              LookinAttr_ViewLayer_Shadow_OffsetH],
#if TARGET_OS_IPHONE
            
            LookinAttrSec_ViewLayer_ContentMode: @[LookinAttr_ViewLayer_ContentMode_Mode],
            
            LookinAttrSec_ViewLayer_TintColor: @[LookinAttr_ViewLayer_TintColor_Color,
                                                 LookinAttr_ViewLayer_TintColor_Mode],
#endif
            
            LookinAttrSec_ViewLayer_Tag: @[LookinAttr_ViewLayer_Tag_Tag],
#if TARGET_OS_IPHONE
            
            LookinAttrSec_UIStackView_Axis: @[LookinAttr_UIStackView_Axis_Axis],
            
            LookinAttrSec_UIStackView_Distribution: @[LookinAttr_UIStackView_Distribution_Distribution],
            
            LookinAttrSec_UIStackView_Alignment: @[LookinAttr_UIStackView_Alignment_Alignment],
            
            LookinAttrSec_UIStackView_Spacing: @[LookinAttr_UIStackView_Spacing_Spacing],
            
            LookinAttrSec_UIVisualEffectView_Style: @[LookinAttr_UIVisualEffectView_Style_Style],
            
            LookinAttrSec_UIVisualEffectView_QMUIForegroundColor: @[LookinAttr_UIVisualEffectView_QMUIForegroundColor_Color],
            
            LookinAttrSec_UIImageView_Name: @[LookinAttr_UIImageView_Name_Name],
            
            LookinAttrSec_UIImageView_Open: @[LookinAttr_UIImageView_Open_Open],
            
            LookinAttrSec_UILabel_Font: @[LookinAttr_UILabel_Font_Name,
                                          LookinAttr_UILabel_Font_Size],
            
            LookinAttrSec_UILabel_NumberOfLines: @[LookinAttr_UILabel_NumberOfLines_NumberOfLines],
            
            LookinAttrSec_UILabel_Text: @[LookinAttr_UILabel_Text_Text],
            
            LookinAttrSec_UILabel_TextColor: @[LookinAttr_UILabel_TextColor_Color],
            
            LookinAttrSec_UILabel_BreakMode: @[LookinAttr_UILabel_BreakMode_Mode],
            
            LookinAttrSec_UILabel_Alignment: @[LookinAttr_UILabel_Alignment_Alignment],
            
            LookinAttrSec_UILabel_CanAdjustFont: @[LookinAttr_UILabel_CanAdjustFont_CanAdjustFont],
            
            LookinAttrSec_UIControl_EnabledSelected: @[LookinAttr_UIControl_EnabledSelected_Enabled,
                                                       LookinAttr_UIControl_EnabledSelected_Selected],
            
            LookinAttrSec_UIControl_QMUIOutsideEdge: @[LookinAttr_UIControl_QMUIOutsideEdge_Edge],
            
            LookinAttrSec_UIControl_VerAlignment: @[LookinAttr_UIControl_VerAlignment_Alignment],
            
            LookinAttrSec_UIControl_HorAlignment: @[LookinAttr_UIControl_HorAlignment_Alignment],
            
            LookinAttrSec_UIButton_ContentInsets: @[LookinAttr_UIButton_ContentInsets_Insets],
            
            LookinAttrSec_UIButton_TitleInsets: @[LookinAttr_UIButton_TitleInsets_Insets],
            
            LookinAttrSec_UIButton_ImageInsets: @[LookinAttr_UIButton_ImageInsets_Insets],
            
            LookinAttrSec_UIScrollView_ContentInset: @[LookinAttr_UIScrollView_ContentInset_Inset],
            
            LookinAttrSec_UIScrollView_AdjustedInset: @[LookinAttr_UIScrollView_AdjustedInset_Inset],
            
            LookinAttrSec_UIScrollView_QMUIInitialInset: @[LookinAttr_UIScrollView_QMUIInitialInset_Inset],
            
            LookinAttrSec_UIScrollView_IndicatorInset: @[LookinAttr_UIScrollView_IndicatorInset_Inset],
            
            LookinAttrSec_UIScrollView_Offset: @[LookinAttr_UIScrollView_Offset_Offset],
            
            LookinAttrSec_UIScrollView_ContentSize: @[LookinAttr_UIScrollView_ContentSize_Size],
            
            LookinAttrSec_UIScrollView_Behavior: @[LookinAttr_UIScrollView_Behavior_Behavior],
            
            LookinAttrSec_UIScrollView_ShowsIndicator: @[LookinAttr_UIScrollView_ShowsIndicator_Hor,
                                                         LookinAttr_UIScrollView_ShowsIndicator_Ver],
            
            LookinAttrSec_UIScrollView_Bounce: @[LookinAttr_UIScrollView_Bounce_Hor,
                                                 LookinAttr_UIScrollView_Bounce_Ver],
            
            LookinAttrSec_UIScrollView_ScrollPaging: @[LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled,
                                                       LookinAttr_UIScrollView_ScrollPaging_PagingEnabled],
            
            LookinAttrSec_UIScrollView_ContentTouches: @[LookinAttr_UIScrollView_ContentTouches_Delay,
                                                         LookinAttr_UIScrollView_ContentTouches_CanCancel],
            
            LookinAttrSec_UIScrollView_Zoom: @[LookinAttr_UIScrollView_Zoom_Bounce,
                                               LookinAttr_UIScrollView_Zoom_Scale,
                                               LookinAttr_UIScrollView_Zoom_MinScale,
                                               LookinAttr_UIScrollView_Zoom_MaxScale],
            
            LookinAttrSec_UITableView_Style: @[LookinAttr_UITableView_Style_Style],
            
            LookinAttrSec_UITableView_SectionsNumber: @[LookinAttr_UITableView_SectionsNumber_Number],
            
            LookinAttrSec_UITableView_RowsNumber: @[LookinAttr_UITableView_RowsNumber_Number],
            
            LookinAttrSec_UITableView_SeparatorInset: @[LookinAttr_UITableView_SeparatorInset_Inset],
            
            LookinAttrSec_UITableView_SeparatorColor: @[LookinAttr_UITableView_SeparatorColor_Color],
            
            LookinAttrSec_UITableView_SeparatorStyle: @[LookinAttr_UITableView_SeparatorStyle_Style],
            
            LookinAttrSec_UITextView_Basic: @[LookinAttr_UITextView_Basic_Editable,
                                              LookinAttr_UITextView_Basic_Selectable],
            
            LookinAttrSec_UITextView_Text: @[LookinAttr_UITextView_Text_Text],
            
            LookinAttrSec_UITextView_Font: @[LookinAttr_UITextView_Font_Name,
                                             LookinAttr_UITextView_Font_Size],
            
            LookinAttrSec_UITextView_TextColor: @[LookinAttr_UITextView_TextColor_Color],
            
            LookinAttrSec_UITextView_Alignment: @[LookinAttr_UITextView_Alignment_Alignment],
            
            LookinAttrSec_UITextView_ContainerInset: @[LookinAttr_UITextView_ContainerInset_Inset],
            
            LookinAttrSec_UITextField_Text: @[LookinAttr_UITextField_Text_Text],
            
            LookinAttrSec_UITextField_Placeholder: @[LookinAttr_UITextField_Placeholder_Placeholder],
            
            LookinAttrSec_UITextField_Font: @[LookinAttr_UITextField_Font_Name,
                                              LookinAttr_UITextField_Font_Size],
            
            LookinAttrSec_UITextField_TextColor: @[LookinAttr_UITextField_TextColor_Color],
            
            LookinAttrSec_UITextField_Alignment: @[LookinAttr_UITextField_Alignment_Alignment],
            
            LookinAttrSec_UITextField_Clears: @[LookinAttr_UITextField_Clears_ClearsOnBeginEditing,
                                                LookinAttr_UITextField_Clears_ClearsOnInsertion],
            
            LookinAttrSec_UITextField_CanAdjustFont: @[LookinAttr_UITextField_CanAdjustFont_CanAdjustFont,
                                                       LookinAttr_UITextField_CanAdjustFont_MinSize],
            
            LookinAttrSec_UITextField_ClearButtonMode: @[LookinAttr_UITextField_ClearButtonMode_Mode]
#endif
#if TARGET_OS_OSX
            LookinAttrSec_NSImageView_Name:@[
                LookinAttr_NSImageView_Name_Name
            ],
            LookinAttrSec_NSImageView_Open:@[
                LookinAttr_NSImageView_Open_Open
            ],
            LookinAttrSec_NSControl_State: @[
                LookinAttr_NSControl_State_Enabled,
                LookinAttr_NSControl_State_Highlighted,
                LookinAttr_NSControl_State_Continuous,
            ],
            LookinAttrSec_NSControl_ControlSize: @[
                LookinAttr_NSControl_ControlSize_Size
            ],
            LookinAttrSec_NSControl_Font: @[
                LookinAttr_NSControl_Font_Name,
                LookinAttr_NSControl_Font_Size
            ],
            LookinAttrSec_NSControl_Alignment: @[
                LookinAttr_NSControl_Alignment_Alignment
            ],
            LookinAttrSec_NSControl_Misc: @[
                LookinAttr_NSControl_Misc_WritingDirection,
                LookinAttr_NSControl_Misc_IgnoresMultiClick,
                LookinAttr_NSControl_Misc_UsesSingleLineMode,
                LookinAttr_NSControl_Misc_AllowsExpansionToolTips,
            ],
            LookinAttrSec_NSControl_Value: @[
                LookinAttr_NSControl_Value_StringValue,
                LookinAttr_NSControl_Value_IntValue,
                LookinAttr_NSControl_Value_IntegerValue,
                LookinAttr_NSControl_Value_FloatValue,
                LookinAttr_NSControl_Value_DoubleValue,
            ],
            
            LookinAttrSec_NSButton_ButtonType: @[
                LookinAttr_NSButton_ButtonType_ButtonType
            ],
            LookinAttrSec_NSButton_Title: @[
                LookinAttr_NSButton_Title_Title,
                LookinAttr_NSButton_Title_AlernateTitle,
            ],
            LookinAttrSec_NSButton_BezelStyle: @[LookinAttr_NSButton_BezelStyle_BezelStyle],
            LookinAttrSec_NSButton_Bordered: @[LookinAttr_NSButton_Bordered_Bordered],
            LookinAttrSec_NSButton_Transparent: @[LookinAttr_NSButton_Transparent_Transparent],
            LookinAttrSec_NSButton_BezelColor: @[LookinAttr_NSButton_BezelColor_BezelColor],
            LookinAttrSec_NSButton_ContentTintColor: @[LookinAttr_NSButton_ContentTintColor_ContentTintColor],
            LookinAttrSec_NSButton_Misc: @[
                LookinAttr_NSButton_Misc_ShowsBorderOnlyWhileMouseInside,
                LookinAttr_NSButton_Misc_MaxAcceleratorLevel,
                LookinAttr_NSButton_Misc_SpringLoaded,
                LookinAttr_NSButton_Misc_HasDestructiveAction,
            ],
            
            
            
            LookinAttrSec_NSScrollView_ContentOffset: @[
                LookinAttr_NSScrollView_ContentOffset_Offset
            ],
            LookinAttrSec_NSScrollView_ContentSize: @[
                LookinAttr_NSScrollView_ContentSize_Size
            ],
            LookinAttrSec_NSScrollView_ContentInset: @[
                LookinAttr_NSScrollView_ContentInset_ContentInset,
                LookinAttr_NSScrollView_ContentInset_AutomaticallyAdjustsContentInsets
            ],
            LookinAttrSec_NSScrollView_BorderType: @[
                LookinAttr_NSScrollView_BorderType_BorderType
            ],
            LookinAttrSec_NSScrollView_Scroller: @[
                LookinAttr_NSScrollView_Scroller_Horizontal,
                LookinAttr_NSScrollView_Scroller_Vertical,
                LookinAttr_NSScrollView_Scroller_AutohidesScrollers,
                LookinAttr_NSScrollView_Scroller_ScrollerStyle,
                LookinAttr_NSScrollView_Scroller_ScrollerKnobStyle,
                LookinAttr_NSScrollView_Scroller_ScrollerInsets,
            ],
            LookinAttrSec_NSScrollView_Ruler: @[
                LookinAttr_NSScrollView_Ruler_Horizontal,
                LookinAttr_NSScrollView_Ruler_Vertical,
                LookinAttr_NSScrollView_Ruler_Visible,
            ],
            LookinAttrSec_NSScrollView_LineScroll: @[
                LookinAttr_NSScrollView_LineScroll_Horizontal,
                LookinAttr_NSScrollView_LineScroll_Vertical,
                LookinAttr_NSScrollView_LineScroll_LineScroll,
            ],
            LookinAttrSec_NSScrollView_PageScroll: @[
                LookinAttr_NSScrollView_PageScroll_Horizontal,
                LookinAttr_NSScrollView_PageScroll_Vertical,
                LookinAttr_NSScrollView_PageScroll_PageScroll,
            ],
            LookinAttrSec_NSScrollView_ScrollElasiticity: @[
                LookinAttr_NSScrollView_ScrollElasiticity_Horizontal,
                LookinAttr_NSScrollView_ScrollElasiticity_Vertical,
            ],
            LookinAttrSec_NSScrollView_Misc: @[
                LookinAttr_NSScrollView_Misc_ScrollsDynamically,
                LookinAttr_NSScrollView_Misc_UsesPredominantAxisScrolling,
            ],
            LookinAttrSec_NSScrollView_Magnification: @[
                LookinAttr_NSScrollView_Magnification_AllowsMagnification,
                LookinAttr_NSScrollView_Magnification_Magnification,
                LookinAttr_NSScrollView_Magnification_Max,
                LookinAttr_NSScrollView_Magnification_Min,
            ],
            
            LookinAttrSec_NSTableView_RowHeight: @[
                LookinAttr_NSTableView_RowHeight_RowHeight,
            ],
            LookinAttrSec_NSTableView_AutomaticRowHeights: @[
                LookinAttr_NSTableView_AutomaticRowHeights_AutomaticRowHeights,
            ],
            LookinAttrSec_NSTableView_IntercellSpacing: @[
                LookinAttr_NSTableView_IntercellSpacing_IntercellSpacing
            ],
            LookinAttrSec_NSTableView_Style: @[
                LookinAttr_NSTableView_Style_Style
            ],
            LookinAttrSec_NSTableView_ColumnAutoresizingStyle: @[
                LookinAttr_NSTableView_ColumnAutoresizingStyle_ColumnAutoresizingStyle
            ],
            LookinAttrSec_NSTableView_GridStyleMask: @[
                LookinAttr_NSTableView_GridStyleMask_GridStyleMask
            ],
            LookinAttrSec_NSTableView_SelectionHighlightStyle: @[
                LookinAttr_NSTableView_SelectionHighlightStyle_SelectionHighlightStyle
            ],
            LookinAttrSec_NSTableView_GridColor: @[
                LookinAttr_NSTableView_GridColor_GridColor
            ],
            LookinAttrSec_NSTableView_RowSizeStyle: @[
                LookinAttr_NSTableView_RowSizeStyle_RowSizeStyle
            ],
            LookinAttrSec_NSTableView_NumberOfRows: @[
                LookinAttr_NSTableView_NumberOfRows_NumberOfRows
            ],
            LookinAttrSec_NSTableView_NumberOfColumns: @[
                LookinAttr_NSTableView_NumberOfColumns_NumberOfColumns
            ],
            LookinAttrSec_NSTableView_UseAlternatingRowBackgroundColors: @[
                LookinAttr_NSTableView_UseAlternatingRowBackgroundColors_UseAlternatingRowBackgroundColors
            ],
            LookinAttrSec_NSTableView_AllowsColumnReordering: @[
                LookinAttr_NSTableView_AllowsColumnReordering_AllowsColumnReordering
            ],
            LookinAttrSec_NSTableView_AllowsColumnResizing: @[
                LookinAttr_NSTableView_AllowsColumnResizing_AllowsColumnResizing
            ],
            LookinAttrSec_NSTableView_AllowsMultipleSelection: @[
                LookinAttr_NSTableView_AllowsMultipleSelection_AllowsMultipleSelection
            ],
            LookinAttrSec_NSTableView_AllowsEmptySelection: @[
                LookinAttr_NSTableView_AllowsEmptySelection_AllowsEmptySelection
            ],
            LookinAttrSec_NSTableView_AllowsColumnSelection: @[
                LookinAttr_NSTableView_AllowsColumnSelection_AllowsColumnSelection
            ],
            LookinAttrSec_NSTableView_AllowsTypeSelect: @[
                LookinAttr_NSTableView_AllowsTypeSelect_AllowsTypeSelect
            ],
            LookinAttrSec_NSTableView_DraggingDestinationFeedbackStyle: @[
                LookinAttr_NSTableView_DraggingDestinationFeedbackStyle_DraggingDestinationFeedbackStyle
            ],
            LookinAttrSec_NSTableView_Autosave: @[
                LookinAttr_NSTableView_AutosaveName_AutosaveName,
                LookinAttr_NSTableView_AutosaveTableColumns_AutosaveTableColumns
            ],
            LookinAttrSec_NSTableView_FloatsGroupRows: @[
                LookinAttr_NSTableView_FloatsGroupRows_FloatsGroupRows
            ],
            LookinAttrSec_NSTableView_RowActionsVisible: @[
                LookinAttr_NSTableView_RowActionsVisible_RowActionsVisible
            ],
            LookinAttrSec_NSTableView_UsesStaticContents: @[
                LookinAttr_NSTableView_UsesStaticContents_UsesStaticContents
            ],
            LookinAttrSec_NSTableView_UserInterfaceLayoutDirection: @[
                LookinAttr_NSTableView_UserInterfaceLayoutDirection_UserInterfaceLayoutDirection
            ],
            LookinAttrSec_NSTableView_VerticalMotionCanBeginDrag: @[
                LookinAttr_NSTableView_VerticalMotionCanBeginDrag_VerticalMotionCanBeginDrag
            ],
            
            
            
            LookinAttrSec_NSTextView_Font: @[
                LookinAttr_NSTextView_Font_Name,
                LookinAttr_NSTextView_Font_Size
            ],
            LookinAttrSec_NSTextView_Basic: @[
                LookinAttr_NSTextView_Basic_Editable,
                LookinAttr_NSTextView_Basic_Selectable,
                LookinAttr_NSTextView_Basic_RichText,
                LookinAttr_NSTextView_Basic_FieldEditor,
                LookinAttr_NSTextView_Basic_ImportsGraphics,
            ],
            LookinAttrSec_NSTextView_String: @[
                LookinAttr_NSTextView_String_String
            ],
            LookinAttrSec_NSTextView_TextColor: @[
                LookinAttr_NSTextView_TextColor_Color
            ],
            LookinAttrSec_NSTextView_Alignment: @[
                LookinAttr_NSTextView_Alignment_Alignment
            ],
            LookinAttrSec_NSTextView_ContainerInset: @[
                LookinAttr_NSTextView_ContainerInset_Inset
            ],
            LookinAttrSec_NSTextView_BaseWritingDirection: @[
                LookinAttr_NSTextView_BaseWritingDirection_BaseWritingDirection
            ],
            LookinAttrSec_NSTextView_Size: @[
                LookinAttr_NSTextView_MaxSize_MaxSize,
                LookinAttr_NSTextView_MinSize_MinSize,
            ],
            LookinAttrSec_NSTextView_Resizable: @[
                LookinAttr_NSTextView_Resizable_Horizontal,
                LookinAttr_NSTextView_Resizable_Vertical,
            ],
            
            LookinAttrSec_NSTextField_Bordered: @[
                LookinAttr_NSTextField_Bordered_Bordered
            ],
            LookinAttrSec_NSTextField_Bezeled: @[
                LookinAttr_NSTextField_Bezeled_Bezeled
            ],
            LookinAttrSec_NSTextField_BezelStyle: @[
                LookinAttr_NSTextField_BezelStyle_BezelStyle
            ],
            LookinAttrSec_NSTextField_Editable: @[
                LookinAttr_NSTextField_Editable_Editable
            ],
            LookinAttrSec_NSTextField_Selectable: @[
                LookinAttr_NSTextField_Selectable_Selectable
            ],
            LookinAttrSec_NSTextField_DrawsBackground: @[
                LookinAttr_NSTextField_DrawsBackground_DrawsBackground
            ],
            LookinAttrSec_NSTextField_PreferredMaxLayoutWidth: @[
                LookinAttr_NSTextField_PreferredMaxLayoutWidth_PreferredMaxLayoutWidth
            ],
            LookinAttrSec_NSTextField_MaximumNumberOfLines: @[
                LookinAttr_NSTextField_MaximumNumberOfLines_MaximumNumberOfLines
            ],
            LookinAttrSec_NSTextField_AllowsDefaultTighteningForTruncation: @[
                LookinAttr_NSTextField_AllowsDefaultTighteningForTruncation_AllowsDefaultTighteningForTruncation
            ],
            LookinAttrSec_NSTextField_LineBreakStrategy: @[
                LookinAttr_NSTextField_LineBreakStrategy_LineBreakStrategy
            ],
            LookinAttrSec_NSTextField_Placeholder: @[
                LookinAttr_NSTextField_Placeholder_Placeholder
            ],
            LookinAttrSec_NSTextField_TextColor: @[
                LookinAttr_NSTextField_TextColor_Color
            ],
            
            
            
            
            LookinAttrSec_NSVisualEffectView_Material: @[
                LookinAttr_NSVisualEffectView_Material_Material
            ],
            LookinAttrSec_NSVisualEffectView_InteriorBackgroundStyle: @[
                LookinAttr_NSVisualEffectView_InteriorBackgroundStyle_InteriorBackgroundStyle
            ],
            LookinAttrSec_NSVisualEffectView_BlendingMode: @[
                LookinAttr_NSVisualEffectView_BlendingMode_BlendingMode
            ],
            LookinAttrSec_NSVisualEffectView_State: @[
                LookinAttr_NSVisualEffectView_State_State
            ],
            LookinAttrSec_NSVisualEffectView_Emphasized: @[
                LookinAttr_NSVisualEffectView_Emphasized_Emphasized
            ],
            
            
            
            LookinAttrSec_NSStackView_Orientation:@[
                LookinAttr_NSStackView_Orientation_Orientation
            ],
            LookinAttrSec_NSStackView_EdgeInsets:@[
                LookinAttr_NSStackView_EdgeInsets_EdgeInsets
            ],
            LookinAttrSec_NSStackView_DetachesHiddenViews:@[
                LookinAttr_NSStackView_DetachesHiddenViews_DetachesHiddenViews
            ],
            LookinAttrSec_NSStackView_Distribution:@[
                LookinAttr_NSStackView_Distribution_Distribution
            ],
            LookinAttrSec_NSStackView_Alignment:@[
                LookinAttr_NSStackView_Alignment_Alignment
            ],
            LookinAttrSec_NSStackView_Spacing:@[
                LookinAttr_NSStackView_Spacing_Spacing
            ],
            
#endif
        };
    });
    return dict[sectionID];
}

+ (void)getHostGroupID:(inout LookinAttrGroupIdentifier *)groupID_inout sectionID:(inout LookinAttrSectionIdentifier *)sectionID_inout fromAttrID:(LookinAttrIdentifier)targetAttrID {
    __block LookinAttrGroupIdentifier targetGroupID = nil;
    __block LookinAttrSectionIdentifier targetSecID = nil;
    [[self groupIDs] enumerateObjectsUsingBlock:^(LookinAttrGroupIdentifier _Nonnull groupID, NSUInteger idx, BOOL * _Nonnull stop0) {
        [[self sectionIDsForGroupID:groupID] enumerateObjectsUsingBlock:^(LookinAttrSectionIdentifier _Nonnull secID, NSUInteger idx, BOOL * _Nonnull stop1) {
            [[self attrIDsForSectionID:secID] enumerateObjectsUsingBlock:^(LookinAttrIdentifier _Nonnull attrID, NSUInteger idx, BOOL * _Nonnull stop2) {
                if ([attrID isEqualToString:targetAttrID]) {
                    targetGroupID = groupID;
                    targetSecID = secID;
                    *stop0 = YES;
                    *stop1 = YES;
                    *stop2 = YES;
                }
            }];
        }];
    }];
    
    if (groupID_inout && targetGroupID) {
        *groupID_inout = targetGroupID;
    }
    if (sectionID_inout && targetSecID) {
        *sectionID_inout = targetSecID;
    }
}

+ (NSString *)groupTitleWithGroupID:(LookinAttrGroupIdentifier)groupID {
    static dispatch_once_t onceToken;
    static NSDictionary *rawInfo = nil;
    dispatch_once(&onceToken,^{
        rawInfo = @{
            LookinAttrGroup_Class: @"Class",
            LookinAttrGroup_Relation: @"Relation",
            LookinAttrGroup_Layout: @"Layout",
            LookinAttrGroup_AutoLayout: @"AutoLayout",
            LookinAttrGroup_ViewLayer: @"CALayer / UIView",
            LookinAttrGroup_UIImageView: @"UIImageView",
            LookinAttrGroup_UILabel: @"UILabel",
            LookinAttrGroup_UIControl: @"UIControl",
            LookinAttrGroup_UIButton: @"UIButton",
            LookinAttrGroup_UIScrollView: @"UIScrollView",
            LookinAttrGroup_UITableView: @"UITableView",
            LookinAttrGroup_UITextView: @"UITextView",
            LookinAttrGroup_UITextField: @"UITextField",
            LookinAttrGroup_UIVisualEffectView: @"UIVisualEffectView",
            LookinAttrGroup_UIStackView: @"UIStackView",
            LookinAttrGroup_ViewLayer:          @"CALayer / NSView",
            LookinAttrGroup_NSImageView:        @"NSImageView",
            LookinAttrGroup_NSControl:          @"NSControl",
            LookinAttrGroup_NSButton:           @"NSButton",
            LookinAttrGroup_NSScrollView:       @"NSScrollView",
            LookinAttrGroup_NSTableView:        @"NSTableView",
            LookinAttrGroup_NSTextView:         @"NSTextView",
            LookinAttrGroup_NSTextField:        @"NSTextField",
            LookinAttrGroup_NSVisualEffectView: @"NSVisualEffectView",
            LookinAttrGroup_NSStackView:        @"NSStackView"
        };
    });
    NSString *title = rawInfo[groupID];
    NSAssert(title.length, @"");
    return title;
}

+ (NSString *)sectionTitleWithSectionID:(LookinAttrSectionIdentifier)secID {
    static dispatch_once_t onceToken;
    static NSDictionary *rawInfo = nil;
    dispatch_once(&onceToken,^{
        rawInfo = @{
            LookinAttrSec_Layout_Frame: @"Frame",
            LookinAttrSec_Layout_Bounds: @"Bounds",
            LookinAttrSec_Layout_SafeArea: @"SafeArea",
            LookinAttrSec_Layout_Position: @"Position",
            LookinAttrSec_Layout_AnchorPoint: @"AnchorPoint",
            LookinAttrSec_AutoLayout_Hugging: @"HuggingPriority",
            LookinAttrSec_AutoLayout_Resistance: @"ResistancePriority",
            LookinAttrSec_AutoLayout_IntrinsicSize: @"IntrinsicSize",
            LookinAttrSec_ViewLayer_Corner: @"CornerRadius",
            LookinAttrSec_ViewLayer_BgColor: @"BackgroundColor",
            LookinAttrSec_ViewLayer_Border: @"Border",
            LookinAttrSec_ViewLayer_Shadow: @"Shadow",
            LookinAttrSec_ViewLayer_Tag: @"Tag",
            LookinAttrSec_ViewLayer_ContentMode: @"ContentMode",
            LookinAttrSec_ViewLayer_TintColor: @"TintColor",
            LookinAttrSec_UIStackView_Axis: @"Axis",
            LookinAttrSec_UIStackView_Distribution: @"Distribution",
            LookinAttrSec_UIStackView_Alignment: @"Alignment",
            LookinAttrSec_UIVisualEffectView_Style: @"Style",
            LookinAttrSec_UIVisualEffectView_QMUIForegroundColor: @"ForegroundColor",
            LookinAttrSec_UIImageView_Name: @"ImageName",
            LookinAttrSec_UILabel_TextColor: @"TextColor",
            LookinAttrSec_UITextView_TextColor: @"TextColor",
            LookinAttrSec_UITextField_TextColor: @"TextColor",
            LookinAttrSec_UILabel_BreakMode: @"LineBreakMode",
            LookinAttrSec_UILabel_NumberOfLines: @"NumberOfLines",
            LookinAttrSec_UILabel_Text: @"Text",
            LookinAttrSec_UITextView_Text: @"Text",
            LookinAttrSec_UITextField_Text: @"Text",
            LookinAttrSec_UITextField_Placeholder: @"Placeholder",
            LookinAttrSec_UILabel_Alignment: @"TextAlignment",
            LookinAttrSec_UITextView_Alignment: @"TextAlignment",
            LookinAttrSec_UITextField_Alignment: @"TextAlignment",
            LookinAttrSec_UIControl_HorAlignment: @"HorizontalAlignment",
            LookinAttrSec_UIControl_VerAlignment: @"VerticalAlignment",
            LookinAttrSec_UIControl_QMUIOutsideEdge: @"QMUI_outsideEdge",
            LookinAttrSec_UIButton_ContentInsets: @"ContentInsets",
            LookinAttrSec_UIButton_TitleInsets: @"TitleInsets",
            LookinAttrSec_UIButton_ImageInsets: @"ImageInsets",
            LookinAttrSec_UIScrollView_QMUIInitialInset: @"QMUI_initialContentInset",
            LookinAttrSec_UIScrollView_ContentInset: @"ContentInset",
            LookinAttrSec_UIScrollView_AdjustedInset: @"AdjustedContentInset",
            LookinAttrSec_UIScrollView_IndicatorInset: @"ScrollIndicatorInsets",
            LookinAttrSec_UIScrollView_Offset: @"ContentOffset",
            LookinAttrSec_UIScrollView_ContentSize: @"ContentSize",
            LookinAttrSec_UIScrollView_Behavior: @"InsetAdjustmentBehavior",
            LookinAttrSec_UIScrollView_ShowsIndicator: @"ShowsScrollIndicator",
            LookinAttrSec_UIScrollView_Bounce: @"AlwaysBounce",
            LookinAttrSec_UIScrollView_Zoom: @"Zoom",
            LookinAttrSec_UITableView_Style: @"Style",
            LookinAttrSec_UITableView_SectionsNumber: @"NumberOfSections",
            LookinAttrSec_UITableView_RowsNumber: @"NumberOfRows",
            LookinAttrSec_UITableView_SeparatorColor: @"SeparatorColor",
            LookinAttrSec_UITableView_SeparatorInset: @"SeparatorInset",
            LookinAttrSec_UITableView_SeparatorStyle: @"SeparatorStyle",
            LookinAttrSec_UILabel_Font: @"Font",
            LookinAttrSec_UITextField_Font: @"Font",
            LookinAttrSec_UITextView_Font: @"Font",
            LookinAttrSec_UITextView_ContainerInset: @"ContainerInset",
            LookinAttrSec_UITextField_ClearButtonMode: @"ClearButtonMode",
            LookinAttrSec_NSImageView_Name: @"ImageName",
            LookinAttrSec_NSImageView_Open: @"Open",
            LookinAttrSec_NSControl_State: @"State",
            LookinAttrSec_NSControl_ControlSize: @"ControlSize",
            LookinAttrSec_NSControl_Font: @"Font",
            LookinAttrSec_NSControl_Alignment: @"Alignment",
            LookinAttrSec_NSControl_Misc: @"Misc",
            LookinAttrSec_NSControl_Value: @"Value",
            LookinAttrSec_NSButton_ButtonType: @"ButtonType",
            LookinAttrSec_NSButton_Title: @"Title",
            LookinAttrSec_NSButton_BezelStyle: @"BezelStyle",
            LookinAttrSec_NSButton_Bordered: @"Bordered",
            LookinAttrSec_NSButton_Transparent: @"Transparent",
            LookinAttrSec_NSButton_BezelColor: @"BezelColor",
            LookinAttrSec_NSButton_ContentTintColor: @"ContentTintColor",
            LookinAttrSec_NSButton_Misc: @"Misc",
            LookinAttrSec_NSScrollView_ContentOffset: @"ContentOffset",
            LookinAttrSec_NSScrollView_ContentSize: @"ContentSize",
            LookinAttrSec_NSScrollView_ContentInset: @"ContentInset",
            LookinAttrSec_NSScrollView_BorderType: @"BorderType",
            LookinAttrSec_NSScrollView_Scroller: @"Scroller",
            LookinAttrSec_NSScrollView_Ruler: @"Ruler",
            LookinAttrSec_NSScrollView_LineScroll: @"LineScroll",
            LookinAttrSec_NSScrollView_PageScroll: @"PageScroll",
            LookinAttrSec_NSScrollView_ScrollElasiticity: @"ScrollElasiticity",
            LookinAttrSec_NSScrollView_Misc: @"Misc",
            LookinAttrSec_NSScrollView_Magnification: @"Magnification",
            LookinAttrSec_NSTableView_RowHeight: @"RowHeight",
            LookinAttrSec_NSTableView_AutomaticRowHeights: @"AutomaticRowHeights",
            LookinAttrSec_NSTableView_IntercellSpacing: @"IntercellSpacing",
            LookinAttrSec_NSTableView_Style: @"Style",
            LookinAttrSec_NSTableView_ColumnAutoresizingStyle: @"ColumnAutoresizingStyle",
            LookinAttrSec_NSTableView_GridStyleMask: @"GridStyleMask",
            LookinAttrSec_NSTableView_SelectionHighlightStyle: @"SelectionHighlightStyle",
            LookinAttrSec_NSTableView_GridColor: @"GridColor",
            LookinAttrSec_NSTableView_RowSizeStyle: @"RowSizeStyle",
            LookinAttrSec_NSTableView_NumberOfRows: @"NumberOfRows",
            LookinAttrSec_NSTableView_NumberOfColumns: @"NumberOfColumns",
            LookinAttrSec_NSTableView_UseAlternatingRowBackgroundColors: @"UseAlternatingRowBackgroundColors",
            LookinAttrSec_NSTableView_AllowsColumnReordering: @"AllowsColumnReordering",
            LookinAttrSec_NSTableView_AllowsColumnResizing: @"AllowsColumnResizing",
            LookinAttrSec_NSTableView_AllowsMultipleSelection: @"AllowsMultipleSelection",
            LookinAttrSec_NSTableView_AllowsEmptySelection: @"AllowsEmptySelection",
            LookinAttrSec_NSTableView_AllowsColumnSelection: @"AllowsColumnSelection",
            LookinAttrSec_NSTableView_AllowsTypeSelect: @"AllowsTypeSelect",
            LookinAttrSec_NSTableView_DraggingDestinationFeedbackStyle: @"DraggingDestinationFeedbackStyle",
            LookinAttrSec_NSTableView_Autosave: @"Autosave",
            LookinAttrSec_NSTableView_FloatsGroupRows: @"FloatsGroupRows",
            LookinAttrSec_NSTableView_RowActionsVisible: @"RowActionsVisible",
            LookinAttrSec_NSTableView_UsesStaticContents: @"UsesStaticContents",
            LookinAttrSec_NSTableView_UserInterfaceLayoutDirection: @"UserInterfaceLayoutDirection",
            LookinAttrSec_NSTableView_VerticalMotionCanBeginDrag: @"VerticalMotionCanBeginDrag",
            LookinAttrSec_NSTextView_Font: @"Font",
            LookinAttrSec_NSTextView_Basic: @"Basic",
            LookinAttrSec_NSTextView_String: @"String",
            LookinAttrSec_NSTextView_TextColor: @"TextColor",
            LookinAttrSec_NSTextView_Alignment: @"Alignment",
            LookinAttrSec_NSTextView_ContainerInset: @"ContainerInset",
            LookinAttrSec_NSTextView_BaseWritingDirection: @"BaseWritingDirection",
            LookinAttrSec_NSTextView_Size: @"Size",
            LookinAttrSec_NSTextView_Resizable: @"Resizable",
            LookinAttrSec_NSTextField_Bordered: @"Bordered",
            LookinAttrSec_NSTextField_Bezeled: @"Bezeled",
            LookinAttrSec_NSTextField_BezelStyle: @"BezelStyle",
            LookinAttrSec_NSTextField_Editable: @"Editable",
            LookinAttrSec_NSTextField_Selectable: @"Selectable",
            LookinAttrSec_NSTextField_DrawsBackground: @"DrawsBackground",
            LookinAttrSec_NSTextField_PreferredMaxLayoutWidth: @"PreferredMaxLayoutWidth",
            LookinAttrSec_NSTextField_MaximumNumberOfLines: @"MaximumNumberOfLines",
            LookinAttrSec_NSTextField_AllowsDefaultTighteningForTruncation: @"AllowsDefaultTighteningForTruncation",
            LookinAttrSec_NSTextField_LineBreakStrategy: @"LineBreakStrategy",
            LookinAttrSec_NSTextField_Placeholder: @"Placeholder",
            LookinAttrSec_NSTextField_TextColor: @"TextColor",
            LookinAttrSec_NSVisualEffectView_Material: @"Material",
            LookinAttrSec_NSVisualEffectView_InteriorBackgroundStyle: @"InteriorBackgroundStyle",
            LookinAttrSec_NSVisualEffectView_BlendingMode: @"BlendingMode",
            LookinAttrSec_NSVisualEffectView_State: @"State",
            LookinAttrSec_NSVisualEffectView_Emphasized: @"Emphasized",
            LookinAttrSec_NSStackView_Orientation: @"Orientation",
            LookinAttrSec_NSStackView_EdgeInsets: @"EdgeInsets",
            LookinAttrSec_NSStackView_DetachesHiddenViews: @"DetachesHiddenViews",
            LookinAttrSec_NSStackView_Distribution: @"Distribution",
            LookinAttrSec_NSStackView_Alignment: @"Alignment",
            LookinAttrSec_NSStackView_Spacing: @"Spacing",
        };
    });
    return rawInfo[secID];
}

/**
 className: 必填项，标识该属性是哪一个类拥有的
 
 fullTitle: 完整的名字，将作为搜索的 keywords，也会展示在搜索结果中，如果为 nil 则不会被搜索到
 
 briefTitle：简略的名字，仅 checkbox 和那种自带标题的 input 才需要这个属性，如果需要该属性但该属性又为空，则会读取 fullTitle
 
 setterString：用户试图修改属性值时会用到，若该字段为空字符串（即 @“”）则该属性不可修改，若该字段为 nil 则会在 fullTitle 的基础上自动生成（自动改首字母大小写、加前缀后缀，比如 alpha 会被转换为 setAlpha:）
 
 getterString：必填项，业务中读取属性值时会用到。如果该字段为 nil ，则会在 fullTitle 的基础上自动生成（自动把 fullTitle 的第一个字母改成小写，比如 Alpha 会被转换为 alpha）。如果该字段为空字符串（比如 image_open_open）则属性值会被固定为 nil，attrType 会被指为 LookinAttrTypeCustomObj
 
 typeIfObj：当某个 LookinAttribute 确定是 NSObject 类型时，该方法返回它具体是什么对象，比如 UIColor、NSString
 
 enumList：如果某个 attribute 是 enum，则这里标识了相应的 enum 的名称（如 "NSTextAlignment"），业务可通过这个名称进而查询可用的枚举值列表
 
 patch：如果为 YES，则用户修改了该 Attribute 的值后，Lookin 会重新拉取和更新相关图层的位置、截图等信息，如果为 nil 则默认是 NO
 
 hideIfNil：如果为 YES，则当获取的 value 为 nil 时，Lookin 不会传输该 attr。如果为 NO，则即使 value 为 nil 也会传输（比如 label 的 text 属性，即使它是 nil 我们也要显示，所以它的 hideIfNil 应该为 NO）。如果该字段为 nil 则默认是 NO
 
 osVersion: 该属性需要的最低的 iOS 版本，比如 safeAreaInsets 从 iOS 11.0 开始出现，则该属性应该为 @11，如果为 nil 则表示不限制 iOS 版本
 
 */
+ (NSDictionary<NSString *, id> *)_infoForAttrID:(LookinAttrIdentifier)attrID {
    static NSDictionary<LookinAttrIdentifier, NSDictionary<NSString *, id> *> *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        dict = @{
            LookinAttr_Class_Class_Class: @{
                @"className": @"CALayer",
                @"getterString": @"lks_relatedClassChainList",
                @"setterString": @"",
                @"typeIfObj": @(LookinAttrTypeCustomObj)
            },
            
            LookinAttr_Relation_Relation_Relation: @{
                @"className": @"CALayer",
                @"getterString": @"lks_selfRelation",
                @"setterString": @"",
                @"typeIfObj": @(LookinAttrTypeCustomObj),
                @"hideIfNil": @(YES)
            },
            
            LookinAttr_Layout_Frame_Frame: @{
                @"className": @"CALayer",
                @"fullTitle": @"Frame",
                @"patch": @(YES)
            },
            LookinAttr_Layout_Bounds_Bounds: @{
                @"className": @"CALayer",
                @"fullTitle": @"Bounds",
                @"patch": @(YES)
            },
            LookinAttr_Layout_SafeArea_SafeArea: @{
                @"className": @"UIView",
                @"fullTitle": @"SafeAreaInsets",
                @"setterString": @"",
                @"osVersion": @(11)
            },
            LookinAttr_Layout_SafeArea_SafeArea: @{
                @"className": @"NSView",
                @"fullTitle": @"SafeAreaInsets",
                @"setterString": @"",
                @"osVersion": @(11)
            },
            LookinAttr_Layout_Position_Position: @{
                @"className": @"CALayer",
                @"fullTitle": @"Position",
                @"patch": @(YES)
            },
            LookinAttr_Layout_AnchorPoint_AnchorPoint: @{
                @"className": @"CALayer",
                @"fullTitle": @"AnchorPoint",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Hugging_Hor: @{
                @"className": @"UIView",
                @"fullTitle": @"ContentHuggingPriority(Horizontal)",
                @"getterString": @"lks_horizontalContentHuggingPriority",
                @"setterString": @"setLks_horizontalContentHuggingPriority:",
                @"briefTitle": @"H",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Hugging_Ver: @{
                @"className": @"UIView",
                @"fullTitle": @"ContentHuggingPriority(Vertical)",
                @"getterString": @"lks_verticalContentHuggingPriority",
                @"setterString": @"setLks_verticalContentHuggingPriority:",
                @"briefTitle": @"V",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Resistance_Hor: @{
                @"className": @"UIView",
                @"fullTitle": @"ContentCompressionResistancePriority(Horizontal)",
                @"getterString": @"lks_horizontalContentCompressionResistancePriority",
                @"setterString": @"setLks_horizontalContentCompressionResistancePriority:",
                @"briefTitle": @"H",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Resistance_Ver: @{
                @"className": @"UIView",
                @"fullTitle": @"ContentCompressionResistancePriority(Vertical)",
                @"getterString": @"lks_verticalContentCompressionResistancePriority",
                @"setterString": @"setLks_verticalContentCompressionResistancePriority:",
                @"briefTitle": @"V",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Constraints_Constraints: @{
                @"className": @"UIView",
                @"getterString": @"lks_constraints",
                @"setterString": @"",
                @"typeIfObj": @(LookinAttrTypeCustomObj),
                @"hideIfNil": @(YES)
            },
            LookinAttr_AutoLayout_IntrinsicSize_Size: @{
                @"className": @"UIView",
                @"fullTitle": @"IntrinsicContentSize",
                @"setterString": @""
            },
            LookinAttr_AutoLayout_Hugging_Hor: @{
                @"className": @"NSView",
                @"fullTitle": @"ContentHuggingPriority(Horizontal)",
                @"getterString": @"lks_horizontalContentHuggingPriority",
                @"setterString": @"setLks_horizontalContentHuggingPriority:",
                @"briefTitle": @"H",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Hugging_Ver: @{
                @"className": @"NSView",
                @"fullTitle": @"ContentHuggingPriority(Vertical)",
                @"getterString": @"lks_verticalContentHuggingPriority",
                @"setterString": @"setLks_verticalContentHuggingPriority:",
                @"briefTitle": @"V",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Resistance_Hor: @{
                @"className": @"NSView",
                @"fullTitle": @"ContentCompressionResistancePriority(Horizontal)",
                @"getterString": @"lks_horizontalContentCompressionResistancePriority",
                @"setterString": @"setLks_horizontalContentCompressionResistancePriority:",
                @"briefTitle": @"H",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Resistance_Ver: @{
                @"className": @"NSView",
                @"fullTitle": @"ContentCompressionResistancePriority(Vertical)",
                @"getterString": @"lks_verticalContentCompressionResistancePriority",
                @"setterString": @"setLks_verticalContentCompressionResistancePriority:",
                @"briefTitle": @"V",
                @"patch": @(YES)
            },
            LookinAttr_AutoLayout_Constraints_Constraints: @{
                @"className": @"NSView",
                @"getterString": @"lks_constraints",
                @"setterString": @"",
                @"typeIfObj": @(LookinAttrTypeCustomObj),
                @"hideIfNil": @(YES)
            },
            LookinAttr_AutoLayout_IntrinsicSize_Size: @{
                @"className": @"NSView",
                @"fullTitle": @"IntrinsicContentSize",
                @"setterString": @""
            },
            
            LookinAttr_ViewLayer_InterationAndMasks_Interaction: @{
                @"className": @"UIView",
                @"fullTitle": @"UserInteractionEnabled",
                @"getterString": @"isUserInteractionEnabled",
                @"patch": @(NO)
            },
            
            LookinAttr_ViewLayer_ContentMode_Mode: @{
                @"className": @"UIView",
                @"fullTitle": @"ContentMode",
                @"enumList": @"UIViewContentMode",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_TintColor_Color: @{
                @"className": @"UIView",
                @"fullTitle": @"TintColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_TintColor_Mode: @{
                @"className": @"UIView",
                @"fullTitle": @"TintAdjustmentMode",
                @"enumList": @"UIViewTintAdjustmentMode",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Tag_Tag: @{
                @"className": @"UIView",
                @"fullTitle": @"Tag",
                @"briefTitle": @"",
                @"patch": @(NO)
            },
            
            LookinAttr_ViewLayer_Tag_Tag: @{
                @"className": @"NSView",
                @"fullTitle": @"Tag",
                @"briefTitle": @"",
                @"patch": @(NO)
            },
            LookinAttr_ViewLayer_Visibility_Hidden: @{
                @"className": @"CALayer",
                @"fullTitle": @"Hidden",
                @"getterString": @"isHidden",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Visibility_Opacity: @{
                @"className": @"CALayer",
                @"fullTitle": @"Opacity / Alpha",
                @"setterString": @"setOpacity:",
                @"getterString": @"opacity",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds: @{
                @"className": @"CALayer",
                @"fullTitle": @"MasksToBounds / ClipsToBounds",
                @"briefTitle": @"MasksToBounds",
                @"setterString": @"setMasksToBounds:",
                @"getterString": @"masksToBounds",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Corner_Radius: @{
                @"className": @"CALayer",
                @"fullTitle": @"CornerRadius",
                @"briefTitle": @"",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_BgColor_BgColor: @{
                @"className": @"CALayer",
                @"fullTitle": @"BackgroundColor",
                @"setterString": @"setLks_backgroundColor:",
                @"getterString": @"lks_backgroundColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Border_Color: @{
                @"className": @"CALayer",
                @"fullTitle": @"BorderColor",
                @"setterString": @"setLks_borderColor:",
                @"getterString": @"lks_borderColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Border_Width: @{
                @"className": @"CALayer",
                @"fullTitle": @"BorderWidth",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Shadow_Color: @{
                @"className": @"CALayer",
                @"fullTitle": @"ShadowColor",
                @"setterString": @"setLks_shadowColor:",
                @"getterString": @"lks_shadowColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Shadow_Opacity: @{
                @"className": @"CALayer",
                @"fullTitle": @"ShadowOpacity",
                @"briefTitle": @"Opacity",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Shadow_Radius: @{
                @"className": @"CALayer",
                @"fullTitle": @"ShadowRadius",
                @"briefTitle": @"Radius",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Shadow_OffsetW: @{
                @"className": @"CALayer",
                @"fullTitle": @"ShadowOffsetWidth",
                @"briefTitle": @"OffsetW",
                @"setterString": @"setLks_shadowOffsetWidth:",
                @"getterString": @"lks_shadowOffsetWidth",
                @"patch": @(YES)
            },
            LookinAttr_ViewLayer_Shadow_OffsetH: @{
                @"className": @"CALayer",
                @"fullTitle": @"ShadowOffsetHeight",
                @"briefTitle": @"OffsetH",
                @"setterString": @"setLks_shadowOffsetHeight:",
                @"getterString": @"lks_shadowOffsetHeight",
                @"patch": @(YES)
            },
            
            LookinAttr_UIStackView_Axis_Axis: @{
                @"className": @"UIStackView",
                @"fullTitle": @"Axis",
                @"enumList": @"UILayoutConstraintAxis",
                @"patch": @(YES)
            },
            
            LookinAttr_UIStackView_Distribution_Distribution: @{
                @"className": @"UIStackView",
                @"fullTitle": @"Distribution",
                @"enumList": @"UIStackViewDistribution",
                @"patch": @(YES)
            },
            
            LookinAttr_UIStackView_Alignment_Alignment: @{
                @"className": @"UIStackView",
                @"fullTitle": @"Alignment",
                @"enumList": @"UIStackViewAlignment",
                @"patch": @(YES)
            },
            
            LookinAttr_UIStackView_Spacing_Spacing: @{
                @"className": @"UIStackView",
                @"fullTitle": @"Spacing",
                @"patch": @(YES)
            },
            
            LookinAttr_UIVisualEffectView_Style_Style: @{
                @"className": @"UIVisualEffectView",
                @"setterString": @"setLks_blurEffectStyleNumber:",
                @"getterString": @"lks_blurEffectStyleNumber",
                @"enumList": @"UIBlurEffectStyle",
                @"typeIfObj": @(LookinAttrTypeCustomObj),
                @"patch": @(YES),
                @"hideIfNil": @(YES)
            },
            
            LookinAttr_UIVisualEffectView_QMUIForegroundColor_Color: @{
                @"className": @"QMUIVisualEffectView",
                @"fullTitle": @"ForegroundColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES),
            },
            
            LookinAttr_UIImageView_Name_Name: @{
                @"className": @"UIImageView",
                @"fullTitle": @"ImageName",
                @"setterString": @"",
                @"getterString": @"lks_imageSourceName",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"hideIfNil": @(YES)
            },
            LookinAttr_UIImageView_Open_Open: @{
                @"className": @"UIImageView",
                @"setterString": @"",
                @"getterString": @"lks_imageViewOidIfHasImage",
                @"typeIfObj": @(LookinAttrTypeCustomObj),
                @"hideIfNil": @(YES)
            },
            
            LookinAttr_UILabel_Text_Text: @{
                @"className": @"UILabel",
                @"fullTitle": @"Text",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_UILabel_NumberOfLines_NumberOfLines: @{
                @"className": @"UILabel",
                @"fullTitle": @"NumberOfLines",
                @"briefTitle": @"",
                @"patch": @(YES)
            },
            LookinAttr_UILabel_Font_Size: @{
                @"className": @"UILabel",
                @"fullTitle": @"FontSize",
                @"briefTitle": @"FontSize",
                @"setterString": @"setLks_fontSize:",
                @"getterString": @"lks_fontSize",
                @"patch": @(YES)
            },
            LookinAttr_UILabel_Font_Name: @{
                @"className": @"UILabel",
                @"fullTitle": @"FontName",
                @"setterString": @"",
                @"getterString": @"lks_fontName",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(NO)
            },
            LookinAttr_UILabel_TextColor_Color: @{
                @"className": @"UILabel",
                @"fullTitle": @"TextColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_UILabel_Alignment_Alignment: @{
                @"className": @"UILabel",
                @"fullTitle": @"TextAlignment",
                @"enumList": @"NSTextAlignment",
                @"patch": @(YES)
            },
            LookinAttr_UILabel_BreakMode_Mode: @{
                @"className": @"UILabel",
                @"fullTitle": @"LineBreakMode",
                @"enumList": @"NSLineBreakMode",
                @"patch": @(YES)
            },
            LookinAttr_UILabel_CanAdjustFont_CanAdjustFont: @{
                @"className": @"UILabel",
                @"fullTitle": @"AdjustsFontSizeToFitWidth",
                @"patch": @(YES)
            },
            
            LookinAttr_UIControl_EnabledSelected_Enabled: @{
                @"className": @"UIControl",
                @"fullTitle": @"Enabled",
                @"getterString": @"isEnabled",
                @"patch": @(NO)
            },
            LookinAttr_UIControl_EnabledSelected_Selected: @{
                @"className": @"UIControl",
                @"fullTitle": @"Selected",
                @"getterString": @"isSelected",
                @"patch": @(YES)
            },
            LookinAttr_UIControl_VerAlignment_Alignment: @{
                @"className": @"UIControl",
                @"fullTitle": @"ContentVerticalAlignment",
                @"enumList": @"UIControlContentVerticalAlignment",
                @"patch": @(YES)
            },
            LookinAttr_UIControl_HorAlignment_Alignment: @{
                @"className": @"UIControl",
                @"fullTitle": @"ContentHorizontalAlignment",
                @"enumList": @"UIControlContentHorizontalAlignment",
                @"patch": @(YES)
            },
            LookinAttr_UIControl_QMUIOutsideEdge_Edge: @{
                @"className": @"UIControl",
                @"fullTitle": @"qmui_outsideEdge"
            },
            
            LookinAttr_UIButton_ContentInsets_Insets: @{
                @"className": @"UIButton",
                @"fullTitle": @"ContentEdgeInsets",
                @"patch": @(YES)
            },
            LookinAttr_UIButton_TitleInsets_Insets: @{
                @"className": @"UIButton",
                @"fullTitle": @"TitleEdgeInsets",
                @"patch": @(YES)
            },
            LookinAttr_UIButton_ImageInsets_Insets: @{
                @"className": @"UIButton",
                @"fullTitle": @"ImageEdgeInsets",
                @"patch": @(YES)
            },
            
            LookinAttr_UIScrollView_Offset_Offset: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ContentOffset",
                @"patch": @(YES)
            },
            LookinAttr_UIScrollView_ContentSize_Size: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ContentSize",
                @"patch": @(YES)
            },
            LookinAttr_UIScrollView_ContentInset_Inset: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ContentInset",
                @"patch": @(YES)
            },
            LookinAttr_UIScrollView_QMUIInitialInset_Inset: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"qmui_initialContentInset",
                @"patch": @(YES)
            },
            LookinAttr_UIScrollView_AdjustedInset_Inset: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"AdjustedContentInset",
                @"setterString": @"",
                @"osVersion": @(11)
            },
            LookinAttr_UIScrollView_Behavior_Behavior: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ContentInsetAdjustmentBehavior",
                @"enumList": @"UIScrollViewContentInsetAdjustmentBehavior",
                @"patch": @(YES),
                @"osVersion": @(11)
            },
            LookinAttr_UIScrollView_IndicatorInset_Inset: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ScrollIndicatorInsets",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ScrollEnabled",
                @"getterString": @"isScrollEnabled",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_ScrollPaging_PagingEnabled: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"PagingEnabled",
                @"getterString": @"isPagingEnabled",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_Bounce_Ver: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"AlwaysBounceVertical",
                @"briefTitle": @"Vertical",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_Bounce_Hor: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"AlwaysBounceHorizontal",
                @"briefTitle": @"Horizontal",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_ShowsIndicator_Hor: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ShowsHorizontalScrollIndicator",
                @"briefTitle": @"Horizontal",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_ShowsIndicator_Ver: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ShowsVerticalScrollIndicator",
                @"briefTitle": @"Vertical",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_ContentTouches_Delay: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"DelaysContentTouches",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_ContentTouches_CanCancel: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"CanCancelContentTouches",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_Zoom_MinScale: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"MinimumZoomScale",
                @"briefTitle": @"MinScale",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_Zoom_MaxScale: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"MaximumZoomScale",
                @"briefTitle": @"MaxScale",
                @"patch": @(NO)
            },
            LookinAttr_UIScrollView_Zoom_Scale: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"ZoomScale",
                @"briefTitle": @"Scale",
                @"patch": @(YES)
            },
            LookinAttr_UIScrollView_Zoom_Bounce: @{
                @"className": @"UIScrollView",
                @"fullTitle": @"BouncesZoom",
                @"patch": @(NO)
            },
            
            LookinAttr_UITableView_Style_Style: @{
                @"className": @"UITableView",
                @"fullTitle": @"Style",
                @"setterString": @"",
                @"enumList": @"UITableViewStyle",
                @"patch": @(YES)
            },
            LookinAttr_UITableView_SectionsNumber_Number: @{
                @"className": @"UITableView",
                @"fullTitle": @"NumberOfSections",
                @"setterString": @"",
                @"patch": @(YES)
            },
            LookinAttr_UITableView_RowsNumber_Number: @{
                @"className": @"UITableView",
                @"setterString": @"",
                @"getterString": @"lks_numberOfRows",
                @"typeIfObj": @(LookinAttrTypeCustomObj)
            },
            LookinAttr_UITableView_SeparatorInset_Inset: @{
                @"className": @"UITableView",
                @"fullTitle": @"SeparatorInset",
                @"patch": @(NO)
            },
            LookinAttr_UITableView_SeparatorColor_Color: @{
                @"className": @"UITableView",
                @"fullTitle": @"SeparatorColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_UITableView_SeparatorStyle_Style: @{
                @"className": @"UITableView",
                @"fullTitle": @"SeparatorStyle",
                @"enumList": @"UITableViewCellSeparatorStyle",
                @"patch": @(YES)
            },
            
            LookinAttr_UITextView_Text_Text: @{
                @"className": @"UITextView",
                @"fullTitle": @"Text",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_UITextView_Font_Name: @{
                @"className": @"UITextView",
                @"fullTitle": @"FontName",
                @"setterString": @"",
                @"getterString": @"lks_fontName",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(NO)
            },
            LookinAttr_UITextView_Font_Size: @{
                @"className": @"UITextView",
                @"fullTitle": @"FontSize",
                @"setterString": @"setLks_fontSize:",
                @"getterString": @"lks_fontSize",
                @"patch": @(YES)
            },
            LookinAttr_UITextView_Basic_Editable: @{
                @"className": @"UITextView",
                @"fullTitle": @"Editable",
                @"getterString": @"isEditable",
                @"patch": @(NO)
            },
            LookinAttr_UITextView_Basic_Selectable: @{
                @"className": @"UITextView",
                @"fullTitle": @"Selectable",
                @"getterString": @"isSelectable",
                @"patch": @(NO)
            },
            LookinAttr_UITextView_TextColor_Color: @{
                @"className": @"UITextView",
                @"fullTitle": @"TextColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_UITextView_Alignment_Alignment: @{
                @"className": @"UITextView",
                @"fullTitle": @"TextAlignment",
                @"enumList": @"NSTextAlignment",
                @"patch": @(YES)
            },
            LookinAttr_UITextView_ContainerInset_Inset: @{
                @"className": @"UITextView",
                @"fullTitle": @"TextContainerInset",
                @"patch": @(YES)
            },
            
            LookinAttr_UITextField_Font_Name: @{
                @"className": @"UITextField",
                @"fullTitle": @"FontName",
                @"setterString": @"",
                @"getterString": @"lks_fontName",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(NO)
            },
            LookinAttr_UITextField_Font_Size: @{
                @"className": @"UITextField",
                @"fullTitle": @"FontSize",
                @"setterString": @"setLks_fontSize:",
                @"getterString": @"lks_fontSize",
                @"patch": @(YES)
            },
            LookinAttr_UITextField_TextColor_Color: @{
                @"className": @"UITextField",
                @"fullTitle": @"TextColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_UITextField_Alignment_Alignment: @{
                @"className": @"UITextField",
                @"fullTitle": @"TextAlignment",
                @"enumList": @"NSTextAlignment",
                @"patch": @(YES)
            },
            LookinAttr_UITextField_Text_Text: @{
                @"className": @"UITextField",
                @"fullTitle": @"Text",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_UITextField_Placeholder_Placeholder: @{
                @"className": @"UITextField",
                @"fullTitle": @"Placeholder",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_UITextField_Clears_ClearsOnBeginEditing: @{
                @"className": @"UITextField",
                @"fullTitle": @"ClearsOnBeginEditing",
                @"patch": @(NO)
            },
            LookinAttr_UITextField_Clears_ClearsOnInsertion: @{
                @"className": @"UITextField",
                @"fullTitle": @"ClearsOnInsertion",
                @"patch": @(NO)
            },
            LookinAttr_UITextField_CanAdjustFont_CanAdjustFont: @{
                @"className": @"UITextField",
                @"fullTitle": @"AdjustsFontSizeToFitWidth",
                @"patch": @(YES)
            },
            LookinAttr_UITextField_CanAdjustFont_MinSize: @{
                @"className": @"UITextField",
                @"fullTitle": @"MinimumFontSize",
                @"patch": @(YES)
            },
            LookinAttr_UITextField_ClearButtonMode_Mode: @{
                @"className": @"UITextField",
                @"fullTitle": @"ClearButtonMode",
                @"enumList": @"UITextFieldViewMode",
                @"patch": @(NO)
            },
            LookinAttr_NSImageView_Name_Name: @{
                @"className": @"NSImageView",
                @"fullTitle": @"ImageName",
                @"setterString": @"",
                @"getterString": @"lks_imageSourceName",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"hideIfNil": @(YES)
            },
            LookinAttr_NSImageView_Open_Open: @{
                @"className": @"NSImageView",
                @"setterString": @"",
                @"getterString": @"lks_imageViewOidIfHasImage",
                @"typeIfObj": @(LookinAttrTypeCustomObj),
                @"hideIfNil": @(YES)
            },
            LookinAttr_NSControl_State_Enabled: @{
                @"className": @"NSControl",
                @"fullTitle": @"Enabled",
                @"getterString": @"isEnabled",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_State_Highlighted: @{
                @"className": @"NSControl",
                @"fullTitle": @"Highlighted",
                @"getterString": @"isHighlighted",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_State_Continuous: @{
                @"className": @"NSControl",
                @"fullTitle": @"Continuous",
                @"getterString": @"isContinuous",
                @"patch": @(NO)
            },
            LookinAttr_NSControl_ControlSize_Size: @{
                @"className": @"NSControl",
                @"fullTitle": @"ControlSize",
                @"enumList": @"NSControlSize",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_Font_Name: @{
                @"className": @"NSControl",
                @"fullTitle": @"FontName",
                @"setterString": @"",
                @"getterString": @"lks_fontName",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(NO)
            },
            LookinAttr_NSControl_Font_Size: @{
                @"className": @"NSControl",
                @"fullTitle": @"FontSize",
                @"setterString": @"setLks_fontSize:",
                @"getterString": @"lks_fontSize",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_Alignment_Alignment: @{
                @"className": @"NSControl",
                @"fullTitle": @"Alignment",
                @"enumList": @"NSTextAlignment_AppKit",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_Misc_WritingDirection: @{
                @"className": @"NSControl",
                @"fullTitle": @"BaseWritingDirection",
                @"enumList": @"NSWritingDirection",
                @"patch": @(NO)
            },
            LookinAttr_NSControl_Misc_IgnoresMultiClick: @{
                @"className": @"NSControl",
                @"fullTitle": @"IgnoresMultiClick",
                @"patch": @(NO)
            },
            LookinAttr_NSControl_Misc_UsesSingleLineMode: @{
                @"className": @"NSControl",
                @"fullTitle": @"UsesSingleLineMode",
                @"patch": @(NO)
            },
            LookinAttr_NSControl_Misc_AllowsExpansionToolTips: @{
                @"className": @"NSControl",
                @"fullTitle": @"AllowsExpansionToolTips",
                @"patch": @(NO)
            },
            LookinAttr_NSControl_Value_StringValue: @{
                @"className": @"NSControl",
                @"fullTitle": @"StringValue",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_NSControl_Value_IntValue: @{
                @"className": @"NSControl",
                @"fullTitle": @"IntValue",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_Value_IntegerValue: @{
                @"className": @"NSControl",
                @"fullTitle": @"IntegerValue",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_Value_FloatValue: @{
                @"className": @"NSControl",
                @"fullTitle": @"FloatValue",
                @"patch": @(YES)
            },
            LookinAttr_NSControl_Value_DoubleValue: @{
                @"className": @"NSControl",
                @"fullTitle": @"DoubleValue",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_ButtonType_ButtonType: @{
                @"className": @"NSButton",
                @"fullTitle": @"ButtonType",
                @"getterString": @"lks_buttonType",
                @"enumList": @"NSButtonType",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Title_Title: @{
                @"className": @"NSButton",
                @"fullTitle": @"Title",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Title_AlernateTitle: @{
                @"className": @"NSButton",
                @"fullTitle": @"AlternateTitle",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_NSButton_BezelStyle_BezelStyle: @{
                @"className": @"NSButton",
                @"fullTitle": @"BezelStyle",
                @"enumList": @"NSBezelStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Bordered_Bordered: @{
                @"className": @"NSButton",
                @"fullTitle": @"Bordered",
                @"getterString": @"isBordered",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Transparent_Transparent: @{
                @"className": @"NSButton",
                @"fullTitle": @"Transparent",
                @"getterString": @"isTransparent",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_BezelColor_BezelColor: @{
                @"className": @"NSButton",
                @"fullTitle": @"BezelColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_NSButton_ContentTintColor_ContentTintColor: @{
                @"className": @"NSButton",
                @"fullTitle": @"ContentTintColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Misc_ShowsBorderOnlyWhileMouseInside: @{
                @"className": @"NSButton",
                @"fullTitle": @"ShowsBorderOnlyWhileMouseInside",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Misc_MaxAcceleratorLevel: @{
                @"className": @"NSButton",
                @"fullTitle": @"MaxAcceleratorLevel",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Misc_SpringLoaded: @{
                @"className": @"NSButton",
                @"fullTitle": @"SpringLoaded",
                @"patch": @(YES)
            },
            LookinAttr_NSButton_Misc_HasDestructiveAction: @{
                @"className": @"NSButton",
                @"fullTitle": @"HasDestructiveAction",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_ContentOffset_Offset: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"ContentOffset",
                @"setterString": @"lks_setContentOffset:",
                @"getterString": @"lks_contentOffset",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_ContentSize_Size: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"ContentSize",
                @"setterString": @"lks_setContentSize:",
                @"getterString": @"lks_contentSize",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_ContentInset_ContentInset: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"ContentInset",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_ContentInset_AutomaticallyAdjustsContentInsets: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"AutomaticallyAdjustsContentInsets",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_BorderType_BorderType: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"BorderType",
                @"enumList": @"NSBorderType",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Scroller_Horizontal: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"HasHorizontalScroller",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Scroller_Vertical: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"HasVerticalScroller",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Scroller_AutohidesScrollers: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"AutohidesScrollers",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Scroller_ScrollerStyle: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"ScrollerStyle",
                @"enumList": @"NSScrollerStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Scroller_ScrollerKnobStyle: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"ScrollerKnobStyle",
                @"enumList": @"NSScrollerKnobStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Scroller_ScrollerInsets: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"ScrollerInsets",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Ruler_Horizontal: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"HasHorizontalRuler",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Ruler_Vertical: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"HasVerticalRuler",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Ruler_Visible: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"RulersVisible",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_LineScroll_Horizontal: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"HorizontalLineScroll",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_LineScroll_Vertical: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"VerticalLineScroll",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_LineScroll_LineScroll: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"LineScroll",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_PageScroll_Horizontal: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"HorizontalPageScroll",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_PageScroll_Vertical: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"VerticalPageScroll",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_PageScroll_PageScroll: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"PageScroll",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_ScrollElasiticity_Horizontal: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"HorizontalScrollElasticity",
                @"enumList": @"NSScrollElasticity",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_ScrollElasiticity_Vertical: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"VerticalScrollElasticity",
                @"enumList": @"NSScrollElasticity",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Misc_ScrollsDynamically: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"ScrollsDynamically",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Misc_UsesPredominantAxisScrolling: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"UsesPredominantAxisScrolling",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Magnification_AllowsMagnification: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"AllowsMagnification",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Magnification_Magnification: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"Magnification",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Magnification_Max: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"MaximunMagnification",
                @"patch": @(YES)
            },
            LookinAttr_NSScrollView_Magnification_Min: @{
                @"className": @"NSScrollView",
                @"fullTitle": @"MinimumMagnification",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AllowsColumnReordering_AllowsColumnReordering: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AllowsColumnReordering",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AllowsColumnResizing_AllowsColumnResizing: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AllowsColumnResizing",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_ColumnAutoresizingStyle_ColumnAutoresizingStyle: @{
                @"className": @"NSTableView",
                @"fullTitle": @"ColumnAutoresizingStyle",
                @"enumList": @"NSTableViewColumnAutoresizingStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_GridStyleMask_GridStyleMask: @{
                @"className": @"NSTableView",
                @"fullTitle": @"GridStyleMask",
                @"enumList": @"NSTableViewGridLineStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_IntercellSpacing_IntercellSpacing: @{
                @"className": @"NSTableView",
                @"fullTitle": @"IntercellSpacing",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_UseAlternatingRowBackgroundColors_UseAlternatingRowBackgroundColors: @{
                @"className": @"NSTableView",
                @"fullTitle": @"UsesAlternatingRowBackgroundColors",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_GridColor_GridColor: @{
                @"className": @"NSTableView",
                @"fullTitle": @"GridColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_RowSizeStyle_RowSizeStyle: @{
                @"className": @"NSTableView",
                @"fullTitle": @"RowSizeStyle",
                @"enumList": @"NSTableViewRowSizeStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_RowHeight_RowHeight: @{
                @"className": @"NSTableView",
                @"fullTitle": @"RowHeight",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_NumberOfRows_NumberOfRows: @{
                @"className": @"NSTableView",
                @"fullTitle": @"NumberOfRows",
                @"setterString": @"",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_NumberOfColumns_NumberOfColumns: @{
                @"className": @"NSTableView",
                @"fullTitle": @"NumberOfColumns",
                @"setterString": @"",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_VerticalMotionCanBeginDrag_VerticalMotionCanBeginDrag: @{
                @"className": @"NSTableView",
                @"fullTitle": @"VerticalMotionCanBeginDrag",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AllowsMultipleSelection_AllowsMultipleSelection: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AllowsMultipleSelection",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AllowsEmptySelection_AllowsEmptySelection: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AllowsEmptySelection",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AllowsColumnSelection_AllowsColumnSelection: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AllowsColumnSelection",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AllowsTypeSelect_AllowsTypeSelect: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AllowsTypeSelect",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_SelectionHighlightStyle_SelectionHighlightStyle: @{
                @"className": @"NSTableView",
                @"fullTitle": @"SelectionHighlightStyle",
                @"enumList": @"NSTableViewSelectionHighlightStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_DraggingDestinationFeedbackStyle_DraggingDestinationFeedbackStyle: @{
                @"className": @"NSTableView",
                @"fullTitle": @"DraggingDestinationFeedbackStyle",
                @"enumList": @"NSTableViewDraggingDestinationFeedbackStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AutomaticRowHeights_AutomaticRowHeights: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AutomaticRowHeights",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AutosaveName_AutosaveName: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AutosaveName",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_AutosaveTableColumns_AutosaveTableColumns: @{
                @"className": @"NSTableView",
                @"fullTitle": @"AutosaveTableColumns",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_FloatsGroupRows_FloatsGroupRows: @{
                @"className": @"NSTableView",
                @"fullTitle": @"FloatsGroupRows",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_RowActionsVisible_RowActionsVisible: @{
                @"className": @"NSTableView",
                @"fullTitle": @"RowActionsVisible",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_UsesStaticContents_UsesStaticContents: @{
                @"className": @"NSTableView",
                @"fullTitle": @"UsesStaticContents",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_UserInterfaceLayoutDirection_UserInterfaceLayoutDirection: @{
                @"className": @"NSTableView",
                @"fullTitle": @"UserInterfaceLayoutDirection",
                @"enumList": @"NSUserInterfaceLayoutDirection",
                @"patch": @(YES)
            },
            LookinAttr_NSTableView_Style_Style: @{
                @"className": @"NSTableView",
                @"fullTitle": @"Style",
                @"enumList": @"NSTableViewStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_Font_Name: @{
                @"className": @"NSTextView",
                @"fullTitle": @"FontName",
                @"setterString": @"",
                @"getterString": @"lks_fontName",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_Font_Size: @{
                @"className": @"NSTextView",
                @"fullTitle": @"FontSize",
                @"setterString": @"setLks_fontSize:",
                @"getterString": @"lks_fontSize",
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_Basic_Editable: @{
                @"className": @"NSTextView",
                @"fullTitle": @"Editable",
                @"getterString": @"isEditable",
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_Basic_Selectable: @{
                @"className": @"NSTextView",
                @"fullTitle": @"Selectable",
                @"getterString": @"isSelectable",
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_Basic_RichText: @{
                @"className": @"NSTextView",
                @"fullTitle": @"RichText",
                @"getterString": @"isRichText",
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_Basic_FieldEditor: @{
                @"className": @"NSTextView",
                @"fullTitle": @"FieldEditor",
                @"getterString": @"isFieldEditor",
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_Basic_ImportsGraphics: @{
                @"className": @"NSTextView",
                @"fullTitle": @"ImportsGraphics",
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_String_String: @{
                @"className": @"NSTextView",
                @"fullTitle": @"String",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_TextColor_Color: @{
                @"className": @"NSTextView",
                @"fullTitle": @"TextColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_Alignment_Alignment: @{
                @"className": @"NSTextView",
                @"fullTitle": @"Alignment",
                @"enumList": @"NSTextAlignment_AppKit",
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_ContainerInset_Inset: @{
                @"className": @"NSTextView",
                @"fullTitle": @"TextContainerInset",
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_BaseWritingDirection_BaseWritingDirection: @{
                @"className": @"NSTextView",
                @"fullTitle": @"BaseWritingDirection",
                @"enumList": @"NSWritingDirection",
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_MaxSize_MaxSize: @{
                @"className": @"NSTextView",
                @"fullTitle": @"MaxSize",
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_MinSize_MinSize: @{
                @"className": @"NSTextView",
                @"fullTitle": @"MinSize",
                @"patch": @(YES)
            },
            LookinAttr_NSTextView_Resizable_Horizontal: @{
                @"className": @"NSTextView",
                @"fullTitle": @"HorizontallyResizable",
                @"patch": @(NO)
            },
            LookinAttr_NSTextView_Resizable_Vertical: @{
                @"className": @"NSTextView",
                @"fullTitle": @"VerticallyResizable",
                @"patch": @(NO)
            },
            LookinAttr_NSTextField_Bordered_Bordered: @{
                @"className": @"NSTextField",
                @"fullTitle": @"Bordered",
                @"getterString": @"isBordered",
                @"patch": @(NO)
            },
            LookinAttr_NSTextField_Bezeled_Bezeled: @{
                @"className": @"NSTextField",
                @"fullTitle": @"Bezeled",
                @"getterString": @"isBezeled",
                @"patch": @(NO)
            },
            LookinAttr_NSTextField_Editable_Editable: @{
                @"className": @"NSTextField",
                @"fullTitle": @"Editable",
                @"getterString": @"isEditable",
                @"patch": @(NO)
            },
            LookinAttr_NSTextField_Selectable_Selectable: @{
                @"className": @"NSTextField",
                @"fullTitle": @"Selectable",
                @"getterString": @"isSelectable",
                @"patch": @(NO)
            },
            LookinAttr_NSTextField_DrawsBackground_DrawsBackground: @{
                @"className": @"NSTextField",
                @"fullTitle": @"DrawsBackground",
                @"patch": @(YES)
            },
            LookinAttr_NSTextField_BezelStyle_BezelStyle: @{
                @"className": @"NSTextField",
                @"fullTitle": @"BezelStyle",
                @"enumList": @"NSTextFieldBezelStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSTextField_PreferredMaxLayoutWidth_PreferredMaxLayoutWidth: @{
                @"className": @"NSTextField",
                @"fullTitle": @"PreferredMaxLayoutWidth",
                @"patch": @(YES)
            },
            LookinAttr_NSTextField_MaximumNumberOfLines_MaximumNumberOfLines: @{
                @"className": @"NSTextField",
                @"fullTitle": @"MaximumNumberOfLines",
                @"patch": @(YES)
            },
            LookinAttr_NSTextField_AllowsDefaultTighteningForTruncation_AllowsDefaultTighteningForTruncation: @{
                @"className": @"NSTextField",
                @"fullTitle": @"AllowsDefaultTighteningForTruncation",
                @"patch": @(YES)
            },
            LookinAttr_NSTextField_LineBreakStrategy_LineBreakStrategy: @{
                @"className": @"NSTextField",
                @"fullTitle": @"LineBreakStrategy",
                @"enumList": @"NSLineBreakStrategy",
                @"patch": @(YES)
            },
            LookinAttr_NSTextField_Placeholder_Placeholder: @{
                @"className": @"NSTextField",
                @"fullTitle": @"Placeholder",
                @"typeIfObj": @(LookinAttrTypeNSString),
                @"patch": @(YES)
            },
            LookinAttr_NSTextField_TextColor_Color: @{
                @"className": @"NSTextField",
                @"fullTitle": @"TextColor",
                @"typeIfObj": @(LookinAttrTypeUIColor),
                @"patch": @(YES)
            },
            LookinAttr_NSVisualEffectView_Material_Material: @{
                @"className": @"NSVisualEffectView",
                @"fullTitle": @"Material",
                @"enumList": @"NSVisualEffectMaterial",
                @"patch": @(YES)
            },
            LookinAttr_NSVisualEffectView_InteriorBackgroundStyle_InteriorBackgroundStyle: @{
                @"className": @"NSVisualEffectView",
                @"fullTitle": @"InteriorBackgroundStyle",
                @"enumList": @"NSBackgroundStyle",
                @"patch": @(YES)
            },
            LookinAttr_NSVisualEffectView_BlendingMode_BlendingMode: @{
                @"className": @"NSVisualEffectView",
                @"fullTitle": @"BlendingMode",
                @"enumList": @"NSVisualEffectBlendingMode",
                @"patch": @(YES)
            },
            LookinAttr_NSVisualEffectView_State_State: @{
                @"className": @"NSVisualEffectView",
                @"fullTitle": @"State",
                @"enumList": @"NSVisualEffectState",
                @"patch": @(YES)
            },
            LookinAttr_NSVisualEffectView_Emphasized_Emphasized: @{
                @"className": @"NSVisualEffectView",
                @"fullTitle": @"Emphasized",
                @"getterString": @"isEmphasized",
                @"patch": @(YES)
            },
            LookinAttr_NSStackView_Orientation_Orientation: @{
                @"className": @"NSStackView",
                @"fullTitle": @"Orientation",
                @"enumList": @"NSUserInterfaceLayoutOrientation",
                @"patch": @(YES)
            },
            LookinAttr_NSStackView_EdgeInsets_EdgeInsets: @{
                @"className": @"NSStackView",
                @"fullTitle": @"EdgeInsets",
                @"patch": @(YES)
            },
            LookinAttr_NSStackView_DetachesHiddenViews_DetachesHiddenViews: @{
                @"className": @"NSStackView",
                @"fullTitle": @"DetachesHiddenViews",
                @"patch": @(YES)
            },
            LookinAttr_NSStackView_Distribution_Distribution: @{
                @"className": @"NSStackView",
                @"fullTitle": @"Distribution",
                @"enumList": @"NSStackViewDistribution",
                @"patch": @(YES)
            },
            LookinAttr_NSStackView_Alignment_Alignment: @{
                @"className": @"NSStackView",
                @"fullTitle": @"Alignment",
                @"enumList": @"NSLayoutAttribute",
                @"patch": @(YES)
            },
            LookinAttr_NSStackView_Spacing_Spacing: @{
                @"className": @"NSStackView",
                @"fullTitle": @"Spacing",
                @"patch": @(YES)
            },
        };
    });
    
    NSDictionary<NSString *, id> *targetInfo = dict[attrID];
    return targetInfo;
}

+ (LookinAttrType)objectAttrTypeWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSNumber *typeIfObj = attrInfo[@"typeIfObj"];
    return [typeIfObj integerValue];
}

+ (NSString *)classNameWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSString *className = attrInfo[@"className"];
    
    NSAssert(className.length > 0, @"");
    
    return className;
}

+ (BOOL)isWindowPropertyWithAttrID:(LookinAttrIdentifier)attrID {
    NSString *className = [self classNameWithAttrID:attrID];
    if ([className isEqualToString:@"UIWindowScene"]) {
        return YES;
    }
    
    if ([className isEqualToString:@"NSWindow"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isUIViewPropertyWithAttrID:(LookinAttrIdentifier)attrID {
    NSString *className = [self classNameWithAttrID:attrID];
    
    if ([className isEqualToString:@"CALayer"]) {
        return NO;
    }
    
    if ([className isEqualToString:@"UIWindowScene"]) {
        return NO;
    }
    
    if ([className isEqualToString:@"NSWindow"]) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)enumListNameWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSString *name = attrInfo[@"enumList"];
    return name;
}

+ (BOOL)needPatchAfterModificationWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSNumber *needPatch = attrInfo[@"patch"];
    return [needPatch boolValue];
}

+ (NSString *)fullTitleWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSString *fullTitle = attrInfo[@"fullTitle"];
    return fullTitle;
}

+ (NSString *)briefTitleWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSString *briefTitle = attrInfo[@"briefTitle"];
    if (!briefTitle) {
        briefTitle = attrInfo[@"fullTitle"];
    }
    return briefTitle;
}

+ (SEL)getterWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSString *getterString = attrInfo[@"getterString"];
    if (getterString && getterString.length == 0) {
        // 空字符串，比如 image_open_open
        return nil;
    }
    if (!getterString) {
        NSString *fullTitle = attrInfo[@"fullTitle"];
        NSAssert(fullTitle.length > 0, @"");
        
        getterString = [NSString stringWithFormat:@"%@%@", [fullTitle substringToIndex:1].lowercaseString, [fullTitle substringFromIndex:1]].copy;
    }
    return NSSelectorFromString(getterString);
}

+ (SEL)setterWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSString *setterString = attrInfo[@"setterString"];
    if ([setterString isEqualToString:@""]) {
        // 该属性不可在 Lookin 客户端中被修改
        return nil;
    }
    if (!setterString) {
        NSString *fullTitle = attrInfo[@"fullTitle"];
        NSAssert(fullTitle.length > 0, @"");
        
        setterString = [NSString stringWithFormat:@"set%@%@:", [fullTitle substringToIndex:1].uppercaseString, [fullTitle substringFromIndex:1]];
    }
    return NSSelectorFromString(setterString);
}

+ (BOOL)hideIfNilWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSNumber *boolValue = attrInfo[@"hideIfNil"];
    return boolValue.boolValue;
}

+ (NSInteger)minAvailableOSVersionWithAttrID:(LookinAttrIdentifier)attrID {
    NSDictionary<NSString *, id> *attrInfo = [self _infoForAttrID:attrID];
    NSNumber *minVerNum = attrInfo[@"osVersion"];
    NSInteger minVer = [minVerNum integerValue];
    return minVer;
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
