//
//  WKMenuItem.h
//  CosChat
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKMenuItem;
@protocol WKMenuItemDelegate <NSObject>
@optional
- (void)didPressedMenuItem:(WKMenuItem *)menuItem;
@end

@interface WKMenuItem : UIView
/**
 *  设置rate,并刷新标题状态
 */
@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  normal状态的字体大小，默认大小为15
 */
@property (nonatomic, assign) CGFloat normalSize;
/**
 *  selected状态的字体大小，默认大小为18
 */
@property (nonatomic, assign) CGFloat selectedSize;
/**
 *  normal状态的字体颜色，默认为黑色
 *  如果要动画，必须用rgb创建
 */
@property (nonatomic, strong) UIColor *normalColor;
/**
 *  selected状态的字体颜色，默认为红色
 *  如果要动画，必须用rgb创建
 */
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, weak) id<WKMenuItemDelegate> delegate;
- (void)selectedItemWithoutAnimation;
@end
