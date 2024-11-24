#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAttrIdentifiers.m
//  Lookin
//
//  Created by Li Kai on 2019/9/18.
//  https://lookin.work
//



#import "LookinAttrIdentifiers.h"

// value 不能重复（AppDelegate 里的 runTests 有相关 test）
// 如果要去掉某一项可以考虑注释掉而非直接删除，以防止新项和旧项的 value 相同而引发 preference 错乱（这些 value 会被存储到 userDefaults 里）

#pragma mark - Group

LookinAttrGroupIdentifier const LookinAttrGroup_None = @"n";
LookinAttrGroupIdentifier const LookinAttrGroup_Class = @"c";
LookinAttrGroupIdentifier const LookinAttrGroup_Relation = @"r";
LookinAttrGroupIdentifier const LookinAttrGroup_Layout = @"l";
LookinAttrGroupIdentifier const LookinAttrGroup_AutoLayout = @"a";
LookinAttrGroupIdentifier const LookinAttrGroup_ViewLayer = @"vl";

LookinAttrGroupIdentifier const LookinAttrGroup_UIImageView = @"i";
LookinAttrGroupIdentifier const LookinAttrGroup_UILabel = @"la";
LookinAttrGroupIdentifier const LookinAttrGroup_UIControl = @"co";
LookinAttrGroupIdentifier const LookinAttrGroup_UIButton = @"b";
LookinAttrGroupIdentifier const LookinAttrGroup_UIScrollView = @"s";
LookinAttrGroupIdentifier const LookinAttrGroup_UITableView = @"ta";
LookinAttrGroupIdentifier const LookinAttrGroup_UITextView = @"te";
LookinAttrGroupIdentifier const LookinAttrGroup_UITextField = @"tf";
LookinAttrGroupIdentifier const LookinAttrGroup_UIVisualEffectView = @"ve";
LookinAttrGroupIdentifier const LookinAttrGroup_UIStackView = @"UIStackView";



LookinAttrGroupIdentifier const LookinAttrGroup_NSImageView = @"NSImageView";
LookinAttrGroupIdentifier const LookinAttrGroup_NSControl = @"NSControl";
LookinAttrGroupIdentifier const LookinAttrGroup_NSButton = @"NSButton";
LookinAttrGroupIdentifier const LookinAttrGroup_NSScrollView = @"NSScrollView";
LookinAttrGroupIdentifier const LookinAttrGroup_NSTableView = @"NSTableView";
LookinAttrGroupIdentifier const LookinAttrGroup_NSTextView = @"NSTextView";
LookinAttrGroupIdentifier const LookinAttrGroup_NSTextField = @"NSTextField";
LookinAttrGroupIdentifier const LookinAttrGroup_NSVisualEffectView = @"NSVisualEffectView";
LookinAttrGroupIdentifier const LookinAttrGroup_NSStackView = @"NSStackView";


LookinAttrGroupIdentifier const LookinAttrGroup_UserCustom = @"guc"; // user custom

#pragma mark - Section

LookinAttrSectionIdentifier const LookinAttrSec_None = @"n";

LookinAttrSectionIdentifier const LookinAttrSec_UserCustom = @"sec_ctm";

LookinAttrSectionIdentifier const LookinAttrSec_Class_Class = @"cl_c";

LookinAttrSectionIdentifier const LookinAttrSec_Relation_Relation = @"r_r";

LookinAttrSectionIdentifier const LookinAttrSec_Layout_Frame = @"l_f";
LookinAttrSectionIdentifier const LookinAttrSec_Layout_Bounds = @"l_b";
LookinAttrSectionIdentifier const LookinAttrSec_Layout_SafeArea = @"l_s";
LookinAttrSectionIdentifier const LookinAttrSec_Layout_Position = @"l_p";
LookinAttrSectionIdentifier const LookinAttrSec_Layout_AnchorPoint = @"l_a";

LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_Hugging = @"a_h";
LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_Resistance = @"a_r";
LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_Constraints = @"a_c";
LookinAttrSectionIdentifier const LookinAttrSec_AutoLayout_IntrinsicSize = @"a_i";

LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Visibility = @"v_v";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_InterationAndMasks = @"v_i";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Corner = @"v_c";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_BgColor = @"v_b";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Border = @"v_bo";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Shadow = @"v_s";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_ContentMode = @"v_co";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_TintColor = @"v_t";
LookinAttrSectionIdentifier const LookinAttrSec_ViewLayer_Tag = @"v_ta";



LookinAttrSectionIdentifier const LookinAttrSec_UIImageView_Name = @"i_n";
LookinAttrSectionIdentifier const LookinAttrSec_UIImageView_Open = @"i_o";

LookinAttrSectionIdentifier const LookinAttrSec_UILabel_Text = @"lb_t";
LookinAttrSectionIdentifier const LookinAttrSec_UILabel_Font = @"lb_f";
LookinAttrSectionIdentifier const LookinAttrSec_UILabel_NumberOfLines = @"lb_n";
LookinAttrSectionIdentifier const LookinAttrSec_UILabel_TextColor = @"lb_tc";
LookinAttrSectionIdentifier const LookinAttrSec_UILabel_BreakMode = @"lb_b";
LookinAttrSectionIdentifier const LookinAttrSec_UILabel_Alignment = @"lb_a";
LookinAttrSectionIdentifier const LookinAttrSec_UILabel_CanAdjustFont = @"lb_c";

LookinAttrSectionIdentifier const LookinAttrSec_UIControl_EnabledSelected = @"c_e";
LookinAttrSectionIdentifier const LookinAttrSec_UIControl_VerAlignment = @"c_v";
LookinAttrSectionIdentifier const LookinAttrSec_UIControl_HorAlignment = @"c_h";
LookinAttrSectionIdentifier const LookinAttrSec_UIControl_QMUIOutsideEdge = @"c_o";

