//
//  YKMenuView.h
//  YKPageView
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YKMenuView;
@class YKMenuItem;
typedef enum {
    YKMenuViewStyleDefault,     // 默认
    YKMenuViewStyleLine,        // 带下划线 (若要选中字体大小不变，设置选中和非选中大小一样即可)
    YKMenuViewStyleFoold,       // 涌入效果 (填充)
    YKMenuViewStyleFooldHollow  // 涌入效果 (空心的)
} YKMenuViewStyle;

@protocol YKMenuViewDelegate <NSObject>
@optional
- (void)menuView:(YKMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;
- (CGFloat)menuView:(YKMenuView *)menu widthForItemAtIndex:(NSInteger)index;
@end

@interface YKMenuView : UIView

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) YKMenuViewStyle style;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, weak) id<YKMenuViewDelegate> delegate;
@property (nonatomic, copy) NSString *fontName;

- (instancetype)initWithFrame:(CGRect)frame buttonItems:(NSArray *)items backgroundColor:(UIColor *)bgColor norSize:(CGFloat)norSize selSize:(CGFloat)selSize norColor:(UIColor *)norColor selColor:(UIColor *)selColor;
- (void)slideMenuAtProgress:(CGFloat)progress;
- (void)selectItemAtIndex:(NSInteger)index;
@end
