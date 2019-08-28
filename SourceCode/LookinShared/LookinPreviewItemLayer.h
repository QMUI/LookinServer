//
//  LookinPreviewItemLayer.h
//  Lookin
//
//  Copyright © 2019 Lookin. All rights reserved.
//

#import <Appkit/Appkit.h>

@class LookinDisplayItem, LKPreferenceManager;

@interface LookinPreviewItemLayer : CALayer

- (instancetype)initWithPreferenceManager:(LKPreferenceManager *)manager;

@property(nonatomic, strong) LookinDisplayItem *displayItem;

@property(nonatomic, assign) CGFloat zTranslation;
@property(nonatomic, assign) CGFloat yTranslation;

@end
