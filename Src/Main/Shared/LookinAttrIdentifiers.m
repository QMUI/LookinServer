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

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
