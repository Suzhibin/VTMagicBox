//
//  VTMagicView.h
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014-2016 tianzhuo. All rights reserved.
//  https://github.com/tianzhuo112/VTMagic.git
//

#import <UIKit/UIKit.h>
#import "VTMagicProtocol.h"
#import "VTMagicMacros.h"
#import "VTEnumType.h"

NS_ASSUME_NONNULL_BEGIN

@class VTContentView;
@class VTMagicView;

/****************************************data source****************************************/
@protocol VTMagicViewDataSource <NSObject>

@required
/**
 *  获取所有菜单名，数组中存放字符串类型对象
 *
 *  @param magicView self
 *
 *  @return header数组
 */
- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView;

/**
 *  根据itemIndex加载对应的menuItem
 *
 *  @param magicView self
 *  @param itemIndex 需要加载的菜单索引
 *
 *  @return 当前索引对应的菜单按钮
 */
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex;

/**
 *  根据pageIndex加载对应的页面控制器
 *
 *  @param magicView self
 *  @param pageIndex 需要加载的页面索引
 *
 *  @return 页面控制器
 */
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex;

@end

/****************************************delegate****************************************/
@protocol VTMagicViewDelegate <NSObject>

@optional
/**
 *  视图控制器显示到当前屏幕上时触发
 *
 *  @param magicView      self
 *  @param viewController 当前页面展示的控制器
 *  @param pageIndex      当前控控制器对应的索引
 */
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex;

/**
 *  视图控制器从屏幕上消失时触发
 *
 *  @param magicView      self
 *  @param viewController 消失的视图控制器
 *  @param pageIndex      消失的控制器对应的索引
 */
- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex;

/**
 *  选中导航菜单item时触发
 *
 *  @param magicView self
 *  @param itemIndex menuItem对应的索引
 */
- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex;

/**
 *  根据itemIndex获取对应menuItem的宽度，若返回结果为0，内部将自动计算其宽度
 *  通常情况下只需设置itemSpacing或itemWidth即可
 *
 *  @param magicView self
 *  @param itemIndex menuItem对应的索引
 *
 *  @return menuItem的宽度
 */
- (CGFloat)magicView:(VTMagicView *)magicView itemWidthAtIndex:(NSUInteger)itemIndex;

/**
 *  根据itemIndex获取对应slider的宽度，若返回结果为0，内部将自动计算其宽度
 *  通常情况下只需设置sliderWidth、sliderExtension或bubbleInset即可
 *
 *  @param magicView self
 *  @param itemIndex slider对应的索引
 *
 *  @return slider的宽度
 */
- (CGFloat)magicView:(VTMagicView *)magicView sliderWidthAtIndex:(NSUInteger)itemIndex;

/**
 *  contentView视图控制器左右滑动时触发， 无视 跳页切换，frame是否空等情况
 *
 *  @param magicView self
 *  @param scrollView 内容视图
 */
- (void)magicView:(VTMagicView *)magicView scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 *  sliderView自定义动画，实现此代理，默认动画将无效
 *
 *  @param magicView    self
 *  @param scale        等于 _contentView.contentOffset.x/_contentView.frame.size.width - _currentPage
 *  @param currentFrame slider当前的frame
 *  @param nextFrame    slider新位置的frame
 *  @param sliderView   滑块对象
 */
- (void)magicView:(VTMagicView *)magicView scale:(CGFloat)scale currentFrame:(CGRect)currentFrame nextFrame:(CGRect)nextFrame  sliderView:(UIView *)sliderView;

@end

@interface VTMagicView : UIView

#pragma mark - basic configurations
/****************************************basic configurations****************************************/

/**
 *  数据源
 */
@property (nonatomic, weak, nullable) id<VTMagicViewDataSource> dataSource;

/**
 *  代理
 */
@property (nonatomic, weak, nullable) id<VTMagicViewDelegate> delegate;

/**
 *  主控制器，若delegate遵循协议VTMagicProtocol，则默认与其相同
 *
 *  @warning 若继承或直接实例化VTMagicController，则不需要设置该属性
 */
@property (nonatomic, weak, nullable) UIViewController<VTMagicProtocol> *magicController;

/**
 *  切换样式，默认是VTSwitchStyleDefault
 */
@property (nonatomic, assign) VTSwitchStyle switchStyle;

/**
 *  导航菜单的布局样式
 */
@property (nonatomic, assign) VTLayoutStyle layoutStyle;

/**
 *  导航栏滑块样式，默认显示下划线
 */
@property (nonatomic, assign) VTSliderStyle sliderStyle;

/**
 *  导航栏位置 默认在上
 */
