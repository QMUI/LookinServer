//
//  LKS_PerspectiveLayer.h
//  LookinServer
//
//  Created by Li Kai on 2019/5/17.
//  https://lookin.work
//



#import <QuartzCore/QuartzCore.h>
#import "LKS_PerspectiveDataSource.h"

typedef NS_ENUM (NSUInteger, LKS_PerspectiveDimension) {
    LKS_PerspectiveDimension2D,
    LKS_PerspectiveDimension3D
};

@interface LKS_PerspectiveLayer : CALayer <LKS_PerspectiveDataSourceDelegate>

- (instancetype)initWithDataSource:(LKS_PerspectiveDataSource *)dataSource;

/// 2D 还是 3D
@property(nonatomic, assign) LKS_PerspectiveDimension dimension;

/// 旋转的角度
@property(nonatomic, assign, readonly) CGFloat rotation;
- (void)setRotation:(CGFloat)rotation animated:(BOOL)animated completion:(void (^)(void))completionBlock;

@end