LookinAttrSectionIdentifier const LookinAttrSec_UIButton_ContentInsets = @"b_c";
LookinAttrSectionIdentifier const LookinAttrSec_UIButton_TitleInsets = @"b_t";
LookinAttrSectionIdentifier const LookinAttrSec_UIButton_ImageInsets = @"b_i";

LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ContentInset = @"s_c";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_AdjustedInset = @"s_a";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_IndicatorInset = @"s_i";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Offset = @"s_o";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ContentSize = @"s_cs";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Behavior = @"s_b";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ShowsIndicator = @"s_si";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Bounce = @"s_bo";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ScrollPaging = @"s_s";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_ContentTouches = @"s_ct";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_Zoom = @"s_z";
LookinAttrSectionIdentifier const LookinAttrSec_UIScrollView_QMUIInitialInset = @"s_ii";

LookinAttrSectionIdentifier const LookinAttrSec_UITableView_Style = @"t_s";
LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SectionsNumber = @"t_sn";
LookinAttrSectionIdentifier const LookinAttrSec_UITableView_RowsNumber = @"t_r";
LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SeparatorStyle = @"t_ss";
LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SeparatorColor = @"t_sc";
LookinAttrSectionIdentifier const LookinAttrSec_UITableView_SeparatorInset = @"t_si";

LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Basic = @"tv_b";
LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Text = @"tv_t";
LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Font = @"tv_f";
LookinAttrSectionIdentifier const LookinAttrSec_UITextView_TextColor = @"tv_tc";
LookinAttrSectionIdentifier const LookinAttrSec_UITextView_Alignment = @"tv_a";
LookinAttrSectionIdentifier const LookinAttrSec_UITextView_ContainerInset = @"tv_c";

LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Text = @"tf_t";
LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Placeholder = @"tf_p";
LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Font = @"tf_f";
LookinAttrSectionIdentifier const LookinAttrSec_UITextField_TextColor = @"tf_tc";
LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Alignment = @"tf_a";
LookinAttrSectionIdentifier const LookinAttrSec_UITextField_Clears = @"tf_c";
LookinAttrSectionIdentifier const LookinAttrSec_UITextField_CanAdjustFont = @"tf_ca";
LookinAttrSectionIdentifier const LookinAttrSec_UITextField_ClearButtonMode = @"tf_cb";

LookinAttrSectionIdentifier const LookinAttrSec_UIVisualEffectView_Style = @"ve_s";
LookinAttrSectionIdentifier const LookinAttrSec_UIVisualEffectView_QMUIForegroundColor = @"ve_f";

LookinAttrSectionIdentifier const LookinAttrSec_UIStackView_Axis = @"usv_axis";
LookinAttrSectionIdentifier const LookinAttrSec_UIStackView_Distribution = @"usv_dis";
LookinAttrSectionIdentifier const LookinAttrSec_UIStackView_Alignment = @"usv_align";
LookinAttrSectionIdentifier const LookinAttrSec_UIStackView_Spacing = @"usv_spa";