@property (nonatomic, assign) VTNavPosition navPosition;

/**
 *  导航菜单item的预览数，默认为1
 *
 *  @warning displayCentered为YES时，该属性无效
 */
@property (nonatomic, assign) NSUInteger previewItems;


#pragma mark - subviews
/****************************************subviews****************************************/

/**
 *  容器视图
 */
@property (nonatomic, strong, readonly) VTContentView *contentView;

/**
 *  最顶部的头部组件，默认隐藏
 *  若需显示请通过属性headerHidden设置
 */
@property (nonatomic, strong, readonly) UIView *headerView;

/**
 *  navigationView底部组件，默认隐藏
 *  若需显示请通过属性footerHidden设置
 */
@property (nonatomic, strong, readonly) UIView *footerView;

/**
 *  顶部导航视图
 */
@property (nonatomic, strong, readonly) UIView *navigationView;

/**
 *  顶部导航栏左侧视图项
 *  @warning VTPositionStyleDefault VTPositionStyleBottom 有效
 */
@property (nonatomic, strong, nullable) UIView *leftNavigatoinItem;

/**
 *  顶部导航栏右侧视图项
 *  @warning VTPositionStyleDefault VTPositionStyleBottom 有效
 */
@property (nonatomic, strong, nullable) UIView *rightNavigatoinItem;

/**
 *  当前屏幕上已加载的控制器
 */
@property (nonatomic, strong, readonly) NSArray<__kindof UIViewController *> *viewControllers;

/**
 *  自定义滑块视图
 */
- (void)setSliderView:(UIView *)sliderView;

/**
 *  自定义导航分割线视图
 */
- (void)setSeparatorView:(UIView *)separatorView;

/**
 *  在导航与menuBar 之间插入一个view
 */
- (void)setNavigationSubview:(UIView *)navigationSubview;

/**
 *  自定义MenuBar视图，使用后会清除自带导航菜单。
 *  新导航可调用 switchToPage: animated 方法进行内容视图的切换
 *  内容视图可以与自定义视图 使用 magicView: viewDidAppear:方法进行绑定
 */
- (void)setMenuView:(UIView *)view;

#pragma mark - bool configurations
/****************************************bool configurations****************************************/

/**
 *  是否允许页面左右滑动，默认YES
 *  @warning 该属性在VTPositionStyleLeft,VTPositionStyleRight样式下 为是否允许页面上下滑动
 */
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

/**
 *  是否允许导航菜单左右滑动，默认YES
 *  @warning 该属性在VTPositionStyleLeft,VTPositionStyleRight样式下 为是否允许页面上下滑动
 */
@property (nonatomic, assign, getter=isMenuScrollEnabled) BOOL menuScrollEnabled;

/**
 *  是否允许切换，包括左右滑动和点击切换，默认YES
 *  若禁止，则所有切换事件全部无响应，非特殊情况不应修改本属性
 */
@property (nonatomic, assign, getter=isSwitchEnabled) BOOL switchEnabled;

/**
 *  点击导航菜单切换页面时是否需要动画，默认YES
 */
@property (nonatomic, assign, getter=isSwitchAnimated) BOOL switchAnimated;

/**
 *  隐藏滑块
 */
@property (nonatomic, assign, getter=isSliderHidden) BOOL sliderHidden;

/**
 *  隐藏导航分割线
 */
@property (nonatomic, assign, getter=isSeparatorHidden) BOOL separatorHidden;

/**
 *  导航栏item的选中状态是否已被取消，默认NO
 */
@property (nonatomic, assign, readonly, getter=isDeselected) BOOL deselected;

/**
 *  顶部导航栏是否紧贴系统状态栏即是否需要为状态栏留出区域，默认NO
 */
@property (nonatomic, assign, getter=isAgainstStatusBar) BOOL againstStatusBar;

/**
    导航栏位于底部 VTNavPositionBottom样式下
    是否需要为底部留出安全区域，默认NO
 */
@property (nonatomic, assign, getter=isAgainstSafeBottomBar) BOOL againstSafeBottomBar;

/**
 *  是否隐藏头部组件，默认YES
 */
@property (nonatomic, assign, getter=isHeaderHidden) BOOL headerHidden;

/**
 *  是否隐藏尾部组件，默认YES
 */
@property (nonatomic, assign, getter=isFooterHidden) BOOL footerHidden;

/**
 *  显示或隐藏头部组件
 *
 *  @param headerHidden 是否隐藏
 *  @param duration     动画时长
 */
- (void)setHeaderHidden:(BOOL)headerHidden duration:(CGFloat)duration;

