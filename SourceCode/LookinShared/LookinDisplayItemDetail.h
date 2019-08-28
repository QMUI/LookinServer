//
//  LookinDisplayItemDetail.h
//  Lookin
//
//  Copyright © 2019 hughkli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LookinAttributesGroup;

@interface LookinDisplayItemDetail : NSObject <NSSecureCoding>

@property(nonatomic, assign) unsigned long displayItemOid;

@property(nonatomic, strong) LookinImage *groupScreenshot;

@property(nonatomic, strong) LookinImage *soloScreenshot;

@property(nonatomic, strong) NSError *groupScreenshotError;
@property(nonatomic, strong) NSError *soloScreenshotError;
@property(nonatomic, strong) NSError *attrGroupsError;

@property(nonatomic, strong) NSValue *frameValue;

@property(nonatomic, strong) NSValue *boundsValue;

@property(nonatomic, strong) NSNumber *hiddenValue;

@property(nonatomic, strong) NSNumber *alphaValue;

@property(nonatomic, copy) NSArray<LookinAttributesGroup *> *attributesGroupList;

@end