LookinAttrSectionIdentifier const LookinAttrSec_NSImageView_Name = @"NSImageView_Name";
LookinAttrSectionIdentifier const LookinAttrSec_NSImageView_Open = @"NSImageView_Open";
LookinAttrSectionIdentifier const LookinAttrSec_NSControl_State = @"NSControl_State";
LookinAttrSectionIdentifier const LookinAttrSec_NSControl_ControlSize = @"NSControl_ControlSize";
LookinAttrSectionIdentifier const LookinAttrSec_NSControl_Font = @"NSControl_Font";
LookinAttrSectionIdentifier const LookinAttrSec_NSControl_Alignment = @"NSControl_Alignment";
LookinAttrSectionIdentifier const LookinAttrSec_NSControl_Misc = @"NSControl_Misc";
LookinAttrSectionIdentifier const LookinAttrSec_NSControl_Value = @"NSControl_Value";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_ButtonType = @"NSButton_ButtonType";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_Title = @"NSButton_Title";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_BezelStyle = @"NSButton_BezelStyle";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_Bordered = @"NSButton_Bordered";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_Transparent = @"NSButton_Transparent";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_BezelColor = @"NSButton_BezelColor";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_ContentTintColor = @"NSButton_ContentTintColor";
LookinAttrSectionIdentifier const LookinAttrSec_NSButton_Misc = @"NSButton_Misc";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_ContentOffset = @"NSScrollView_ContentOffset";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_ContentSize = @"NSScrollView_ContentSize";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_ContentInset = @"NSScrollView_ContentInset";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_BorderType = @"NSScrollView_BorderType";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_Scroller = @"NSScrollView_Scroller";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_Ruler = @"NSScrollView_Ruler";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_LineScroll = @"NSScrollView_LineScroll";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_PageScroll = @"NSScrollView_PageScroll";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_ScrollElasiticity = @"NSScrollView_ScrollElasiticity";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_Misc = @"NSScrollView_Misc";
LookinAttrSectionIdentifier const LookinAttrSec_NSScrollView_Magnification = @"NSScrollView_Magnification";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_RowHeight = @"NSTableView_RowHeight";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_AutomaticRowHeights = @"NSTableView_AutomaticRowHeights";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_IntercellSpacing = @"NSTableView_IntercellSpacing";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_Style = @"NSTableView_Style";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_ColumnAutoresizingStyle = @"NSTableView_ColumnAutoresizingStyle";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_GridStyleMask = @"NSTableView_GridStyleMask";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_SelectionHighlightStyle = @"NSTableView_SelectionHighlightStyle";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_GridColor = @"NSTableView_GridColor";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_RowSizeStyle = @"NSTableView_RowSizeStyle";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_NumberOfRows = @"NSTableView_NumberOfRows";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_NumberOfColumns = @"NSTableView_NumberOfColumns";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_UseAlternatingRowBackgroundColors = @"NSTableView_UseAlternatingRowBackgroundColors";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_AllowsColumnReordering = @"NSTableView_AllowsColumnReordering";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_AllowsColumnResizing = @"NSTableView_AllowsColumnResizing";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_AllowsMultipleSelection = @"NSTableView_AllowsMultipleSelection";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_AllowsEmptySelection = @"NSTableView_AllowsEmptySelection";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_AllowsColumnSelection = @"NSTableView_AllowsColumnSelection";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_AllowsTypeSelect = @"NSTableView_AllowsTypeSelect";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_DraggingDestinationFeedbackStyle = @"NSTableView_DraggingDestinationFeedbackStyle";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_Autosave = @"NSTableView_Autosave";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_FloatsGroupRows = @"NSTableView_FloatsGroupRows";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_RowActionsVisible = @"NSTableView_RowActionsVisible";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_UsesStaticContents = @"NSTableView_UsesStaticContents";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_UserInterfaceLayoutDirection = @"NSTableView_UserInterfaceLayoutDirection";
LookinAttrSectionIdentifier const LookinAttrSec_NSTableView_VerticalMotionCanBeginDrag = @"NSTableView_VerticalMotionCanBeginDrag";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_Font = @"NSTextView_Font";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_Basic = @"NSTextView_Basic";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_String = @"NSTextView_String";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_TextColor = @"NSTextView_TextColor";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_Alignment = @"NSTextView_Alignment";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_ContainerInset = @"NSTextView_ContainerInset";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_BaseWritingDirection = @"NSTextView_BaseWritingDirection";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_Size = @"NSTextView_Size";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextView_Resizable = @"NSTextView_Resizable";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_Bordered = @"NSTextField_Bordered";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_Bezeled = @"NSTextField_Bezeled";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_BezelStyle = @"NSTextField_BezelStyle";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_Editable = @"NSTextField_Editable";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_Selectable = @"NSTextField_Selectable";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_DrawsBackground = @"NSTextField_DrawsBackground";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_PreferredMaxLayoutWidth = @"NSTextField_PreferredMaxLayoutWidth";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_MaximumNumberOfLines = @"NSTextField_MaximumNumberOfLines";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_AllowsDefaultTighteningForTruncation = @"NSTextField_AllowsDefaultTighteningForTruncation";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_LineBreakStrategy = @"NSTextField_LineBreakStrategy";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_Placeholder = @"NSTextField_Placeholder";
LookinAttrSectionIdentifier const LookinAttrSec_NSTextField_TextColor = @"NSTextField_TextColor";
LookinAttrSectionIdentifier const LookinAttrSec_NSVisualEffectView_Material = @"NSVisualEffectView_Material";
LookinAttrSectionIdentifier const LookinAttrSec_NSVisualEffectView_InteriorBackgroundStyle = @"NSVisualEffectView_InteriorBackgroundStyle";
LookinAttrSectionIdentifier const LookinAttrSec_NSVisualEffectView_BlendingMode = @"NSVisualEffectView_BlendingMode";
LookinAttrSectionIdentifier const LookinAttrSec_NSVisualEffectView_State = @"NSVisualEffectView_State";
LookinAttrSectionIdentifier const LookinAttrSec_NSVisualEffectView_Emphasized = @"NSVisualEffectView_Emphasized";
LookinAttrSectionIdentifier const LookinAttrSec_NSStackView_Orientation = @"NSStackView_Orientation";
LookinAttrSectionIdentifier const LookinAttrSec_NSStackView_EdgeInsets = @"NSStackView_EdgeInsets";
LookinAttrSectionIdentifier const LookinAttrSec_NSStackView_DetachesHiddenViews = @"NSStackView_DetachesHiddenViews";
LookinAttrSectionIdentifier const LookinAttrSec_NSStackView_Distribution = @"NSStackView_Distribution";
LookinAttrSectionIdentifier const LookinAttrSec_NSStackView_Alignment = @"NSStackView_Alignment";
LookinAttrSectionIdentifier const LookinAttrSec_NSStackView_Spacing = @"NSStackView_Spacing";

#pragma mark - Attr

LookinAttrIdentifier const LookinAttr_None = @"n";
LookinAttrIdentifier const LookinAttr_UserCustom = @"ctm";

LookinAttrIdentifier const LookinAttr_Class_Class_Class = @"c_c_c";


LookinAttrIdentifier const LookinAttr_Relation_Relation_Relation = @"r_r_r";

LookinAttrIdentifier const LookinAttr_Layout_Frame_Frame = @"l_f_f";
LookinAttrIdentifier const LookinAttr_Layout_Bounds_Bounds = @"l_b_b";
LookinAttrIdentifier const LookinAttr_Layout_SafeArea_SafeArea = @"l_s_s";
LookinAttrIdentifier const LookinAttr_Layout_Position_Position = @"l_p_p";
LookinAttrIdentifier const LookinAttr_Layout_AnchorPoint_AnchorPoint = @"l_a_a";

LookinAttrIdentifier const LookinAttr_AutoLayout_Hugging_Hor = @"al_h_h";
LookinAttrIdentifier const LookinAttr_AutoLayout_Hugging_Ver = @"al_h_v";
LookinAttrIdentifier const LookinAttr_AutoLayout_Resistance_Hor = @"al_r_h";
LookinAttrIdentifier const LookinAttr_AutoLayout_Resistance_Ver = @"al_r_v";
LookinAttrIdentifier const LookinAttr_AutoLayout_Constraints_Constraints = @"al_c_c";
LookinAttrIdentifier const LookinAttr_AutoLayout_IntrinsicSize_Size = @"cl_i_s";