/**
 *  显示或隐藏尾部组件
 *
 *  @param footerHidden 是否隐藏
 *  @param duration     动画时长
 */
- (void)setFooterHidden:(BOOL)footerHidden duration:(CGFloat)duration;

/**
 *  是否需要预加载下一页，默认YES，
 *  若为NO，则点击导航菜单和调用switchToPage:animated:方法切换页面时均无动画，
 *  其切换效果与属性switchAnimated为NO时相同
 */
@property (nonatomic, assign) BOOL needPreloading;

/**
 *  是否正在切换中，仅动画切换时为YES
 */
@property (nonatomic, assign, readonly, getter=isSwitching) BOOL switching;

/**
 *  被选中的menuItem是否居中显示，默认NO
 */
@property (nonatomic, assign) BOOL displayCentered;

/**
 *  页面滑到两侧边缘时是否需要反弹效果，默认NO
 */
@property (nonatomic, assign) BOOL bounces;

/**
 *  底部是否需要扩展一个tabbar的高度，设置毛玻璃效果时或许有用，默认NO
 */
@property (nonatomic, assign) BOOL needExtendBottom VT_DEPRECATED_IN("1.2.5");

#pragma mark - color & size configurations
/**************************************color & size**************************************/

/**
 *  内容容器相对导航底部的偏移量，默认0，上偏为负
 * @warning 该属性在VTPositionStyleLeft,VTPositionStyleRight样式下 为内容容器相对导航右侧的偏移量，默认0，左偏为负
 */
@property (nonatomic, assign) CGFloat contentViewOffset;

/**
 *  导航菜单栏的inset，对leftNavigatoinItem和rightNavigatoinItem无效
 */
@property (nonatomic, assign) UIEdgeInsets navigationInset;

/**
 *  顶部导航栏背景色
 */
@property (nonatomic, strong, nullable) UIColor *navigationColor;

/**
 *  顶部导航条的高度，默认是44
 *  @warning 该属性在VTNavPositionDefault,VTNavPositionBottom样式下无效
 */
@property (nonatomic, assign) CGFloat navigationHeight;

/**
 *  顶部导航条的宽度，默认是100
 *  @warning 该属性在VTPositionStyleLeft,VTPositionStyleRight样式下有效
 */
@property (nonatomic, assign) CGFloat navigationWidth;

/**
 *  顶部导航栏底部分割线颜色
 */
@property (nonatomic, strong, nullable) UIColor *separatorColor;

/**
 *  导航栏分割线高度，默认0.5个点
 */
@property (nonatomic, assign) CGFloat separatorHeight;

/**
 *  导航栏分割线宽度，默认屏幕宽度
 *  @warning 该属性在VTPositionStyleLeft,VTPositionStyleRight样式下宽度为0.5
 */
@property (nonatomic, assign) CGFloat separatorWidth;

/**
 *  顶部导航栏滑块颜色
 */
@property (nonatomic, strong, nullable) UIColor *sliderColor;

/**
 *  顶部导航栏滑块高度，默认2
 *
 *  @warning 非VTSliderStyleDefault样式，该属性无效
 */
@property (nonatomic, assign) CGFloat sliderHeight;

/**
 *  顶部导航栏滑块宽度，VTSliderStyleDefault样式下默认与item宽度一致
 *
 *  @warning 非VTSliderStyleDefault样式，该属性无效
 */
@property (nonatomic, assign) CGFloat sliderWidth;

/**
 *  滑块宽度延长量，0表示滑块宽度与文本宽度一致，该属性优先级低于sliderWidth
 *
 *  @warning 非VTSliderStyleDefault样式或sliderWidth有效时，该属性无效
 */
@property (nonatomic, assign) CGFloat sliderExtension;

/**
 *  顶部导航栏滑块相对导航底部的偏移量，默认0，上偏为负
 *
 *  @warning 非VTSliderStyleDefault样式，该属性无效
 */
@property (nonatomic, assign) CGFloat sliderOffset;

/**
 *  气泡相对menuItem文本的edgeInsets，默认(2, 5, 2, 5)
 *
 *  @warning 该属性用于VTSliderStyleBubble样式下
 *  @warning bubbleSize有效时，该属性无效
 */
@property (nonatomic, assign) UIEdgeInsets bubbleInset;

/**
 *  气泡相对menuItem大小，默认不设置,固定宽高，优先级高于bubbleInset
 */
@property (nonatomic, assign) CGSize bubbleSize;

/**
 *  滑块的圆角半径，默认10
 *
 *  @warning 该属性用于VTSliderStyleBubble样式下
 */
@property (nonatomic, assign) CGFloat bubbleRadius;

