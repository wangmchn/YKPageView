//
//  WKPageView.m
//  CosChat
//
//  Created by Mark on 15/4/27.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WKPageView.h"
#import "WKMenuView.h"
#define kSelectedSize 18
#define kNormolSize   15
#define kDefaultMH 30
#define kDeflautItemWidth 60
@interface WKPageView () <UIScrollViewDelegate, WKMenuViewDelegate>{
    BOOL animate;
    BOOL setted;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *reusePool;
@property (nonatomic, assign) CGFloat menuViewHeight;
@property (nonatomic, strong) NSMutableDictionary *displayCells;
@property (nonatomic, strong) NSMutableArray *cellFrames;
@property (nonatomic, weak) WKMenuView *menuView;
@end

@implementation WKPageView
#pragma mark - Lazy load
- (NSMutableDictionary *)displayCells{
    if (_displayCells == nil) {
        _displayCells = [[NSMutableDictionary alloc] init];
    }
    return _displayCells;
}
- (NSMutableArray *)cellFrames{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}
- (NSMutableSet *)reusePool{
    if (_reusePool == nil) {
        _reusePool = [[NSMutableSet alloc] init];
    }
    return _reusePool;
}
- (CGFloat)menuViewHeight{
    if (!_menuViewHeight) {
        if ([self.delegate respondsToSelector:@selector(pageView:heightForMenuView:)]) {
            _menuViewHeight = [self.delegate pageView:self heightForMenuView:self.menuView];
        }else{
            _menuViewHeight = kDefaultMH;
        }
    }
    return _menuViewHeight;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self reloadData];
}
// 添加菜单栏
- (void)addMenuView{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.menuViewHeight;
    NSArray *items = [self.dataSource menuItemsForMenuViewInPageView:self];
    CGRect frame = CGRectMake(0, 0, width, height);
    UIColor *color,*norColor,*selColor;
    CGFloat norSize,selSize;
    if ([self.delegate respondsToSelector:@selector(backgroundColorOfMenuViewInPageView:)]) {
        color = [self.delegate backgroundColorOfMenuViewInPageView:self];
    }
    if ([self.delegate respondsToSelector:@selector(titleColorOfMenuItemInPageView:withState:)]) {
        norColor = [self.delegate titleColorOfMenuItemInPageView:self withState:WKMenuItemTitleColorStateNormal];
        selColor = [self.delegate titleColorOfMenuItemInPageView:self withState:WKMenuItemTitleColorStateSelected];
    }
    if ([self.delegate respondsToSelector:@selector(titleSizeOfMenuItemInPageView:withState:)]) {
        norSize = [self.delegate titleSizeOfMenuItemInPageView:self withState:WKMenuItemTitleSizeStateNormal];
        selSize = [self.delegate titleSizeOfMenuItemInPageView:self withState:WKMenuItemTitleSizeStateSelected];
    }else{
        /**
         *  若没实现delegate 所得的float有可能会是一个最大值或者最小值，因为在此设置默认！！紧记！紧记！！
         */
        norSize = kNormolSize;
        selSize = kSelectedSize;
    }
    WKMenuView *menuView = [[WKMenuView alloc] initWithFrame:frame buttonItems:items backgroundColor:color norSize:norSize selSize:selSize norColor:norColor selColor:selColor];
    menuView.delegate = self;
    
    [self addSubview:menuView];
    self.menuView = menuView;
}
// 添加主滚动视图
- (void)addScrollView{
    CGFloat x = 0;
    CGFloat y = self.menuViewHeight;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height - self.menuViewHeight;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    NSUInteger numOfCells = [[self.dataSource menuItemsForMenuViewInPageView:self] count];
    for (int i = 0; i < numOfCells; i++) {
        CGFloat x = i * width;
        CGFloat y = 0;
        CGRect frame = CGRectMake(x, y, width, height);
        
        
        if (i == 0) {
            WKPageCell *cell = [self.dataSource pageView:self cellForIndex:i];
            cell.frame = frame;
            [scrollView addSubview:cell];
            
            [self.displayCells setObject:cell forKey:@(i)];
        }
        [self.cellFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    CGFloat contentX = self.frame.size.width*numOfCells;
    CGFloat contentY = height;
    scrollView.contentSize = CGSizeMake(contentX, contentY);
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}
- (BOOL)isInScreen:(CGRect)frame{
    CGFloat x = frame.origin.x;
    CGFloat ScreenWidth = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < ScreenWidth) {
        return YES;
    }else{
        return NO;
    }
}
// 排列items
- (void)layoutItems{
    for (int i = 0; i < self.cellFrames.count; i++) {
        WKPageCell *cell = self.displayCells[@(i)];
        CGRect frame = [self.cellFrames[i] CGRectValue];
        if ([self isInScreen:frame]) {
            if (cell == nil) {
                // cell不存在时，问数据源要cell
                cell = [self.dataSource pageView:self cellForIndex:i];
                cell.frame = frame;
                [self.scrollView addSubview:cell];
                // 放到展示中的数组中，以便取用
                [self.displayCells setObject:cell forKey:@(i)];
            }
        }else{
            // cell存在且不在屏幕中
            if (cell) {
                // 移除屏幕上显示的cell
                [self.displayCells removeObjectForKey:@(i)];
                [cell removeFromSuperview];
                // 放入缓存池
                [self.reusePool addObject:cell];
            }
        }
    }
    NSLog(@"NumberOfCellsInScreen: %lu",(unsigned long)self.scrollView.subviews.count);
}
// 清空所有数组，字典，并移除所有子控件
- (void)clearAllData{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayCells removeAllObjects];
    [self.reusePool removeAllObjects];
    [self.cellFrames removeAllObjects];
    if (self.menuView) {
        [self.menuView removeFromSuperview];
    }
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
}
#pragma mark - Public Methods
- (void)setToAnimate:(BOOL)toAnimate{
    _toAnimate = toAnimate;
    setted = YES;
}
- (void)reloadData{
    [self clearAllData];
    [self addMenuView];
    [self addScrollView];
}
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    __block WKPageCell *reuseCell;
    [self.reusePool enumerateObjectsUsingBlock:^(WKPageCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reuseCell = cell;
            *stop = YES;
        }
    }];
    if (reuseCell) {
        [self.reusePool removeObject:reuseCell];
    }
    return reuseCell;
}
#pragma mark - MenuView delegate
- (void)menuView:(WKMenuView *)menu didSelesctedIndex:(NSInteger)index{
    animate = NO;
    CGPoint targetP = CGPointMake(self.scrollView.frame.size.width*index, 0);
    [self.scrollView setContentOffset:targetP animated:setted?self.toAnimate:YES];
}
- (CGFloat)menuView:(WKMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(pageView:widthForMenuItemAtIndex:)]) {
        return [self.delegate pageView:self widthForMenuItemAtIndex:index];
    }else{
        return kDeflautItemWidth;
    }
}
#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self layoutItems];
    if (animate) {
        CGFloat width = scrollView.frame.size.width;
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        CGFloat rate = contentOffsetX / width;
        [self.menuView slideMenuAtProgress:rate];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    animate = YES;
}
@end
