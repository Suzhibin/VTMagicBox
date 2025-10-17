//
//  MainViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/1/18.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "MainViewController.h"
#import "VTHomeViewController.h"
#import "VTBubbleViewController.h"
#import "VTCenterViewController.h"
#import "VTDivideViewController.h"
#import "VTDataViewController.h"
#import "VTMenuViewController.h"
#import "VTDetailViewController.h"
#import "VTBindListViewController.h"
#import "VTSectionModel.h"
#import "VTSliderViewController.h"
#import "VTMTAttViewController.h"
#import "VTLoadAllViewController.h"
#import "VTScreeningViewController.h"
#import "VTMagicBoxDemo-swift.h"
#import "VTShowController.h"
#import "VTScrollController.h"
#import "VTSliderCustomAnimationController.h"
#import "VTVerticalViewController.h"
#import "VTGKViewController.h"
#import "VTJXCategoryViewController.h"
@interface MainViewController ()
@property (nonatomic, strong) NSArray <VTSectionModel *>*list;
@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"VTMagicBox";
 
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
   
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *cellID = @"mainCell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.detailTextLabel.textColor=[UIColor grayColor];
        cell.detailTextLabel.numberOfLines=2;
    }
    VTTableItem *item=self.list[indexPath.section].items[indexPath.row];;
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text=item.descr;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@(%ld)",self.list[section].title,self.list[section].items.count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VTTableItem *item=self.list[indexPath.section].items[indexPath.row];
    
    if(item.type==VTDemoTypeNormal||item.type==VTDemoTypeHeader||item.type==VTDemoTypeFooter||item.type==VTDemoTypeHideNav||item.type==VTDemoTypeBottom||item.type==VTDemoTypeBottomDivide||item.type==VTDemoTypeAlphaNav){
        VTHomeViewController *homeVC=[[VTHomeViewController alloc]init];
        homeVC.type=item.type;
        homeVC.title=item.title;
        [self.navigationController pushViewController:homeVC animated:YES];
    }else if(item.type==VTDemoTypeCenter||item.type==VTDemoTypeRight||item.type==VTDemoTypeSegmentedControl){
        VTCenterViewController *centerVC = [[VTCenterViewController alloc] init];
        centerVC.type=item.type;
        centerVC.title=item.title;
        [self.navigationController pushViewController:centerVC animated:YES];
    }else if(item.type==VTDemoTypeDivide||item.type==VTDemoTypeSliderTriangle||item.type==VTDemoTypeSliderHideMenu||item.type==VTDemoTypeSliderPageControl){
        VTDivideViewController *divideVC = [[VTDivideViewController alloc] init];
        divideVC.type=item.type;
        divideVC.title=item.title;
        [self.navigationController pushViewController:divideVC animated:YES];
    } else if(item.type==VTDemoTypeSliderLine||item.type==VTDemoTypeSliderBubble||item.type==VTDemoTypeSliderBubbleSelect||item.type==VTDemoTypeSliderBubbleShadow||item.type==VTDemoTypeSliderSquare||item.type==VTDemoTypeSliderCircle||item.type==VTDemoTypeSliderImage||item.type==VTDemoTypeSliderItmeLine||item.type==VTDemoTypeSliderRandomColor||item.type==VTDemoTypeSliderZoom||item.type==VTDemoTypeSliderDotZoom){
        VTSliderViewController *sliderVC = [[VTSliderViewController alloc] init];
        sliderVC.type=item.type;
        sliderVC.title=item.title;
        [self.navigationController pushViewController:sliderVC animated:YES];
    }else if(item.type==VTDemoTypeFirstFixed||item.type==VTDemoTypeMenuGIf){
        VTBubbleViewController *bubbleVC = [[VTBubbleViewController alloc] init];
        bubbleVC.type=item.type;
        bubbleVC.title=item.title;
        [self.navigationController pushViewController:bubbleVC animated:YES];
    }else if(item.type==VTDemoTypeMenuImage||item.type==VTDemoTypeMenuImageTop||item.type==VTDemoTypeMenuImageBottom||item.type==VTDemoTypeMenuImageLeft||item.type==VTDemoTypeMenuImageRight||item.type==VTDemoTypeMenuMTText||item.type==VTDemoTypeMenuScale||item.type==VTDemoTypeMenuFont||item.type==VTDemoTypeMenuVLine||item.type==VTDemoTypeMenuNavigationImage){
        VTMenuViewController *bubbleVC = [[VTMenuViewController alloc] init];
        bubbleVC.type=item.type;
        bubbleVC.title=item.title;
        [self.navigationController pushViewController:bubbleVC animated:YES];
    }else if (item.type==VTDemoTypeMenuRedDot||item.type==VTDemoTypeMenuNumber){
        VTDetailViewController *detailVC = [[VTDetailViewController alloc] init];
        detailVC.type=item.type;
        detailVC.title=item.title;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if(item.type==VTDemoTypeWebView){
        VTDataViewController*dataVC = [[VTDataViewController alloc] init];
        dataVC.title=item.title;
        [self.navigationController pushViewController:dataVC animated:YES];
    }else if(item.type==VTDemoTypeBindListNormal||item.type==VTDemoTypeBindListLeft){
        VTBindListViewController*bindListVC = [[VTBindListViewController alloc] init];
        bindListVC.title=item.title;
        bindListVC.type=item.type;
        [self.navigationController pushViewController:bindListVC animated:YES];
    }else if(item.type==VTDemoTypeMenuMTAtt){
        VTMTAttViewController*mtattVC = [[VTMTAttViewController alloc] init];
        mtattVC.title=item.title;
        mtattVC.type=item.type;
        [self.navigationController pushViewController:mtattVC animated:YES];
    }else if(item.type==VTDemoTypeOneController||item.type==VTDemoTypeAllController){
        VTLoadAllViewController *allVC = [[VTLoadAllViewController alloc]init];
        allVC.title=item.title;
        allVC.type=item.type;
        [self.navigationController pushViewController:allVC animated:YES];
    }else if(item.type==VTDemoTypeMenuScreening||item.type==VTDemoTypeMenuBar){
        VTScreeningViewController *screeningVC= [[VTScreeningViewController alloc]init];
        screeningVC.title=item.title;
        [self.navigationController pushViewController:screeningVC animated:YES];
    }else if(item.type==VTDemoTypeSwift){
        SwiftExampleViewController *swift=[[SwiftExampleViewController alloc]init];
        swift.title=item.title;
        [self.navigationController pushViewController:swift animated:YES];
    }else if (item.type==VTDemoTypeShow){
        VTShowController *pager=[[VTShowController alloc]init];
        pager.title=item.title;
        pager.type=item.type;
        [self.navigationController pushViewController:pager animated:YES];
    }else if(item.type==VTDemoTypeScroll){
        VTScrollController*scrollVC=[[VTScrollController alloc]init];
        scrollVC.title=item.title;
        scrollVC.type=item.type;
        [self.navigationController pushViewController:scrollVC animated:YES];
    }else if(item.type==VTDemoTypeSliderCustomAnimation){
        VTSliderCustomAnimationController*customAnimationVC=[[VTSliderCustomAnimationController alloc]init];
        customAnimationVC.title=item.title;
        customAnimationVC.type=item.type;
        [self.navigationController pushViewController:customAnimationVC animated:YES];
    }else if (item.type==VTDemoTypeVerticalLeft||item.type==VTDemoTypeVerticalRight||item.type == VTDemoTypeSliderChunkZoom){
        VTVerticalViewController*vc=[[VTVerticalViewController alloc]init];
        vc.title=item.title;
        vc.type=item.type;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item.type==VTDemoTypeJXCategoryView){
        VTJXCategoryViewController*vc=[[VTJXCategoryViewController alloc]init];
        vc.title=item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item.type==VTDemoTypeGKPageScroll){
        VTGKViewController*vc=[[VTGKViewController alloc]init];
        vc.title=item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray *)list {
    if (!_list) {
        _list = @[[VTSectionModel sectionModeWithTitle:@"布局" items:[self createLayoutItems]],[VTSectionModel sectionModeWithTitle:@"滑块样式" items:[self createSliderItems]],[VTSectionModel sectionModeWithTitle:@"菜单样式" items:[self createMenuItems]],[VTSectionModel sectionModeWithTitle:@"扩展效果" items:[self createCustomItems]]];
    }
    return _list;
}

- (NSArray <VTTableItem *>*)createLayoutItems {
    return @[
            [VTTableItem itemWithTitle:@"常规" descr:@"Header可显示/隐藏" type:VTDemoTypeNormal],
             [VTTableItem itemWithTitle:@"菜单居中" descr:@"右侧按钮可以切换page" type:VTDemoTypeCenter],
             [VTTableItem itemWithTitle:@"菜单平分" descr:@"定位到指定页面,右侧按钮调 滑块选中状态" type:VTDemoTypeDivide],
             [VTTableItem itemWithTitle:@"菜单居右" descr:@"菜单居右布局" type:VTDemoTypeRight],
             [VTTableItem itemWithTitle:@"隐藏菜单" descr:@"招聘app职位详情常用，左右切换" type:VTDemoTypeHideNav],
             [VTTableItem itemWithTitle:@"菜单透明" descr:@"内容页面在菜单后" type:VTDemoTypeAlphaNav],
             [VTTableItem itemWithTitle:@"导航居底部" descr:@"导航在底部。常规位置所有设置通用" type:VTDemoTypeBottom],
             [VTTableItem itemWithTitle:@"导航居底部代替tabbar" descr:@"可平分、居中、居左、居右。常规位置所有设置通用" type:VTDemoTypeBottomDivide],
            [VTTableItem itemWithTitle:@"导航居左侧" descr:@"导航在底部左侧" type:VTDemoTypeVerticalLeft],
            [VTTableItem itemWithTitle:@"导航居右侧" descr:@"导航在底部右侧" type:VTDemoTypeVerticalRight],
            
    ];
}

- (NSArray <VTTableItem *>*)createSliderItems {
    return @[
        [VTTableItem itemWithTitle:@"横线" descr:@"关键属性sliderWidth,右侧按钮调 滑块选中状态、位置" type:VTDemoTypeSliderLine],
        [VTTableItem itemWithTitle:@"与title同宽" descr:@"关键属性sliderExtension,右侧按钮调 滑块选中状态、位置" type:VTDemoTypeSliderItmeLine],
        [VTTableItem itemWithTitle:@"气泡" descr:@"VTSliderStyleBubble,右侧按钮调导航边距" type:VTDemoTypeSliderBubble],
        [VTTableItem itemWithTitle:@"气泡+阴影" descr:@"VTSliderStyleBubble,右侧按钮调导航边距" type:VTDemoTypeSliderBubbleShadow],
        [VTTableItem itemWithTitle:@"气泡选中与非选中" descr:@"隐藏自带滑块,使用btn加载背景图片" type:VTDemoTypeSliderBubbleSelect],
        [VTTableItem itemWithTitle:@"方块" descr:@"VTSliderStyleBubble,右侧按钮调导航边距" type:VTDemoTypeSliderSquare],
        [VTTableItem itemWithTitle:@"圆圈" descr:@"自定义sliderView ,右侧按钮调 滑块选中状态、导航边距" type:VTDemoTypeSliderCircle],
        [VTTableItem itemWithTitle:@"图片" descr:@"自定义sliderView view为UIImageView,右侧按钮调 滑块选中状态" type:VTDemoTypeSliderImage],
        [VTTableItem itemWithTitle:@"三角" descr:@"自定义sliderView view为UIImageView,右侧按钮调 滑块选中状态,定位到指定页面" type:VTDemoTypeSliderTriangle],
        [VTTableItem itemWithTitle:@"随机颜色" descr:@"magicView：viewDidAppear代理内设置,右侧按钮调 滑块选中状态、位置" type:VTDemoTypeSliderRandomColor],
        [VTTableItem itemWithTitle:@"横线缩放" descr:@"滑动子页面 横线动画缩放" type:VTDemoTypeSliderZoom],
        [VTTableItem itemWithTitle:@"点缩放" descr:@"滑动子页面 点动画缩放" type:VTDemoTypeSliderDotZoom],
        [VTTableItem itemWithTitle:@"方块缩放" descr:@"滑动子页面 方块动画缩放" type:VTDemoTypeSliderChunkZoom],
        [VTTableItem itemWithTitle:@"展示指示器" descr:@"指示器替换滑块" type:VTDemoTypeSliderPageControl],
        [VTTableItem itemWithTitle:@"只展示滑块" descr:@"隐藏菜单 只展示滑块" type:VTDemoTypeSliderHideMenu],
        [VTTableItem itemWithTitle:@"自定义滑块动画" descr:@"滑动子页面 使用自定义动画代理，可以自己实现滑块动画" type:VTDemoTypeSliderCustomAnimation],
        
    ];
}
- (NSArray <VTTableItem *>*)createMenuItems {
    return @[
            [VTTableItem itemWithTitle:@"图片" descr:@"tilte为空字符串，调整了菜单间隔" type:VTDemoTypeMenuImage],
            [VTTableItem itemWithTitle:@"tilte+图片上" descr:@"需扩展UIButton,Menuitem不可使用复用机制" type:VTDemoTypeMenuImageTop],
            [VTTableItem itemWithTitle:@"tilte+图片下" descr:@"需扩展UIButton,Menuitem不可使用复用机制" type:VTDemoTypeMenuImageBottom],
            [VTTableItem itemWithTitle:@"tilte+图片左" descr:@"需扩展UIButton,Menuitem不可使用复用机制" type:VTDemoTypeMenuImageLeft],
            [VTTableItem itemWithTitle:@"tilte+图片右" descr:@"需扩展UIButton,Menuitem不可使用复用机制" type:VTDemoTypeMenuImageRight],
            [VTTableItem itemWithTitle:@"包含gif" descr:@"某个栏目带gif,Menuitem不可使用复用机制" type:VTDemoTypeMenuGIf],
            [VTTableItem itemWithTitle:@"多行文本" descr:@"菜单按钮位置支持2行，导航高度扩大" type:VTDemoTypeMenuMTText],
            [VTTableItem itemWithTitle:@"多行富文本" descr:@"自定义菜单按钮，导航高度扩大" type:VTDemoTypeMenuMTAtt],
            [VTTableItem itemWithTitle:@"红点" descr:@"需自定义菜单按钮，可单独刷新菜单" type:VTDemoTypeMenuRedDot],
            [VTTableItem itemWithTitle:@"数字" descr:@"需自定义菜单按钮，可单独刷新菜单" type:VTDemoTypeMenuNumber],
            [VTTableItem itemWithTitle:@"缩放" descr:@"不能与字体同时设置" type:VTDemoTypeMenuScale],
            [VTTableItem itemWithTitle:@"字体常规与选中" descr:@"优先级大于缩放" type:VTDemoTypeMenuFont],
            [VTTableItem itemWithTitle:@"竖线分割" descr:@"需自定义菜单按钮" type:VTDemoTypeMenuVLine],
            [VTTableItem itemWithTitle:@"SegmentedControl样式" descr:@"在导航和菜单按钮之间添加View，作为边界，调整滑块的bubbleInset" type:VTDemoTypeSegmentedControl],
            [VTTableItem itemWithTitle:@"导航添加图片" descr:@"在导航与menuBar 之间插入一个图片" type:VTDemoTypeMenuNavigationImage],
            [VTTableItem itemWithTitle:@"筛选" descr:@"默认不选中，菜单与弹窗关联互动" type:VTDemoTypeMenuScreening],
            
    ];
}
- (NSArray <VTTableItem *>*)createCustomItems {
    return @[
            [VTTableItem itemWithTitle:@"Header使用" descr:@"可添加自定义view" type:VTDemoTypeHeader],
            [VTTableItem itemWithTitle:@"Footer使用" descr:@"可添加筛选按钮和自定义view，可调节子页面距离导航的距离" type:VTDemoTypeFooter],
            [VTTableItem itemWithTitle:@"VTMenuBar单独使用" descr:@"VTMenuBar为View级别,可单独使用" type:VTDemoTypeMenuBar],
            [VTTableItem itemWithTitle:@"滑动监听" descr:@"使用监听代理，可以监听视图控制器 滑动事件" type:VTDemoTypeScroll],
            [VTTableItem itemWithTitle:@"WebView" descr:@"描述" type:VTDemoTypeWebView],
            [VTTableItem itemWithTitle:@"第一个menu固定左侧" descr:@"leftNavigatoinItem，navigationInset,同时定位到指定页面" type:VTDemoTypeFirstFixed],
            [VTTableItem itemWithTitle:@"JXCategoryView等第三方导航" descr:@"不使用自带导航，使用第三方或自己封装。 第三方导航与和内容控制器绑定" type:VTDemoTypeJXCategoryView],
            [VTTableItem itemWithTitle:@"导航正常布局与列表绑定" descr:@"电商分类常用，使用时不需要创建子页面" type:VTDemoTypeBindListNormal],
            [VTTableItem itemWithTitle:@"导航左侧布局与列表绑定" descr:@"电商分类常用，使用时不需要创建子页面" type:VTDemoTypeBindListLeft],
            [VTTableItem itemWithTitle:@"子页面复用,响应事件" descr:@"子页面复用，父视图通知子视图响应事件" type:VTDemoTypeOneController],
            [VTTableItem itemWithTitle:@"子页面不复用，响应事件" descr:@"所有子页面都是单独创建的，父视图通知子视图响应事件" type:VTDemoTypeAllController],
            [VTTableItem itemWithTitle:@"Swift" descr:@"Swift 使用VTMagic" type:VTDemoTypeSwift],
            [VTTableItem itemWithTitle:@"GKPageScrollView与TVMagic结合使用" descr:@"大部分主流APP布局" type:VTDemoTypeGKPageScroll],
            [VTTableItem itemWithTitle:@"展示厅" descr:@"自动展示部分功能" type:VTDemoTypeShow],
            
    ];
}
@end