/**
 *  头部组件的高度默认64
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 *  尾部组件的高度默认64
 */
@property (nonatomic, assign) CGFloat footerHeight;

/**
 *  item之间的实际间距
 */
@property (nonatomic, assign) CGFloat acturalSpacing;

/**
 *  两个导航菜单item文本之间的间距，默认是25，其优先级低于itemWidth
 *  如果菜单item包含图片，则实际间距可能会更小
 *
 *  @warning 该属性在VTLayoutStyleDivide样式下无效
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 *  menuItem被选中时文本的放大倍数，默认1.0
 *  可根据需要设置合适的数值，通常不宜超过1.5
 */
@property (nonatomic, assign) CGFloat itemScale;

/**
 *  自定义item宽度，默认0，当设置改属性时，itemSpacing的设置无效
 *
 *  @warning 该属性在VTLayoutStyleDivide样式下无效
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  自定义item高度，默认44，当设置改属性时，itemSpacing的设置无效
 *
 *  @warning 该属性在VTPositionStyleLeft,VTPositionStyleRight样式下有效
 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  againstSafeBottomBar 设置YES 有效
 *  导航栏位于底部时(导航位置为VTNavPositionBottom)留出安全区域的高度，默认为系统提供的的高度
 */
@property (nonatomic, assign) CGFloat safeBottomHeight;

/**
 *  默认字体大小
 *
 */
@property (nonatomic, strong) UIFont *normalFont;

/**
 *  选中字体大小
 *
 *  @warning 该属性在VTLayoutStyleDivide样式下无效
 */
@property (nonatomic, strong) UIFont *selectedFont;

/**
 *  文本对齐方式
 *
 *  默认居中
 */
@property (nonatomic, assign) UIControlContentHorizontalAlignment contentHorizontalAlignment;



#pragma mark - other properties
/**************************************other properties**************************************/

/**
 *  页面切换事件，用于行为统计
 */
@property (nonatomic, assign, readonly) VTSwitchEvent switchEvent;


#pragma mark - public method
/**************************************public method**************************************/

/**
 *  重新加载所有数据
 */
- (void)reloadData;

/**
 *  重新加载所有数据，同时定位到指定页面，若page越界，则自动修正为0
 *
 *  @param pageIndex 被定位的页面
 */
- (void)reloadDataToPage:(NSUInteger)pageIndex;

/**
 *  更新菜单标题，但不重新加载页面
 *
 *  @warning 仅限于菜单顺序和页数不改变的情况下，一般情况下建议使用reloadData方法
 */
- (void)reloadMenuTitles;

/**
 *  查询可重用menuItem
 *
 *  @param identifier 重用标识
 *
 *  @return 可重用的menuItem
 */
- (nullable __kindof UIButton *)dequeueReusableItemWithIdentifier:(NSString *)identifier;

/**
 *  根据缓存标识获取可重用的UIViewController
 *
 *  @param identifier 缓存重用标识
 *
 *  @return 可重用的UIViewController
 */
- (nullable __kindof UIViewController *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

/**
 *  根据控制器获取对应的页面索引，仅当前显示的和预加载的控制器有相应索引，
 *  若没有找到相应索引则返回NSNotFound
 *
 *  @param viewController 页面控制器
 *
 *  @return 页面索引
 */
- (NSInteger)pageIndexForViewController:(UIViewController *)viewController;

/**
 *  获取索引对应的ViewController
 *  若index超出范围或对应控制器不可见，则返回nil
 *
 *  @param pageIndex 索引
 *
 *  @return UIViewController对象
 */
- (nullable __kindof UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex;

/**
 *  根据索引获取当前页面显示的menuItem，不在窗口上显示的则为nil
 *
 *  @param index 索引
 *
 *  @return 当前索引对应的menuItem
 */
- (nullable __kindof UIButton *)menuItemAtIndex:(NSUInteger)index;

/**
 *  切换到指定页面
 *
 *  @param pageIndex 页面索引
 *  @param animated  是否需要动画执行
 */
- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated;

/**
 *  处理UIPanGestureRecognizer手势，用于解决页面内嵌webView时无法响应手势问题
 *
 *  @param recognizer 手势
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;

/**
 *  取消菜单item的选中状态，可通过属性deselected获取当前状态
 *  取消选中后须调用方法reselectMenuItem以恢复
 */
- (void)deselectMenuItem;

/**
 *  恢复菜单menuItem的选中状态
 */
- (void)reselectMenuItem;

/**
 *  清除所有缓存的页面
 */
- (void)clearMemoryCache;

NS_ASSUME_NONNULL_END

@end
