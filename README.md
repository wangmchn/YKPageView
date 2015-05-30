# YKPageView
仿网易新闻首页翻页视图
## Description
    之前面试被问到网易新闻首页是怎么实现的，太紧张没答好，回来后仔细想了想，并动手实现了一下
```objective-c
- (NSUInteger)numbersOfPagesInPageView:(WKPageView *)pageView;
/**
 *  数据源方法，获取当前index的cell
 *
 *  @param pageView 翻页视图
 *  @param index    cell的序号
 *
 *  @return WKPageCell
 */
- (WKPageCell *)pageView:(WKPageView *)pageView cellForIndex:(NSInteger)index;
/**
 *  数据源方法，获取当前menuView的items标题，以NSArray的形式
 *
 *  @param pageView 翻页视图
 *
 *  @return menuView的items的标题 (字符串，用NSArray封装)
 */
- (NSArray *)menuItemsForMenuViewInPageView:(WKPageView *)pageView;
```
