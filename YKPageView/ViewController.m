//
//  ViewController.m
//  YKPageView
//
//  Created by Mark on 15/5/30.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "ViewController.h"
#import "WKPageView.h"
#import "UIColor+Random.h"
@interface ViewController () <WKPageViewDataSource,WKPageViewDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak)   WKPageView *pageView;
@end

@implementation ViewController
- (NSArray *)items{
    if (_items == nil) {
        _items = @[@"最新",@"言情",@"武侠",@"明星",@"DotA",@"LOL",@"WOW",@"高富帅",@"富美",@"屌丝",@"壮汉"];
    }
    return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    WKPageView *pageView = [[WKPageView alloc] initWithFrame:self.view.bounds];
    pageView.dataSource = self;
    pageView.delegate = self;
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];
    self.pageView = pageView;
}
#pragma mark - page view datasource
// Menu的标题用NSArray封装，内为NSString
- (NSArray *)menuItemsForMenuViewInPageView:(WKPageView *)pageView{
    return self.items;
}
- (WKPageCell *)pageView:(WKPageView *)pageView cellForIndex:(NSInteger)index{
    static NSString *identifier = @"pageCell";
    WKPageCell *cell = [pageView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WKPageCell alloc] initWithIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}
#pragma mark Page view delegate
// 若不实现，默认红黑，为保证字体颜色渐变，请尽量选用RGBA来创建UIColor
//- (UIColor *)titleColorOfMenuItemInPageView:(WKPageView *)pageView withState:(WKMenuItemTitleColorState)state{
//    return [UIColor randomColor];
//}
// 若不实现,默认为30
- (CGFloat)pageView:(WKPageView *)pageView heightForMenuView:(WKMenuView *)menuView{
    return 30;
}
// 若不实现，默认为15/18
- (CGFloat)titleSizeOfMenuItemInPageView:(WKPageView *)pageView withState:(WKMenuItemTitleSizeState)state{
    switch (state) {
        case WKMenuItemTitleSizeStateNormal:
            return 15;
            break;
        case WKMenuItemTitleSizeStateSelected:
            return 18;
        default:
            break;
    }
}
// 若不实现，默认为灰色
- (UIColor *)backgroundColorOfMenuViewInPageView:(WKPageView *)pageView{
    return [UIColor lightGrayColor];
}
// MenuView内部各个item的宽度，若标题过长可自行设置，默认为60
- (CGFloat)pageView:(WKPageView *)pageView widthForMenuItemAtIndex:(NSInteger)index{
    return 60;
}
@end