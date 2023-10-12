//
//  VTSectionModel.h
//  VTMagic
//
//  Created by Suzhibin on 2023/1/19.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, VTDemoType){
    VTDemoTypeNormal,//正常
    VTDemoTypeCenter,//居中
    VTDemoTypeDivide,//平分
    VTDemoTypeRight,//居右
    VTDemoTypeHideNav,//隐藏导航
    VTDemoTypeBottom,//居底部
    VTDemoTypeBottomDivide,//居底部平分
    VTDemoTypeSliderItmeLine,//常规线
    VTDemoTypeSliderLine,//常规线
    VTDemoTypeSliderBubble,//气泡
    VTDemoTypeSliderBubbleSelect,//气泡选中与非选中
    VTDemoTypeSliderSquare,//方块
    VTDemoTypeSliderCircle,//自定义
    VTDemoTypeSliderImage,//图片
    VTDemoTypeSliderTriangle,//三角
    VTDemoTypeSliderRandomColor,//随机颜色
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
    VTDemoTypeWebView,//Web
    VTDemoTypeFirstFixed,//第一个menu固定左侧
    VTDemoTypeBindList,//与列表绑定
    VTDemoTypeSegmentedControl,//SegmentedControl
    VTDemoTypeOneController,//复用子视图
    VTDemoTypeAllController,//加载所有子视图
    VTDemoTypeSwift,
   
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
