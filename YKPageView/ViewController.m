//
//  ViewController.m
//  YKPageView
//
//  Created by Mark on 15/5/30.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "ViewController.h"
#import "YKPageView.h"
#import "UIColor+Random.h"

@interface ViewController () <YKPageViewDataSource,YKPageViewDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) YKPageView *pageView;
@end

@implementation ViewController
- (NSArray *)items {
    if (_items == nil) {
        _items = @[@"最新", @"言情", @"武侠", @"明星", @"DotA", @"LOL", @"WOW", @"高富帅", @"富美", @"屌丝", @"壮汉"];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self p_addPageView];
}

- (void)p_addPageView {
    YKPageView *pageView = [[YKPageView alloc] initWithFrame:self.view.bounds];
    pageView.dataSource = self;
    pageView.delegate = self;
    pageView.selectIndex = 3;
    pageView.menuViewStyle = YKMenuViewStyleLine;
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];
    self.pageView = pageView;
}

#pragma mark - page view datasource
// Menu的标题用NSArray封装，内为NSString
- (NSArray *)menuItemsForMenuViewInPageView:(YKPageView *)pageView {
    return self.items;
}

- (YKPageCell *)pageView:(YKPageView *)pageView cellForIndex:(NSInteger)index {
    static NSString *identifier = @"pageCell";
    YKPageCell *cell = [pageView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[YKPageCell alloc] initWithIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}

#pragma mark Page view delegate
// 若不实现，默认红黑，为保证字体颜色渐变，请尽量选用RGBA来创建UIColor
- (UIColor *)titleColorOfMenuItemInPageView:(YKPageView *)pageView withState:(YKMenuItemTitleColorState)state {
    return [UIColor randomColor];
}

// 若不实现,默认为30
- (CGFloat)pageView:(YKPageView *)pageView heightForMenuView:(YKMenuView *)menuView{
    return 30;
}

// 若不实现，默认为15/18
- (CGFloat)titleSizeOfMenuItemInPageView:(YKPageView *)pageView withState:(YKMenuItemTitleSizeState)state {
    switch (state) {
        case YKMenuItemTitleSizeStateNormal:
            return 15;
            break;
        case YKMenuItemTitleSizeStateSelected:
            return 18;
        default:
            break;
    }
}

// 若不实现，默认为灰色
- (UIColor *)backgroundColorOfMenuViewInPageView:(YKPageView *)pageView {
    return [UIColor lightGrayColor];
}

// MenuView 内部各个 item 的宽度，若标题过长可自行设置，默认为 60
- (CGFloat)pageView:(YKPageView *)pageView widthForMenuItemAtIndex:(NSInteger)index {
    return 60;
}

@end