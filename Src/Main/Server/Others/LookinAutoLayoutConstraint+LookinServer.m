//
//  LookinAutoLayoutConstraint+LookinServer.m
//  LookinServer
//
//  Created by JH on 2024/11/5.
//

#import "LookinAutoLayoutConstraint+LookinServer.h"
#import "LookinObject+LookinServer.h"

@implementation LookinAutoLayoutConstraint (LookinServer)
+ (instancetype)instanceFromNSConstraint:(NSLayoutConstraint *)constraint isEffective:(BOOL)isEffective firstItemType:(LookinConstraintItemType)firstItemType secondItemType:(LookinConstraintItemType)secondItemType {
    LookinAutoLayoutConstraint *instance = [LookinAutoLayoutConstraint new];
    instance.effective = isEffective;
    instance.active = constraint.active;
    instance.shouldBeArchived = constraint.shouldBeArchived;
    instance.firstItem = [LookinObject instanceWithObject:constraint.firstItem];
    instance.firstItemType = firstItemType;
    instance.firstAttribute = constraint.firstAttribute;
    instance.relation = constraint.relation;
    instance.secondItem = [LookinObject instanceWithObject:constraint.secondItem];
    instance.secondItemType = secondItemType;
    instance.secondAttribute = constraint.secondAttribute;
    instance.multiplier = constraint.multiplier;
    instance.constant = constraint.constant;
    instance.priority = constraint.priority;
    instance.identifier = constraint.identifier;
    
    return instance;
}
@end
