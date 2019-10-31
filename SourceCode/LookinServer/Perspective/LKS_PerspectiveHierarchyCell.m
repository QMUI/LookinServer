//
//  LKS_PerspectiveHierarchyCell.m
//  LookinServer
//
//  Created by Li Kai on 2018/12/24.
//  https://lookin.work
//

#import "LKS_PerspectiveHierarchyCell.h"

#ifdef CAN_COMPILE_LOOKIN_SERVER

#import "LookinDisplayItem.h"
#import "LookinIvarTrace.h"

@interface LKS_PerspectiveHierarchyCell ()

@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) CALayer *strikethroughLayer;

@property(nonatomic, assign) CGFloat cachedContentWidth;

@end

@implementation LKS_PerspectiveHierarchyCell {
    CGFloat _horInset;
    CGFloat _indicatorWidth;
    CGFloat _iconImageMarginLeft;
    CGFloat _indentUnitWidth;
    CGFloat _titleLeft;
    CGFloat _subtitleLeft;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _horInset = 10;
        _indicatorWidth = 15;
        _iconImageMarginLeft = 5;
        _indentUnitWidth = 10;
        _titleLeft = 6;
        _subtitleLeft = 10;
        
        self.iconImageView = [UIImageView new];
        [self.contentView addSubview:self.iconImageView];
        
        _indicatorButton = [UIButton new];
        [self.contentView addSubview:self.indicatorButton];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.titleLabel];
        
        self.subtitleLabel = [UILabel new];
        self.subtitleLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicatorButton.frame = ({
        CGFloat x = self.displayItem.indentLevel * _indentUnitWidth + _horInset;
        CGRectMake(x, 0, _indicatorWidth, self.bounds.size.height);
    });
    
    self.iconImageView.frame = ({
        CGSize size = [self.iconImageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGRectMake(CGRectGetMaxX(self.indicatorButton.frame) + _iconImageMarginLeft, self.contentView.bounds.size.height / 2.0 - size.height / 2.0, size.width, size.height);
    });
    
    self.titleLabel.frame = ({
        CGFloat width = self.titleLabel.lks_bestWidth;
        CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + _titleLeft, 0, width, self.bounds.size.height);
    });
    CGFloat labelMaxX = CGRectGetMaxX(self.titleLabel.frame);
    
    if (!self.subtitleLabel.hidden) {
        self.subtitleLabel.frame = ({
            CGFloat width = self.subtitleLabel.lks_bestWidth;
            CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + _subtitleLeft, 0, width, self.bounds.size.height);
        });
        labelMaxX = CGRectGetMaxX(self.subtitleLabel.frame);
    }
    if (self.strikethroughLayer && !self.strikethroughLayer.hidden) {
        self.strikethroughLayer.frame = ({
            CGFloat x = CGRectGetMinX(self.titleLabel.frame) - 2;
            CGFloat maxX = self.subtitleLabel.hidden ? (CGRectGetMaxX(self.titleLabel.frame) + 2) : (CGRectGetMaxX(self.subtitleLabel.frame) + 2);
            CGFloat width = maxX - x;
            CGRectMake(x, CGRectGetMidY(self.bounds), width, 1);
        });
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = self.cachedContentWidth;
    return size;
}

- (void)setDisplayItem:(LookinDisplayItem *)displayItem {
    _displayItem = displayItem;
    [self reRender];
}

