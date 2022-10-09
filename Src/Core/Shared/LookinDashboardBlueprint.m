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
                  LookinAttrGroup_UIVisualEffectView,
                  LookinAttrGroup_UIImageView,
                  LookinAttrGroup_UILabel,
                  LookinAttrGroup_UIControl,
                  LookinAttrGroup_UIButton,
                  LookinAttrGroup_UIScrollView,
                  LookinAttrGroup_UITableView,
                  LookinAttrGroup_UITextView,
                  LookinAttrGroup_UITextField
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
                         LookinAttrSec_ViewLayer_ContentMode,
                         LookinAttrSec_ViewLayer_TintColor,
                         LookinAttrSec_ViewLayer_Tag
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
                 
                 LookinAttrSec_ViewLayer_InterationAndMasks: @[LookinAttr_ViewLayer_InterationAndMasks_Interaction,
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
                 
                 LookinAttrSec_ViewLayer_ContentMode: @[LookinAttr_ViewLayer_ContentMode_Mode],
                 
                 LookinAttrSec_ViewLayer_TintColor: @[LookinAttr_ViewLayer_TintColor_Color,
                                                      LookinAttr_ViewLayer_TintColor_Mode],
                 
                 LookinAttrSec_ViewLayer_Tag: @[LookinAttr_ViewLayer_Tag_Tag],
                 
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
                    LookinAttrGroup_UIVisualEffectView: @"UIVisualEffectView"
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
                    LookinAttrSec_ViewLayer_ContentMode: @"ContentMode",
                    LookinAttrSec_ViewLayer_TintColor: @"TintColor",
                    LookinAttrSec_ViewLayer_Tag: @"Tag",
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
 
 osVersion: 该属性需要的最低的 iOS 版本，比如 safeAreaInsets 从 iOS 11.0 开始出现，则该属性应该为 @11，如果为 nil 则表示不限制 iOS 版本（注意 Lookin 项目仅支持 iOS 8.0+）
 
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
                 LookinAttr_ViewLayer_InterationAndMasks_Interaction: @{
                         @"className": @"UIView",
                         @"fullTitle": @"UserInteractionEnabled",
                         @"getterString": @"isUserInteractionEnabled",
                         @"patch": @(NO)
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

+ (BOOL)isUIViewPropertyWithAttrID:(LookinAttrIdentifier)attrID {
    NSString *className = [self classNameWithAttrID:attrID];
    
    if ([className isEqualToString:@"CALayer"]) {
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
