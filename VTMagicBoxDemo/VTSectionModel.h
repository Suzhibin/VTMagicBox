//
//  VTSectionModel.h
//  VTMagic
//
//  Created by Suzhibin on 2023/1/19.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, VTDemoType){
    VTDemoTypeNormal,//正常
    VTDemoTypeCenter,//居中
    VTDemoTypeDivide,//平分
    VTDemoTypeRight,//居右
    VTDemoTypeHideNav,//隐藏导航
    VTDemoTypeAlphaNav,//导航透明
    VTDemoTypeBottom,//居底部
    VTDemoTypeBottomDivide,//居底部平分
    VTDemoTypeVerticalLeft,
    VTDemoTypeVerticalRight,
    VTDemoTypeSliderItmeLine,//常规线
    VTDemoTypeSliderLine,//常规线
    VTDemoTypeSliderBubble,//气泡
    VTDemoTypeSliderBubbleSelect,//气泡选中与非选中
    VTDemoTypeSliderBubbleShadow,//气泡阴影
    VTDemoTypeSliderSquare,//方块
    VTDemoTypeSliderCircle,//自定义
    VTDemoTypeSliderImage,//图片
    VTDemoTypeSliderTriangle,//三角
    VTDemoTypeSliderRandomColor,//随机颜色
    VTDemoTypeSliderZoom,//滑块横线缩放
    VTDemoTypeSliderDotZoom,//滑块点缩放
    VTDemoTypeSliderChunkZoom,//滑块方块缩放
    VTDemoTypeSliderPageControl,//pageControl
    VTDemoTypeSliderHideMenu,//隐藏菜单 展示滑块
    VTDemoTypeSliderCustomAnimation,//自定义动画
    VTDemoTypeMenuImage,
    VTDemoTypeMenuImageTop,
    VTDemoTypeMenuImageBottom,
    VTDemoTypeMenuImageLeft,
    VTDemoTypeMenuImageRight,
    VTDemoTypeMenuMTText,//多行文本
    VTDemoTypeMenuMTAtt,//多行富文本
    VTDemoTypeMenuRedDot,//红点
    VTDemoTypeMenuNumber,//数组
    VTDemoTypeMenuScale,//缩放
    VTDemoTypeMenuFont,//字体大小
    VTDemoTypeMenuVLine,//竖线
    VTDemoTypeMenuNavigationImage,//导航图片
    VTDemoTypeMenuScreening,//筛选
    VTDemoTypeMenuGIf,//某个栏目带gif
    VTDemoTypeHeader,//头部布局
    VTDemoTypeFooter,//尾部布局
    VTDemoTypeMenuBar,//使用VTMenuBar
    VTDemoTypeWebView,//Web
    VTDemoTypeFirstFixed,//第一个menu固定左侧
    VTDemoTypeBindListLeft,//左侧与列表绑定
    VTDemoTypeBindListNormal,//与列表绑定
    VTDemoTypeSegmentedControl,//SegmentedControl
    VTDemoTypeOneController,//复用子视图
    VTDemoTypeAllController,//加载所有子视图
    VTDemoTypeSwift,
    VTDemoTypeShow,//展示厅 自动展示部分功能
    VTDemoTypeScroll,//滑动监听
    VTDemoTypeJXCategoryView,
    VTDemoTypeGKPageScroll,
};

@interface VTTableItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descr;
@property (nonatomic, assign) VTDemoType type;

+ (instancetype)itemWithTitle:(NSString *)title descr:(NSString *)descr type:(VTDemoType)type;

@end
@interface VTSectionModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray <VTTableItem *>*items;

+ (instancetype)sectionModeWithTitle:(NSString *)title items:(NSArray <VTTableItem *>*)items;
@end

NS_ASSUME_NONNULL_END
