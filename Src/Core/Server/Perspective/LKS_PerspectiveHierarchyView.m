#ifdef SHOULD_COMPILE_LOOKIN_SERVER 

//
//  LKS_PerspectiveHierarchyView.m
//  LookinServer
//
//  Created by Li Kai on 2018/12/24.
//  https://lookin.work
//

#import "LKS_PerspectiveHierarchyView.h"



#import "LKS_PerspectiveHierarchyCell.h"
#import "LookinDisplayItem.h"
#import "LookinServerDefines.h"

@interface LKS_PerspectiveHierarchyView () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIVisualEffectView *effectBgView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) LKS_PerspectiveDataSource *dataSource;
@property(nonatomic, strong) CALayer *dragHintLayer;

@property(nonatomic, assign) CGFloat currentMaxCellWidth;

@property(nonatomic, weak) LKS_PerspectiveHierarchyCell *selectedCell;

@end

@implementation LKS_PerspectiveHierarchyView

- (instancetype)initWithDataSource:(LKS_PerspectiveDataSource *)dataSource {
    if (self = [self initWithFrame:CGRectZero]) {
        self.dataSource = dataSource;
        self.dataSource.hierarchyView = self;
        
        self.clipsToBounds = YES;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.effectBgView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:self.effectBgView];
        
        self.dragHintLayer = [CALayer layer];
        self.dragHintLayer.backgroundColor = LookinColorMake(70, 70, 70).CGColor;
        [self.dragHintLayer lookin_removeImplicitAnimations];
        [self.layer addSublayer:self.dragHintLayer];
        
        self.scrollView = [UIScrollView new];
        self.scrollView.bounces = YES;
        [self addSubview:self.scrollView];
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = [UIColor clearColor];
#if TARGET_OS_TV
#else
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.scrollView addSubview:self.tableView];
        
//        [self _updateCurrentMaxCellWidth];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.effectBgView.frame = self.effectBgView.superview.bounds;
    
    // 留出一部分区域用来上下拖拽
    CGFloat dragAreaLength = 26;
    if (self.isHorizontalLayout) {
        self.dragHintLayer.frame = ({
            CGFloat width = 5;
            CGFloat height = 38;
            CGRectMake(self.layer.bounds.size.width - dragAreaLength / 2.0 - width / 2.0, self.layer.bounds.size.height / 2.0 - height / 2.0, width, height);
        });
        self.dragHintLayer.cornerRadius = self.dragHintLayer.bounds.size.width / 2.0;
        
        self.scrollView.frame = CGRectMake(0, 0, self.layer.bounds.size.width - dragAreaLength, self.layer.bounds.size.height);
        
    } else {
        self.dragHintLayer.frame = ({
            CGFloat width = 38;
            CGFloat height = 5;
            CGRectMake(self.layer.bounds.size.width / 2.0 - width / 2.0, dragAreaLength / 2.0 - height / 2.0, width, height);
        });
        self.dragHintLayer.cornerRadius = self.dragHintLayer.bounds.size.height / 2.0;

        self.scrollView.frame = CGRectMake(0, dragAreaLength, self.layer.bounds.size.width, self.layer.bounds.size.height - dragAreaLength);
    }
    
    CGSize tableSize = CGSizeMake(MAX(self.currentMaxCellWidth, self.scrollView.bounds.size.width), self.scrollView.bounds.size.height);
    self.scrollView.contentSize = tableSize;
    self.tableView.frame = CGRectMake(0, 0, tableSize.width, tableSize.height);
}

- (void)setIsHorizontalLayout:(BOOL)isHorizontalLayout {
    _isHorizontalLayout = isHorizontalLayout;
    if (isHorizontalLayout) {
        // 顶部给 menu 留一点位置
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    [self setNeedsLayout];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKS_PerspectiveHierarchyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LKS_PerspectiveHierarchyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.indicatorButton addTarget:self action:@selector(_handleCellExpansionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    LookinDisplayItem *item = [self.dataSource itemAtRow:indexPath.row];
    cell.displayItem = item;
    cell.indicatorButton.tag = indexPath.row;
    if (item.isSelected) {
        self.selectedCell = cell;
    }
    
    CGFloat cellWidth = [cell sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    if (self.currentMaxCellWidth < cellWidth) {
        self.currentMaxCellWidth = cellWidth;
        [self setNeedsLayout];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LookinDisplayItem *item = [self.dataSource itemAtRow:indexPath.row];
    if (self.dataSource.selectedItem != item) {
        self.dataSource.selectedItem = item;
    }
}

#pragma mark - <LKS_PerspectiveDataSourceDelegate>

- (void)dataSourceDidChangeDisplayItems:(LKS_PerspectiveDataSource *)dataSource {
    [self _tableViewReloadData];
}

- (void)dataSourceDidChangeSelectedItem:(LKS_PerspectiveDataSource *)dataSource {
    NSInteger row = [dataSource rowForItem:dataSource.selectedItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.selectedCell reRender];
    
    if (!indexPath) {
        return;
    }
    // 去掉旧的 cell 的点击态
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    NSArray<NSIndexPath *> *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    if (![visibleIndexPaths containsObject:indexPath]) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

#pragma mark - Others

- (void)_tableViewReloadData {
    self.currentMaxCellWidth = 0;
    [self.tableView reloadData];
}

- (void)_handleCellExpansionButton:(UIButton *)button {
    NSUInteger row = button.tag;
    LookinDisplayItem *item = [self.dataSource itemAtRow:row];
    if (!item) {
        return;
    }
    if (!item.isExpandable) {
        return;
    }
    if (item.isExpanded) {
        [self.dataSource collapseItem:item];
    } else {
        [self.dataSource expandItem:item];
    }
}

@end

#endif /* SHOULD_COMPILE_LOOKIN_SERVER */