LookinAttrIdentifier const LookinAttr_ViewLayer_Visibility_Hidden = @"vl_v_h";
LookinAttrIdentifier const LookinAttr_ViewLayer_Visibility_Opacity = @"vl_v_o";
LookinAttrIdentifier const LookinAttr_ViewLayer_InterationAndMasks_Interaction = @"vl_i_i";
LookinAttrIdentifier const LookinAttr_ViewLayer_InterationAndMasks_MasksToBounds = @"vl_i_m";
LookinAttrIdentifier const LookinAttr_ViewLayer_Corner_Radius = @"vl_c_r";
LookinAttrIdentifier const LookinAttr_ViewLayer_BgColor_BgColor = @"vl_b_b";
LookinAttrIdentifier const LookinAttr_ViewLayer_Border_Color = @"vl_b_c";
LookinAttrIdentifier const LookinAttr_ViewLayer_Border_Width = @"vl_b_w";
LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_Color = @"vl_s_c";
LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_Opacity = @"vl_s_o";
LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_Radius = @"vl_s_r";
LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_OffsetW = @"vl_s_ow";
LookinAttrIdentifier const LookinAttr_ViewLayer_Shadow_OffsetH = @"vl_s_oh";
LookinAttrIdentifier const LookinAttr_ViewLayer_ContentMode_Mode = @"vl_c_m";
LookinAttrIdentifier const LookinAttr_ViewLayer_TintColor_Color = @"vl_t_c";
LookinAttrIdentifier const LookinAttr_ViewLayer_TintColor_Mode = @"vl_t_m";
LookinAttrIdentifier const LookinAttr_ViewLayer_Tag_Tag = @"vl_t_t";

LookinAttrIdentifier const LookinAttr_UIImageView_Name_Name = @"iv_n_n";
LookinAttrIdentifier const LookinAttr_UIImageView_Open_Open = @"iv_o_o";

LookinAttrIdentifier const LookinAttr_UILabel_Text_Text = @"lb_t_t";
LookinAttrIdentifier const LookinAttr_UILabel_Font_Name = @"lb_f_n";
LookinAttrIdentifier const LookinAttr_UILabel_Font_Size = @"lb_f_s";
LookinAttrIdentifier const LookinAttr_UILabel_NumberOfLines_NumberOfLines = @"lb_n_n";
LookinAttrIdentifier const LookinAttr_UILabel_TextColor_Color = @"lb_t_c";
LookinAttrIdentifier const LookinAttr_UILabel_Alignment_Alignment = @"lb_a_a";
LookinAttrIdentifier const LookinAttr_UILabel_BreakMode_Mode = @"lb_b_m";
LookinAttrIdentifier const LookinAttr_UILabel_CanAdjustFont_CanAdjustFont = @"lb_c_c";

LookinAttrIdentifier const LookinAttr_UIControl_EnabledSelected_Enabled = @"ct_e_e";
LookinAttrIdentifier const LookinAttr_UIControl_EnabledSelected_Selected = @"ct_e_s";
LookinAttrIdentifier const LookinAttr_UIControl_VerAlignment_Alignment = @"ct_v_a";
LookinAttrIdentifier const LookinAttr_UIControl_HorAlignment_Alignment = @"ct_h_a";
LookinAttrIdentifier const LookinAttr_UIControl_QMUIOutsideEdge_Edge = @"ct_o_e";

LookinAttrIdentifier const LookinAttr_UIButton_ContentInsets_Insets = @"bt_c_i";
LookinAttrIdentifier const LookinAttr_UIButton_TitleInsets_Insets = @"bt_t_i";
LookinAttrIdentifier const LookinAttr_UIButton_ImageInsets_Insets = @"bt_i_i";

LookinAttrIdentifier const LookinAttr_UIScrollView_Offset_Offset = @"sv_o_o";
LookinAttrIdentifier const LookinAttr_UIScrollView_ContentSize_Size = @"sv_c_s";
LookinAttrIdentifier const LookinAttr_UIScrollView_ContentInset_Inset = @"sv_c_i";
LookinAttrIdentifier const LookinAttr_UIScrollView_AdjustedInset_Inset = @"sv_a_i";
LookinAttrIdentifier const LookinAttr_UIScrollView_Behavior_Behavior = @"sv_b_b";
LookinAttrIdentifier const LookinAttr_UIScrollView_IndicatorInset_Inset = @"sv_i_i";
LookinAttrIdentifier const LookinAttr_UIScrollView_ScrollPaging_ScrollEnabled = @"sv_s_s";
LookinAttrIdentifier const LookinAttr_UIScrollView_ScrollPaging_PagingEnabled = @"sv_s_p";
LookinAttrIdentifier const LookinAttr_UIScrollView_Bounce_Ver = @"sv_b_v";
LookinAttrIdentifier const LookinAttr_UIScrollView_Bounce_Hor = @"sv_b_h";
LookinAttrIdentifier const LookinAttr_UIScrollView_ShowsIndicator_Hor = @"sv_h_h";
LookinAttrIdentifier const LookinAttr_UIScrollView_ShowsIndicator_Ver = @"sv_s_v";
LookinAttrIdentifier const LookinAttr_UIScrollView_ContentTouches_Delay = @"sv_c_d";
LookinAttrIdentifier const LookinAttr_UIScrollView_ContentTouches_CanCancel = @"sv_c_c";
LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_MinScale = @"sv_z_mi";
LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_MaxScale = @"sv_z_ma";
LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_Scale = @"sv_z_s";
LookinAttrIdentifier const LookinAttr_UIScrollView_Zoom_Bounce = @"sv_z_b";
LookinAttrIdentifier const LookinAttr_UIScrollView_QMUIInitialInset_Inset = @"sv_qi_i";

