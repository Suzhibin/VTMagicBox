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

    if(item.type==VTDemoTypeNormal||item.type==VTDemoTypeHeader||item.type==VTDemoTypeFooter||item.type==VTDemoTypeHideNav||item.type==VTDemoTypeBottom||item.type==VTDemoTypeBottomDivide){
        VTHomeViewController *homeVC=[[VTHomeViewController alloc]init];
        homeVC.type=item.type;
        homeVC.title=item.title;
        [self.navigationController pushViewController:homeVC animated:YES];
    }else if(item.type==VTDemoTypeCenter||item.type==VTDemoTypeRight||item.type==VTDemoTypeSegmentedControl){
        VTCenterViewController *centerVC = [[VTCenterViewController alloc] init];
        centerVC.type=item.type;
        centerVC.title=item.title;
        [self.navigationController pushViewController:centerVC animated:YES];
    }else if(item.type==VTDemoTypeDivide||item.type==VTDemoTypeSliderTriangle){
        VTDivideViewController *divideVC = [[VTDivideViewController alloc] init];
        divideVC.type=item.type;
        divideVC.title=item.title;
        [self.navigationController pushViewController:divideVC animated:YES];
    } else if(item.type==VTDemoTypeSliderLine||item.type==VTDemoTypeSliderBubble||item.type==VTDemoTypeSliderBubbleSelect||item.type==VTDemoTypeSliderBubbleShadow||item.type==VTDemoTypeSliderSquare||item.type==VTDemoTypeSliderCircle||item.type==VTDemoTypeSliderImage||item.type==VTDemoTypeSliderItmeLine||item.type==VTDemoTypeSliderRandomColor){
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
    }else if(item.type==VTDemoTypeBindList){
        VTBindListViewController*bindListVC = [[VTBindListViewController alloc] init];
        bindListVC.title=item.title;
        [self.navigationController pushViewController:bindListVC animated:YES];
    }else if(item.type==VTDemoTypeMenuMTAtt){
        VTMTAttViewController*mtattVC = [[VTMTAttViewController alloc] init];
        mtattVC.title=item.title;
        [self.navigationController pushViewController:mtattVC animated:YES];
    }else if(item.type==VTDemoTypeOneController||item.type==VTDemoTypeAllController){
        VTLoadAllViewController *allVC = [[VTLoadAllViewController alloc]init];
        allVC.title=item.title;
        allVC.type=item.type;
        [self.navigationController pushViewController:allVC animated:YES];
    }else if(item.type==VTDemoTypeMenuScreening){
        VTScreeningViewController *screeningVC= [[VTScreeningViewController alloc]init];
        screeningVC.title=item.title;
        [self.navigationController pushViewController:screeningVC animated:YES];
    }else if(item.type==VTDemoTypeSwift){
        SwiftExampleViewController *swift=[[SwiftExampleViewController alloc]init];
        swift.title=item.title;
        [self.navigationController pushViewController:swift animated:YES];
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
             [VTTableItem itemWithTitle:@"居中" descr:@"右侧按钮可以切换page" type:VTDemoTypeCenter],
             [VTTableItem itemWithTitle:@"平分" descr:@"定位到指定页面,右侧按钮调 滑块选中状态" type:VTDemoTypeDivide],
             [VTTableItem itemWithTitle:@"居右" descr:@"描述" type:VTDemoTypeRight],
             [VTTableItem itemWithTitle:@"隐藏菜单" descr:@"招聘app职位详情常用，左右切换" type:VTDemoTypeHideNav],
             [VTTableItem itemWithTitle:@"居底部" descr:@"菜单在底部。常规位置所有设置通用" type:VTDemoTypeBottom],
             [VTTableItem itemWithTitle:@"居底部代替tabbar" descr:@"可平分、居中、居左、居右。常规位置所有设置通用" type:VTDemoTypeBottomDivide],
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
            [VTTableItem itemWithTitle:@"WebView" descr:@"描述" type:VTDemoTypeWebView],
            [VTTableItem itemWithTitle:@"第一个menu固定左侧" descr:@"leftNavigatoinItem，navigationInset,同时定位到指定页面" type:VTDemoTypeFirstFixed],
            [VTTableItem itemWithTitle:@"与列表绑定" descr:@"电商分类常用，使用时不需要创建子页面" type:VTDemoTypeBindList],
            [VTTableItem itemWithTitle:@"子页面复用,响应事件" descr:@"子页面复用，父视图通知子视图响应事件" type:VTDemoTypeOneController],
            [VTTableItem itemWithTitle:@"子页面不复用，响应事件" descr:@"所有子页面都是单独创建的，父视图通知子视图响应事件" type:VTDemoTypeAllController],
            [VTTableItem itemWithTitle:@"Swift" descr:@"Swift 使用VTMagic" type:VTDemoTypeSwift]
    ];
}
@end