- (void)reRender {
    // text
    self.titleLabel.text = self.displayItem.title;
    
    // subtitle
    self.subtitleLabel.text = self.displayItem.subtitle;
    self.subtitleLabel.hidden = (self.displayItem.subtitle.length == 0);
    
    // select
    if (self.displayItem.isSelected) {
        self.backgroundColor = LookinColorRGBAMake(172, 177, 191, .4);
        self.subtitleLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.textColor = LookinColorMake(133, 140, 150);
    }
 
    // icon
    if (!self.displayItem.isExpandable) {
        self.indicatorButton.hidden = YES;
    } else if (self.displayItem.isExpanded) {
        [self.indicatorButton setImage:[self _arrowDownImage] forState:UIControlStateNormal];
        self.indicatorButton.hidden = NO;
    } else {
        [self.indicatorButton setImage:[self _arrowRightImage] forState:UIControlStateNormal];
        self.indicatorButton.hidden = NO;
    }
    
    // image
    self.iconImageView.image = [self _iconWithDisplayItem:self.displayItem isSelected:self.displayItem.isSelected];
    
    // strike
    if (self.displayItem.inNoPreviewHierarchy) {
        if (!self.strikethroughLayer) {
            self.strikethroughLayer = [CALayer layer];
            [self.strikethroughLayer lookin_removeImplicitAnimations];
            self.strikethroughLayer.backgroundColor = LookinColorRGBAMake(255, 255, 255, .3).CGColor;
            [self.layer addSublayer:self.strikethroughLayer];
        }
        self.strikethroughLayer.hidden = NO;
        
        if (self.displayItem.isSelected) {
            self.titleLabel.textColor = [UIColor whiteColor];
        } else {
            self.titleLabel.textColor = LookinColorMake(113, 120, 130);
        }
    } else {
        self.strikethroughLayer.hidden = YES;
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    
    [self setNeedsLayout];

    self.cachedContentWidth = ({
        CGFloat width = 0;
        width = _horInset + self.displayItem.indentLevel * _indentUnitWidth + _indicatorWidth + _iconImageMarginLeft + self.iconImageView.lks_bestWidth + _titleLeft + self.titleLabel.lks_bestWidth + _horInset;
        if (!self.subtitleLabel.hidden) {
            width += self.subtitleLabel.lks_bestWidth + _subtitleLeft;
        }
        width;
    });
}

- (UIImage *)_arrowRightImage {
    static UIImage *image = nil;
    if (image) {
        return image;
    }
    
    CGFloat width = 10;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width - 2, width / 2.0)];
    [path addLineToPoint:CGPointMake(0, width)];
    [path closePath];
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [path fill];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)_arrowDownImage {
    static UIImage *image = nil;
    if (image) {
        return image;
    }
    
    CGFloat width = 10;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, width), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width / 2.0, width - 2)];
    [path closePath];
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [path fill];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)_iconWithDisplayItem:(LookinDisplayItem *)item isSelected:(BOOL)isSelected {
    static dispatch_once_t viewOnceToken;
    static NSArray<NSDictionary<NSString *, NSString *> *> *viewsList = nil;
    dispatch_once(&viewOnceToken,^{
        viewsList = @[
            @{@"UIWindow": @"hierarchy_window"},
            @{@"UINavigationBar": @"hierarchy_navigationbar"},
            @{@"UITabBar": @"hierarchy_tabbar"},
            @{@"UITextView": @"hierarchy_textview"},
            @{@"UITextField": @"hierarchy_textfield"},
            @{@"UITableView": @"hierarchy_tableview"},
            @{@"UICollectionView": @"hierarchy_collectionview"},
            @{@"UICollectionViewCell": @"hierarchy_collectioncell"},
            @{@"UICollectionReusableView": @"hierarchy_collectionreuseview"},
            @{@"UITableViewCell": @"hierarchy_tablecell"},
            @{@"UISlider": @"hierarchy_slider"},
            @{@"WKWebView": @"hierarchy_webview"},
            @{@"UIWebView": @"hierarchy_webview"},
            @{@"_UITableViewCellSeparatorView": @"hierarchy_tablecellseparator"},
            @{@"UITableViewCellContentView": @"hierarchy_cellcontent"},
            @{@"_UITableViewHeaderFooterContentView": @"hierarchy_cellcontent"},
            @{@"UITableViewHeaderFooterView": @"hierarchy_tableheaderfooter"},
            @{@"UIScrollView": @"hierarchy_scrollview"},
            @{@"UILabel": @"hierarchy_label"},
            @{@"UIButton": @"hierarchy_button"},
            @{@"UIImageView": @"hierarchy_imageview"},
            @{@"UIControl": @"hierarchy_control"},
        ];
    });
    
    __block NSString *imageName = nil;
    if (item.hostViewControllerObject) {
        imageName = @"hierarchy_controller";
        
    } else if (item.viewObject) {
        [item.viewObject.classChainList enumerateObjectsUsingBlock:^(NSString * _Nonnull className, NSUInteger idx, BOOL * _Nonnull stop) {
            imageName = [viewsList lookin_firstFiltered:^BOOL(NSDictionary<NSString *, NSString*> *obj) {
                return !!obj[className];
            }][className];
            
            if (imageName) {
                *stop = YES;
            }
        }];
        
        if (!imageName) {
            imageName = @"hierarchy_view";
        }
        
    } else if (item.layerObject) {
        [item.layerObject.classChainList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@"CAShapeLayer"]) {
                imageName = @"hierarchy_shapelayer";
                *stop = YES;
                return;
            }
            if ([obj isEqualToString:@"CAGradientLayer"]) {
                imageName = @"hierarchy_gradientlayer";
                *stop = YES;
                return;
            }
        }];
        if (!imageName) {
            imageName = @"hierarchy_layer";
        }
    }
    
    if (!imageName) {
        imageName = @"hierarchy_view";
    }
    
    if (isSelected) {
        NSString *selectedImageName = [imageName stringByAppendingString:@"_selected"];
        UIImage *selectedImage = [self _imageWithName:selectedImageName];
        if (selectedImage) {
            return selectedImage;
        } else {
            return [self _imageWithName:imageName];
        }
    } else {
        return [self _imageWithName:imageName];
    }
}

- (UIImage *)_imageWithName:(NSString *)name {
    NSBundle *bundle = [self resourcesBundleWithName:@"LookinServerImages.bundle"];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

- (NSBundle *)resourcesBundleWithName:(NSString *)bundleName {
    NSBundle *bundle = [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName]];
    if (!bundle) {
        // 动态framework的bundle资源是打包在framework里面的，所以无法通过mainBundle拿到资源，只能通过其他方法来获取bundle资源。
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
        NSDictionary *bundleData = [self parseBundleName:bundleName];
        if (bundleData) {
            bundle = [NSBundle bundleWithPath:[frameworkBundle pathForResource:[bundleData objectForKey:@"name"] ofType:[bundleData objectForKey:@"type"]]];
        }
    }
    return bundle;
}

- (NSDictionary *)parseBundleName:(NSString *)bundleName {
    NSArray *bundleData = [bundleName componentsSeparatedByString:@"."];
    if (bundleData.count == 2) {
        return @{@"name":bundleData[0], @"type":bundleData[1]};
    }
    return nil;
}

@end

#endif
