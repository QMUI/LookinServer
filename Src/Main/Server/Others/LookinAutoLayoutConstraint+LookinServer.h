//
//  LookinAutoLayoutConstraint+LookinServer.h
//  LookinServer
//
//  Created by JH on 2024/11/5.
//

#import "LookinAutoLayoutConstraint.h"

NS_ASSUME_NONNULL_BEGIN

@interface LookinAutoLayoutConstraint (LookinServer)
+ (instancetype)instanceFromNSConstraint:(NSLayoutConstraint *)constraint isEffective:(BOOL)isEffective firstItemType:(LookinConstraintItemType)firstItemType secondItemType:(LookinConstraintItemType)secondItemType;

@end

NS_ASSUME_NONNULL_END
