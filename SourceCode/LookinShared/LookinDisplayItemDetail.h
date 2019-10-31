//
//  LookinDisplayItemDetail.h
//  Lookin
//
//  Created by Li Kai on 2019/2/19.
//  https://lookin.work
//

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import <Foundation/Foundation.h>

@class LookinAttributesGroup;

@interface LookinDisplayItemDetail : NSObject <NSSecureCoding>

@property(nonatomic, assign) unsigned long displayItemOid;

@property(nonatomic, strong) LookinImage *groupScreenshot;

@property(nonatomic, strong) LookinImage *soloScreenshot;

@property(nonatomic, strong) NSValue *frameValue;

@property(nonatomic, strong) NSValue *boundsValue;

@property(nonatomic, strong) NSNumber *hiddenValue;

@property(nonatomic, strong) NSNumber *alphaValue;

@property(nonatomic, copy) NSArray<LookinAttributesGroup *> *attributesGroupList;

@end

#endif
