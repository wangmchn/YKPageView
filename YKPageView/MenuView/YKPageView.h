//
//  YKPageView.h
//  YKPageView
//
//  Created by Mark on 15/4/27.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKPageCell.h"
#import "YKMenuView.h"
@class YKPageView;

typedef NS_ENUM(NSInteger, YKMenuItemTitleSizeState) {
    YKMenuItemTitleSizeStateNormal = 0,
    YKMenuItemTitleSizeStateSelected
};

typedef NS_ENUM(NSInteger, YKMenuItemTitleColorState) {
    YKMenuItemTitleColorStateNormal = 0,
    YKMenuItemTitleColorStateSelected
};

/** 数据源 */
@protocol YKPageViewDataSource <NSObject>
@required
/**
 *  数据源方法，获取当前 index 的 cell
 *
 *  @param pageView 翻页视图
 *  @param index    cell 的序号
 *
 *  @return YKPageCell
 */
- (YKPageCell *)pageView:(YKPageView *)pageView cellForIndex:(NSInteger)index;

/**
 *  数据源方法，获取当前menuView的items标题，以NSArray的形式
 *
 *  @param pageView 翻页视图
 *
 *  @return menuView 的 items 的标题 (内为字符串)
 */
- (NSArray *)menuItemsForMenuViewInPageView:(YKPageView *)pageView;

@end

/** 代理 */
@protocol YKPageViewDelegate <NSObject>
@optional
/**
 *  设置 menuView 的高度，默认为 30
 *
 *  @param pageView 当前翻页视图
 *  @param menuView 顶部菜单视图
 *
 *  @return menuView 的高度
 */
- (CGFloat)pageView:(YKPageView *)pageView heightForMenuView:(YKMenuView *)menuView;

/**
 *  设置menuView的背景颜色
 *
 *  @param pageView 当前翻页视图
 *
 *  @return UIColor
 */
- (UIColor *)backgroundColorOfMenuViewInPageView:(YKPageView *)pageView;

/**
 *  设置菜单栏标题颜色
 *
 *  @param pageView 当前翻页视图
 *  @param state    分为 YKMenuItemTitleColorStateNormal (未选中) / YKMenuItemTitleColorStateSelected (选中)
 *
 *  @return UIColor
 */
- (UIColor *)titleColorOfMenuItemInPageView:(YKPageView *)pageView withState:(YKMenuItemTitleColorState)state;

/**
 *  设置菜单栏标题字体大小 (大于零)
 *
 *  @param pageView 当前翻页视图
 *  @param state    分为 YKMenuItemTitleSizeStateNormal (未选中) / YKMenuItemTitleSizeStateSelected (选中)
 *
 *  @return 标题字体大小
 */
- (CGFloat)titleSizeOfMenuItemInPageView:(YKPageView *)pageView withState:(YKMenuItemTitleSizeState)state;

/**
 *  设置菜单栏内部item的宽度，默认宽度为60
 *
 *  @param pageView 当前翻页视图
 *  @param index    YKMenuItem 的序号，可根据序号定制
 *
 *  @return item的宽度
 */
- (CGFloat)pageView:(YKPageView *)pageView widthForMenuItemAtIndex:(NSInteger)index;

@end

@interface YKPageView : UIView

/** 点击菜单栏item时翻页的动画,默认为 YES */
@property (nonatomic, assign) BOOL toAnimate;

/** 上方导航栏的样式 */
@property (nonatomic, assign) YKMenuViewStyle menuViewStyle;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, weak) id<YKPageViewDataSource> dataSource;
@property (nonatomic, weak) id<YKPageViewDelegate> delegate;

/** 刷新数据 */
- (void)reloadData;

/**
 *  从缓存池中取出可重用的cell，若没有则返回nil
 *
 *  @param identifier 重用cell的标识符
 *
 *  @return 返回Cell以供重用
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

@end
