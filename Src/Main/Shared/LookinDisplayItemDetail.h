#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinDisplayItemDetail.h
//  Lookin
//
//  Created by Li Kai on 2019/2/19.
//  https://lookin.work
//

#import "LookinDefines.h"

@class LookinAttributesGroup;

@interface LookinDisplayItemDetail : NSObject <NSSecureCoding>

@property(nonatomic, assign) unsigned long displayItemOid;

@property(nonatomic, strong) LookinImage *groupScreenshot;

@property(nonatomic, strong) LookinImage *soloScreenshot;

@property(nonatomic, strong) NSValue *frameValue;

@property(nonatomic, strong) NSValue *boundsValue;

@property(nonatomic, strong) NSNumber *hiddenValue;

@property(nonatomic, strong) NSNumber *alphaValue;

@property(nonatomic, copy) NSString *customDisplayTitle;

@property(nonatomic, copy) NSString *danceUISource;

@property(nonatomic, copy) NSArray<LookinAttributesGroup *> *attributesGroupList;
@property(nonatomic, copy) NSArray<LookinAttributesGroup *> *customAttrGroupList;

/// 当 Server 找不到 task 对应的图层时，会返回一个特殊的 LookinDisplayItemDetail 对象，这个对象会被设置 displayItemOid 和 failureCode，其中 failureCode 会被置为 -1
/// Client 1.0.7 & Server 1.2.7 开始支持该属性
/// 默认为 0
@property(nonatomic, assign) NSInteger failureCode;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