LookinAttrIdentifier const LookinAttr_UITableView_Style_Style = @"tv_s_s";
LookinAttrIdentifier const LookinAttr_UITableView_SectionsNumber_Number = @"tv_s_n";
LookinAttrIdentifier const LookinAttr_UITableView_RowsNumber_Number = @"tv_r_n";
LookinAttrIdentifier const LookinAttr_UITableView_SeparatorInset_Inset = @"tv_s_i";
LookinAttrIdentifier const LookinAttr_UITableView_SeparatorColor_Color = @"tv_s_c";
LookinAttrIdentifier const LookinAttr_UITableView_SeparatorStyle_Style = @"tv_ss_s";

LookinAttrIdentifier const LookinAttr_UITextView_Font_Name = @"te_f_n";
LookinAttrIdentifier const LookinAttr_UITextView_Font_Size = @"te_f_s";
LookinAttrIdentifier const LookinAttr_UITextView_Basic_Editable = @"te_b_e";
LookinAttrIdentifier const LookinAttr_UITextView_Basic_Selectable = @"te_b_s";
LookinAttrIdentifier const LookinAttr_UITextView_Text_Text = @"te_t_t";
LookinAttrIdentifier const LookinAttr_UITextView_TextColor_Color = @"te_t_c";
LookinAttrIdentifier const LookinAttr_UITextView_Alignment_Alignment = @"te_a_a";
LookinAttrIdentifier const LookinAttr_UITextView_ContainerInset_Inset = @"te_c_i";

LookinAttrIdentifier const LookinAttr_UITextField_Text_Text = @"tf_t_t";
LookinAttrIdentifier const LookinAttr_UITextField_Placeholder_Placeholder = @"tf_p_p";
LookinAttrIdentifier const LookinAttr_UITextField_Font_Name = @"tf_f_n";
LookinAttrIdentifier const LookinAttr_UITextField_Font_Size = @"tf_f_s";
LookinAttrIdentifier const LookinAttr_UITextField_TextColor_Color = @"tf_t_c";
LookinAttrIdentifier const LookinAttr_UITextField_Alignment_Alignment = @"tf_a_a";
LookinAttrIdentifier const LookinAttr_UITextField_Clears_ClearsOnBeginEditing = @"tf_c_c";
LookinAttrIdentifier const LookinAttr_UITextField_Clears_ClearsOnInsertion = @"tf_c_co";
LookinAttrIdentifier const LookinAttr_UITextField_CanAdjustFont_CanAdjustFont = @"tf_c_ca";
LookinAttrIdentifier const LookinAttr_UITextField_CanAdjustFont_MinSize = @"tf_c_m";
LookinAttrIdentifier const LookinAttr_UITextField_ClearButtonMode_Mode = @"tf_cb_m";

LookinAttrIdentifier const LookinAttr_UIVisualEffectView_Style_Style = @"ve_s_s";
LookinAttrIdentifier const LookinAttr_UIVisualEffectView_QMUIForegroundColor_Color = @"ve_f_c";

LookinAttrIdentifier const LookinAttr_UIStackView_Axis_Axis = @"usv_axis_axis";
LookinAttrIdentifier const LookinAttr_UIStackView_Distribution_Distribution = @"usv_dis_dis";
LookinAttrIdentifier const LookinAttr_UIStackView_Alignment_Alignment = @"usv_ali_ali";
LookinAttrIdentifier const LookinAttr_UIStackView_Spacing_Spacing = @"usv_spa_spa";

