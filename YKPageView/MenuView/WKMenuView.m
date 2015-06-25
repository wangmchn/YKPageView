//
//  WKMenuView.m
//  CosChat
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WKMenuView.h"
#import "WKMenuItem.h"
#import "WMProgressView.h"
#define kMaskWidth 20
#define kItemWidth 60
#define kMargin    0
#define kBGColor   [UIColor colorWithRed:172.0/255.0 green:165.0/255.0 blue:162.0/255.0 alpha:1.0];
@interface WKMenuView () <WKMenuItemDelegate>{
    CGFloat _norSize;
    CGFloat _selSize;
    UIColor *_norColor;
    UIColor *_selColor;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *searchButton;
@property (nonatomic, strong) WKMenuItem *selItem;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, weak) WMProgressView *progressView;
@end
static int     const kTagGap = 6250;
static CGFloat const WMProgressHeight = 2.0;
@implementation WKMenuView
#pragma mark - Public Methods
- (void)selectItemAtIndex:(NSInteger)index{
    NSInteger tag = index + kTagGap;
    WKMenuItem *item = (WKMenuItem *)[self viewWithTag:tag];
    [self.selItem deselectedItemWithoutAnimation];
    self.selItem = item;
    [self.selItem selectedItemWithoutAnimation];
    self.progressView.progress = index;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:index];
    }
    [self refreshContenOffset];
}
- (instancetype)initWithFrame:(CGRect)frame buttonItems:(NSArray *)items backgroundColor:(UIColor *)bgColor norSize:(CGFloat)norSize selSize:(CGFloat)selSize norColor:(UIColor *)norColor selColor:(UIColor *)selColor{
    if (self = [super initWithFrame:frame]) {
        self.items = items;
        if (bgColor) {
            self.bgColor = bgColor;
        }else{
            self.bgColor = kBGColor;
        }
        _norSize = norSize;
        _selSize = selSize;
        _norColor = norColor;
        _selColor = selColor;
    }
    return self;
}
- (void)slideMenuAtProgress:(CGFloat)progress{
    if (self.style == WKMenuViewStyleLine) {
        self.progressView.progress = progress;
    }
    NSInteger tag = (NSInteger)progress + kTagGap;
    CGFloat rate = progress - tag + kTagGap;
    WKMenuItem *currentItem = (WKMenuItem *)[self viewWithTag:tag];
    WKMenuItem *nextItem = (WKMenuItem *)[self viewWithTag:tag+1];
    if (rate == 0.0) {
        rate = 1.0;
        self.selItem = currentItem;
        [self refreshContenOffset];
        return;
    }
    currentItem.rate = 1-rate;
    nextItem.rate = rate;
}
#pragma mark - Private Methods
- (NSMutableArray *)frames{
    if (_frames == nil) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self addScrollView];
    [self addItems];
    if (self.style == WKMenuViewStyleLine) {
        [self addProgress];
    }
}
- (void)addProgress{
    WMProgressView *pView = [[WMProgressView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-WMProgressHeight, self.scrollView.contentSize.width, WMProgressHeight)];
    pView.itemFrames = self.frames;
    if (!_selColor) {
        _selColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    }
    pView.color = _selColor.CGColor;
    pView.backgroundColor = [UIColor clearColor];
    self.progressView = pView;
    [self.scrollView addSubview:pView];
}
- (void)refreshContenOffset{
    // 让选中的item位于中间
    CGRect frame = self.selItem.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (itemX > width/2) {
        CGFloat targetX;
        if ((contentSize.width-itemX) <= width/2) {
            targetX = contentSize.width - width;
        }else{
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        // 应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)addScrollView{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGRect frame = CGRectMake(0, 0, width, height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.backgroundColor = self.bgColor;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}
- (void)addItems{
    CGFloat contentWidth = kMargin;
    for (int i = 0; i < self.items.count; i++) {
        CGFloat itemW = kItemWidth;
        if ([self.delegate respondsToSelector:@selector(menuView:widthForItemAtIndex:)]) {
            itemW = [self.delegate menuView:self widthForItemAtIndex:i];
        }
        CGRect frame = CGRectMake(contentWidth, 0, itemW, self.frame.size.height);
        contentWidth += itemW;
        WKMenuItem *item = [[WKMenuItem alloc] initWithFrame:frame];
        // 记录frame
        [self.frames addObject:[NSValue valueWithCGRect:frame]];
        item.tag = (i+kTagGap); // view的默认tag为0，因而要避免设置tag为，紧记!!
        item.title = self.items[i];
        item.delegate = self;
        item.backgroundColor = self.bgColor;
        if (_norSize > 0.0001) {
            item.normalSize = _norSize;
        }
        if ((int)_selSize > 0.0001) {
            item.selectedSize = _selSize;
        }
        if (_norColor) {
            item.normalColor = _norColor;
        }
        if (_selColor) {
            item.selectedColor = _selColor;
        }
        if (i == 0) {
            [item selectedItemWithoutAnimation];
            self.selItem = item;
        }
        [self.scrollView addSubview:item];
    }
    contentWidth += kMargin;
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.frame.size.height);
}
- (void)addMask{
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = CGRectMake(kMargin, 0, kMaskWidth, self.frame.size.height);
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.15].CGColor, (id)[UIColor clearColor].CGColor,nil];
    NSArray *locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0], nil];
    maskLayer.colors = colors;
    maskLayer.locations = locations;
    maskLayer.startPoint = CGPointMake(0, 0);

    maskLayer.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:maskLayer];
}
#pragma mark - Menu item delegate
- (void)didPressedMenuItem:(WKMenuItem *)menuItem{
    if (self.selItem == menuItem) return;
    
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:menuItem.tag-kTagGap];
    }
    
    menuItem.selected = YES;
    self.selItem.selected = NO;
    self.selItem = menuItem;
    // 让选中的item位于中间
    [self refreshContenOffset];
}
@end
