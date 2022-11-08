#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LookinAutoLayoutConstraint.h
//  Lookin
//
//  Created by Li Kai on 2019/9/28.
//  https://lookin.work
//



#import "LookinDefines.h"

@class LookinObject;

typedef NS_ENUM(NSInteger, LookinConstraintItemType) {
    LookinConstraintItemTypeUnknown,
    LookinConstraintItemTypeNil,
    LookinConstraintItemTypeView,
    LookinConstraintItemTypeSelf,
    LookinConstraintItemTypeSuper,
    LookinConstraintItemTypeLayoutGuide
};

@interface LookinAutoLayoutConstraint : NSObject <NSSecureCoding>

#if TARGET_OS_IPHONE
+ (instancetype)instanceFromNSConstraint:(NSLayoutConstraint *)constraint isEffective:(BOOL)isEffective firstItemType:(LookinConstraintItemType)firstItemType secondItemType:(LookinConstraintItemType)secondItemType;
#endif

@property(nonatomic, assign) BOOL effective;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, assign) BOOL shouldBeArchived;
@property(nonatomic, strong) LookinObject *firstItem;
@property(nonatomic, assign) LookinConstraintItemType firstItemType;
@property(nonatomic, assign) NSLayoutAttribute firstAttribute;
@property(nonatomic, assign) NSLayoutRelation relation;
@property(nonatomic, strong) LookinObject *secondItem;
@property(nonatomic, assign) LookinConstraintItemType secondItemType;
@property(nonatomic, assign) NSLayoutAttribute secondAttribute;
@property(nonatomic, assign) CGFloat multiplier;
@property(nonatomic, assign) CGFloat constant;
@property(nonatomic, assign) CGFloat priority;
@property(nonatomic, copy) NSString *identifier;

+ (NSString *)descriptionWithItemObject:(LookinObject *)object type:(LookinConstraintItemType)type detailed:(BOOL)detailed;
+ (NSString *)descriptionWithAttribute:(NSLayoutAttribute)attribute;
+ (NSString *)symbolWithRelation:(NSLayoutRelation)relation;
+ (NSString *)descriptionWithRelation:(NSLayoutRelation)relation;

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