LookinAttrIdentifier const LookinAttr_NSImageView_Name_Name = @"NSImageView_Name_Name";
LookinAttrIdentifier const LookinAttr_NSImageView_Open_Open = @"NSImageView_Open_Open";
LookinAttrIdentifier const LookinAttr_NSControl_State_Enabled = @"NSControl_State_Enabled";
LookinAttrIdentifier const LookinAttr_NSControl_State_Highlighted = @"NSControl_State_Highlighted";
LookinAttrIdentifier const LookinAttr_NSControl_State_Continuous = @"NSControl_State_Continuous";
LookinAttrIdentifier const LookinAttr_NSControl_ControlSize_Size = @"NSControl_ControlSize_Size";
LookinAttrIdentifier const LookinAttr_NSControl_Font_Name = @"NSControl_Font_Name";
LookinAttrIdentifier const LookinAttr_NSControl_Font_Size = @"NSControl_Font_Size";
LookinAttrIdentifier const LookinAttr_NSControl_Alignment_Alignment = @"NSControl_Alignment_Alignment";
LookinAttrIdentifier const LookinAttr_NSControl_Misc_WritingDirection = @"NSControl_Misc_WritingDirection";
LookinAttrIdentifier const LookinAttr_NSControl_Misc_IgnoresMultiClick = @"NSControl_Misc_IgnoresMultiClick";
LookinAttrIdentifier const LookinAttr_NSControl_Misc_UsesSingleLineMode = @"NSControl_Misc_UsesSingleLineMode";
LookinAttrIdentifier const LookinAttr_NSControl_Misc_AllowsExpansionToolTips = @"NSControl_Misc_AllowsExpansionToolTips";
LookinAttrIdentifier const LookinAttr_NSControl_Value_StringValue = @"NSControl_Value_StringValue";
LookinAttrIdentifier const LookinAttr_NSControl_Value_IntValue = @"NSControl_Value_IntValue";
LookinAttrIdentifier const LookinAttr_NSControl_Value_IntegerValue = @"NSControl_Value_IntegerValue";
LookinAttrIdentifier const LookinAttr_NSControl_Value_FloatValue = @"NSControl_Value_FloatValue";
LookinAttrIdentifier const LookinAttr_NSControl_Value_DoubleValue = @"NSControl_Value_DoubleValue";
LookinAttrIdentifier const LookinAttr_NSButton_ButtonType_ButtonType = @"NSButton_ButtonType_ButtonType";
LookinAttrIdentifier const LookinAttr_NSButton_Title_Title = @"NSButton_Title_Title";
LookinAttrIdentifier const LookinAttr_NSButton_Title_AlernateTitle = @"NSButton_Title_AlernateTitle";
LookinAttrIdentifier const LookinAttr_NSButton_BezelStyle_BezelStyle = @"NSButton_BezelStyle_BezelStyle";
LookinAttrIdentifier const LookinAttr_NSButton_Bordered_Bordered = @"NSButton_Bordered_Bordered";
LookinAttrIdentifier const LookinAttr_NSButton_Transparent_Transparent = @"NSButton_Transparent_Transparent";
LookinAttrIdentifier const LookinAttr_NSButton_BezelColor_BezelColor = @"NSButton_BezelColor_BezelColor";
LookinAttrIdentifier const LookinAttr_NSButton_ContentTintColor_ContentTintColor = @"NSButton_ContentTintColor_ContentTintColor";
LookinAttrIdentifier const LookinAttr_NSButton_Misc_ShowsBorderOnlyWhileMouseInside = @"NSButton_Misc_ShowsBorderOnlyWhileMouseInside";
LookinAttrIdentifier const LookinAttr_NSButton_Misc_MaxAcceleratorLevel = @"NSButton_Misc_MaxAcceleratorLevel";
LookinAttrIdentifier const LookinAttr_NSButton_Misc_SpringLoaded = @"NSButton_Misc_SpringLoaded";
LookinAttrIdentifier const LookinAttr_NSButton_Misc_HasDestructiveAction = @"NSButton_Misc_HasDestructiveAction";
LookinAttrIdentifier const LookinAttr_NSScrollView_ContentOffset_Offset = @"NSScrollView_ContentOffset_Offset";
LookinAttrIdentifier const LookinAttr_NSScrollView_ContentSize_Size = @"NSScrollView_ContentSize_Size";
LookinAttrIdentifier const LookinAttr_NSScrollView_ContentInset_ContentInset = @"NSScrollView_ContentInset_ContentInset";
LookinAttrIdentifier const LookinAttr_NSScrollView_ContentInset_AutomaticallyAdjustsContentInsets = @"NSScrollView_ContentInset_AutomaticallyAdjustsContentInsets";
LookinAttrIdentifier const LookinAttr_NSScrollView_BorderType_BorderType = @"NSScrollView_BorderType_BorderType";
LookinAttrIdentifier const LookinAttr_NSScrollView_Scroller_Horizontal = @"NSScrollView_Scroller_Horizontal";
LookinAttrIdentifier const LookinAttr_NSScrollView_Scroller_Vertical = @"NSScrollView_Scroller_Vertical";
LookinAttrIdentifier const LookinAttr_NSScrollView_Scroller_AutohidesScrollers = @"NSScrollView_Scroller_AutohidesScrollers";
LookinAttrIdentifier const LookinAttr_NSScrollView_Scroller_ScrollerStyle = @"NSScrollView_Scroller_ScrollerStyle";
LookinAttrIdentifier const LookinAttr_NSScrollView_Scroller_ScrollerKnobStyle = @"NSScrollView_Scroller_ScrollerKnobStyle";
LookinAttrIdentifier const LookinAttr_NSScrollView_Scroller_ScrollerInsets = @"NSScrollView_Scroller_ScrollerInsets";
LookinAttrIdentifier const LookinAttr_NSScrollView_Ruler_Horizontal = @"NSScrollView_Ruler_Horizontal";
LookinAttrIdentifier const LookinAttr_NSScrollView_Ruler_Vertical = @"NSScrollView_Ruler_Vertical";
LookinAttrIdentifier const LookinAttr_NSScrollView_Ruler_Visible = @"NSScrollView_Ruler_Visible";
LookinAttrIdentifier const LookinAttr_NSScrollView_LineScroll_Horizontal = @"NSScrollView_LineScroll_Horizontal";
LookinAttrIdentifier const LookinAttr_NSScrollView_LineScroll_Vertical = @"NSScrollView_LineScroll_Vertical";
LookinAttrIdentifier const LookinAttr_NSScrollView_LineScroll_LineScroll = @"NSScrollView_LineScroll_LineScroll";
LookinAttrIdentifier const LookinAttr_NSScrollView_PageScroll_Horizontal = @"NSScrollView_PageScroll_Horizontal";
LookinAttrIdentifier const LookinAttr_NSScrollView_PageScroll_Vertical = @"NSScrollView_PageScroll_Vertical";
LookinAttrIdentifier const LookinAttr_NSScrollView_PageScroll_PageScroll = @"NSScrollView_PageScroll_PageScroll";
LookinAttrIdentifier const LookinAttr_NSScrollView_ScrollElasiticity_Horizontal = @"NSScrollView_ScrollElasiticity_Horizontal";
LookinAttrIdentifier const LookinAttr_NSScrollView_ScrollElasiticity_Vertical = @"NSScrollView_ScrollElasiticity_Vertical";
LookinAttrIdentifier const LookinAttr_NSScrollView_Misc_ScrollsDynamically = @"NSScrollView_Misc_ScrollsDynamically";
LookinAttrIdentifier const LookinAttr_NSScrollView_Misc_UsesPredominantAxisScrolling = @"NSScrollView_Misc_UsesPredominantAxisScrolling";
LookinAttrIdentifier const LookinAttr_NSScrollView_Magnification_AllowsMagnification = @"NSScrollView_Magnification_AllowsMagnification";
LookinAttrIdentifier const LookinAttr_NSScrollView_Magnification_Magnification = @"NSScrollView_Magnification_Magnification";
LookinAttrIdentifier const LookinAttr_NSScrollView_Magnification_Max = @"NSScrollView_Magnification_Max";
LookinAttrIdentifier const LookinAttr_NSScrollView_Magnification_Min = @"NSScrollView_Magnification_Min";
LookinAttrIdentifier const LookinAttr_NSTableView_AllowsColumnReordering_AllowsColumnReordering = @"NSTableView_AllowsColumnReordering_AllowsColumnReordering";
LookinAttrIdentifier const LookinAttr_NSTableView_AllowsColumnResizing_AllowsColumnResizing = @"NSTableView_AllowsColumnResizing_AllowsColumnResizing";
LookinAttrIdentifier const LookinAttr_NSTableView_ColumnAutoresizingStyle_ColumnAutoresizingStyle = @"NSTableView_ColumnAutoresizingStyle_ColumnAutoresizingStyle";
LookinAttrIdentifier const LookinAttr_NSTableView_GridStyleMask_GridStyleMask = @"NSTableView_GridStyleMask_GridStyleMask";
LookinAttrIdentifier const LookinAttr_NSTableView_IntercellSpacing_IntercellSpacing = @"NSTableView_IntercellSpacing_IntercellSpacing";
LookinAttrIdentifier const LookinAttr_NSTableView_UseAlternatingRowBackgroundColors_UseAlternatingRowBackgroundColors = @"NSTableView_UseAlternatingRowBackgroundColors_UseAlternatingRowBackgroundColors";
LookinAttrIdentifier const LookinAttr_NSTableView_GridColor_GridColor = @"NSTableView_GridColor_GridColor";
LookinAttrIdentifier const LookinAttr_NSTableView_RowSizeStyle_RowSizeStyle = @"NSTableView_RowSizeStyle_RowSizeStyle";
LookinAttrIdentifier const LookinAttr_NSTableView_RowHeight_RowHeight = @"NSTableView_RowHeight_RowHeight";
LookinAttrIdentifier const LookinAttr_NSTableView_NumberOfRows_NumberOfRows = @"NSTableView_NumberOfRows_NumberOfRows";
LookinAttrIdentifier const LookinAttr_NSTableView_NumberOfColumns_NumberOfColumns = @"NSTableView_NumberOfColumns_NumberOfColumns";
LookinAttrIdentifier const LookinAttr_NSTableView_VerticalMotionCanBeginDrag_VerticalMotionCanBeginDrag = @"NSTableView_VerticalMotionCanBeginDrag_VerticalMotionCanBeginDrag";
LookinAttrIdentifier const LookinAttr_NSTableView_AllowsMultipleSelection_AllowsMultipleSelection = @"NSTableView_AllowsMultipleSelection_AllowsMultipleSelection";
LookinAttrIdentifier const LookinAttr_NSTableView_AllowsEmptySelection_AllowsEmptySelection = @"NSTableView_AllowsEmptySelection_AllowsEmptySelection";
LookinAttrIdentifier const LookinAttr_NSTableView_AllowsColumnSelection_AllowsColumnSelection = @"NSTableView_AllowsColumnSelection_AllowsColumnSelection";
LookinAttrIdentifier const LookinAttr_NSTableView_AllowsTypeSelect_AllowsTypeSelect = @"NSTableView_AllowsTypeSelect_AllowsTypeSelect";
LookinAttrIdentifier const LookinAttr_NSTableView_SelectionHighlightStyle_SelectionHighlightStyle = @"NSTableView_SelectionHighlightStyle_SelectionHighlightStyle";
LookinAttrIdentifier const LookinAttr_NSTableView_DraggingDestinationFeedbackStyle_DraggingDestinationFeedbackStyle = @"NSTableView_DraggingDestinationFeedbackStyle_DraggingDestinationFeedbackStyle";
LookinAttrIdentifier const LookinAttr_NSTableView_AutomaticRowHeights_AutomaticRowHeights = @"NSTableView_AutomaticRowHeights_AutomaticRowHeights";
LookinAttrIdentifier const LookinAttr_NSTableView_AutosaveName_AutosaveName = @"NSTableView_AutosaveName_AutosaveName";
LookinAttrIdentifier const LookinAttr_NSTableView_AutosaveTableColumns_AutosaveTableColumns = @"NSTableView_AutosaveTableColumns_AutosaveTableColumns";
LookinAttrIdentifier const LookinAttr_NSTableView_FloatsGroupRows_FloatsGroupRows = @"NSTableView_FloatsGroupRows_FloatsGroupRows";
LookinAttrIdentifier const LookinAttr_NSTableView_RowActionsVisible_RowActionsVisible = @"NSTableView_RowActionsVisible_RowActionsVisible";
LookinAttrIdentifier const LookinAttr_NSTableView_UsesStaticContents_UsesStaticContents = @"NSTableView_UsesStaticContents_UsesStaticContents";
LookinAttrIdentifier const LookinAttr_NSTableView_UserInterfaceLayoutDirection_UserInterfaceLayoutDirection = @"NSTableView_UserInterfaceLayoutDirection_UserInterfaceLayoutDirection";
LookinAttrIdentifier const LookinAttr_NSTableView_Style_Style = @"NSTableView_Style_Style";
LookinAttrIdentifier const LookinAttr_NSTextView_Font_Name = @"NSTextView_Font_Name";
LookinAttrIdentifier const LookinAttr_NSTextView_Font_Size = @"NSTextView_Font_Size";
LookinAttrIdentifier const LookinAttr_NSTextView_Basic_Editable = @"NSTextView_Basic_Editable";
LookinAttrIdentifier const LookinAttr_NSTextView_Basic_Selectable = @"NSTextView_Basic_Selectable";
LookinAttrIdentifier const LookinAttr_NSTextView_Basic_RichText = @"NSTextView_Basic_RichText";
LookinAttrIdentifier const LookinAttr_NSTextView_Basic_FieldEditor = @"NSTextView_Basic_FieldEditor";
LookinAttrIdentifier const LookinAttr_NSTextView_Basic_ImportsGraphics = @"NSTextView_Basic_ImportsGraphics";
LookinAttrIdentifier const LookinAttr_NSTextView_String_String = @"NSTextView_String_String";
LookinAttrIdentifier const LookinAttr_NSTextView_TextColor_Color = @"NSTextView_TextColor_Color";
LookinAttrIdentifier const LookinAttr_NSTextView_Alignment_Alignment = @"NSTextView_Alignment_Alignment";
LookinAttrIdentifier const LookinAttr_NSTextView_ContainerInset_Inset = @"NSTextView_ContainerInset_Inset";
LookinAttrIdentifier const LookinAttr_NSTextView_BaseWritingDirection_BaseWritingDirection = @"NSTextView_BaseWritingDirection_BaseWritingDirection";
LookinAttrIdentifier const LookinAttr_NSTextView_MaxSize_MaxSize = @"NSTextView_MaxSize_MaxSize";
LookinAttrIdentifier const LookinAttr_NSTextView_MinSize_MinSize = @"NSTextView_MinSize_MinSize";
LookinAttrIdentifier const LookinAttr_NSTextView_Resizable_Horizontal = @"NSTextView_Resizable_Horizontal";
LookinAttrIdentifier const LookinAttr_NSTextView_Resizable_Vertical = @"NSTextView_Resizable_Vertical";
LookinAttrIdentifier const LookinAttr_NSTextField_Bordered_Bordered = @"NSTextField_Bordered_Bordered";
LookinAttrIdentifier const LookinAttr_NSTextField_Bezeled_Bezeled = @"NSTextField_Bezeled_Bezeled";
LookinAttrIdentifier const LookinAttr_NSTextField_Editable_Editable = @"NSTextField_Editable_Editable";
LookinAttrIdentifier const LookinAttr_NSTextField_Selectable_Selectable = @"NSTextField_Selectable_Selectable";
LookinAttrIdentifier const LookinAttr_NSTextField_DrawsBackground_DrawsBackground = @"NSTextField_DrawsBackground_DrawsBackground";
LookinAttrIdentifier const LookinAttr_NSTextField_BezelStyle_BezelStyle = @"NSTextField_BezelStyle_BezelStyle";
LookinAttrIdentifier const LookinAttr_NSTextField_PreferredMaxLayoutWidth_PreferredMaxLayoutWidth = @"NSTextField_PreferredMaxLayoutWidth_PreferredMaxLayoutWidth";
LookinAttrIdentifier const LookinAttr_NSTextField_MaximumNumberOfLines_MaximumNumberOfLines = @"NSTextField_MaximumNumberOfLines_MaximumNumberOfLines";
LookinAttrIdentifier const LookinAttr_NSTextField_AllowsDefaultTighteningForTruncation_AllowsDefaultTighteningForTruncation = @"NSTextField_AllowsDefaultTighteningForTruncation_AllowsDefaultTighteningForTruncation";
LookinAttrIdentifier const LookinAttr_NSTextField_LineBreakStrategy_LineBreakStrategy = @"NSTextField_LineBreakStrategy_LineBreakStrategy";
LookinAttrIdentifier const LookinAttr_NSTextField_Placeholder_Placeholder = @"NSTextField_Placeholder_Placeholder";
LookinAttrIdentifier const LookinAttr_NSTextField_TextColor_Color = @"NSTextField_TextColor_Color";
LookinAttrIdentifier const LookinAttr_NSVisualEffectView_Material_Material = @"NSVisualEffectView_Material_Material";
LookinAttrIdentifier const LookinAttr_NSVisualEffectView_InteriorBackgroundStyle_InteriorBackgroundStyle = @"NSVisualEffectView_InteriorBackgroundStyle_InteriorBackgroundStyle";
LookinAttrIdentifier const LookinAttr_NSVisualEffectView_BlendingMode_BlendingMode = @"NSVisualEffectView_BlendingMode_BlendingMode";
LookinAttrIdentifier const LookinAttr_NSVisualEffectView_State_State = @"NSVisualEffectView_State_State";
LookinAttrIdentifier const LookinAttr_NSVisualEffectView_Emphasized_Emphasized = @"NSVisualEffectView_Emphasized_Emphasized";
LookinAttrIdentifier const LookinAttr_NSStackView_Orientation_Orientation = @"NSStackView_Orientation_Orientation";
LookinAttrIdentifier const LookinAttr_NSStackView_EdgeInsets_EdgeInsets = @"NSStackView_EdgeInsets_EdgeInsets";
LookinAttrIdentifier const LookinAttr_NSStackView_DetachesHiddenViews_DetachesHiddenViews = @"NSStackView_DetachesHiddenViews_DetachesHiddenViews";
LookinAttrIdentifier const LookinAttr_NSStackView_Distribution_Distribution = @"NSStackView_Distribution_Distribution";
LookinAttrIdentifier const LookinAttr_NSStackView_Alignment_Alignment = @"NSStackView_Alignment_Alignment";
LookinAttrIdentifier const LookinAttr_NSStackView_Spacing_Spacing = @"NSStackView_Spacing_Spacing";


#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
