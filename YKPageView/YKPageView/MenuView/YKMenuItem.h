//
//  YKMenuItem.h
//  YKPageView
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YKMenuItem;
@protocol YKMenuItemDelegate <NSObject>
@optional
- (void)didPressedMenuItem:(YKMenuItem *)menuItem;
@end

@interface YKMenuItem : UILabel

/** 设置rate,并刷新标题状态 */
@property (nonatomic, assign) CGFloat rate;

/** normal状态的字体大小，默认大小为15 */
@property (nonatomic, assign) CGFloat normalSize;

/** selected状态的字体大小，默认大小为18 */
@property (nonatomic, assign) CGFloat selectedSize;

/** normal状态的字体颜色，默认为黑色 (可动画) */
@property (nonatomic, strong) UIColor *normalColor;

/** selected状态的字体颜色，默认为红色 (可动画) */
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, weak) id<YKMenuItemDelegate> delegate;
- (void)selectedItemWithoutAnimation;
- (void)deselectedItemWithoutAnimation;
@end
