# YKPageView

## Description
    之前面试被问到网易新闻首页是怎么实现的，太紧张没答好，回来后仔细想了想，并动手实现了一下
    菜单栏标题的字体和颜色都是可动画的，颜色要动画的话，颜色必须是有RGB分量的（比如由RGBA创建）

## How to use
* import `WKPageView`,使用方法类似`UITableView`
* 实现相应的`delegate`和`dataSource`方法，具体如下:

### WKPageViewDataSource
	共2个方法，必须实现
```objective-c
//  用来获取PageCell
- (WKPageCell *)pageView:(WKPageView *)pageView cellForIndex:(NSInteger)index;
//  用来设置menu上的标题，以NSString的形式，用NSArray封装
//  其count即为PageView的page的页数
- (NSArray *)menuItemsForMenuViewInPageView:(WKPageView *)pageView;
```
### WKPageViewDelegate
	用于定制PageView及内部控件，optional
```objective-c
/**
 *  设置menuView的高度，默认为30
 *
 *  @param pageView 当前翻页视图
 *  @param menuView 顶部菜单视图
 *
 *  @return menuView的高度
 */
- (CGFloat)pageView:(WKPageView *)pageView heightForMenuView:(WKMenuView *)menuView;
/**
 *  设置menuView的背景颜色,默认：[UIColor colorWithRed:172.0/255.0 green:165.0/255.0 blue:162.0/255.0 alpha:1.0]
 *  @param pageView 当前翻页视图
 *
 *  @return UIColor
 */
- (UIColor *)backgroundColorOfMenuViewInPageView:(WKPageView *)pageView;
/**
 *  设置菜单栏标题颜色(若要动画必须创建自RGBA,或者某些有RGB分量的UIColor如:redColor,而例如grayColor不行)
 *
 *  @param pageView 当前翻页视图
 *  @param state    分为WKMenuItemTitleColorStateNormal(未选中)/WKMenuItemTitleColorStateSelected(选中)
 *
 *  @return UIColor(RBGA)
 */
- (UIColor *)titleColorOfMenuItemInPageView:(WKPageView *)pageView withState:(WKMenuItemTitleColorState)state;
/**
 *  设置菜单栏标题字体大小(大于零)
 *
 *  @param pageView 当前翻页视图
 *  @param state    分为WKMenuItemTitleSizeStateNormal(未选中)/WKMenuItemTitleSizeStateSelected(选中)
 *
 *  @return 标题字体大小
 */
- (CGFloat)titleSizeOfMenuItemInPageView:(WKPageView *)pageView withState:(WKMenuItemTitleSizeState)state;
/**
 *  设置菜单栏内部item的宽度，默认宽度为60
 *
 *  @param pageView 当前翻页视图
 *  @param index    WKMenuItem的序号，可根据序号定制
 *
 *  @return item的宽度
 */
- (CGFloat)pageView:(WKPageView *)pageView widthForMenuItemAtIndex:(NSInteger)index;
```
## Final
	有什么问题欢迎联系我，有什么错误或者值得改进的地方希望各位前辈多多指教:)

效果图如下，背景，字体颜色及大小都是可定制的：<br>
![Example](https://github.com/wangmchn/YKPageView/blob/master/Example.gif)

你可以像网易新闻这样：<br>
![EastNet](https://github.com/wangmchn/YKPageView/blob/master/eastnet.gif)

你当然也可以就将它这么放到你的项目中：<br>
![CosChat](https://github.com/wangmchn/YKPageView/blob/master/CosChat.gif)
