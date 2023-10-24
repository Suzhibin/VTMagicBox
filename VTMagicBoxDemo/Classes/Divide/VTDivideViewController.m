//
//  VTDivideViewController.m
//  VTMagic
//
//  Created by tianzhuo on 6/1/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTDivideViewController.h"
#import "VTGridViewController.h"
#import <VTMagicBox/VTMagic.h>

@interface VTDivideViewController()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, strong)UIPageControl *pageControl;
@end

@implementation VTDivideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    self.view.backgroundColor = [UIColor whiteColor];
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicView.switchStyle = VTSwitchStyleStiff;
    self.magicView.needPreloading = NO;
    if(self.type==VTDemoTypeDivide||self.type==VTDemoTypeSliderTriangle){
        self.magicView.navigationHeight = 44.f;
        self.magicView.againstStatusBar = YES;
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [self configCustomSlider];
        [self integrateComponents];
    }else if(self.type==VTDemoTypeSliderHideMenu){
        UIView *bjView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
        bjView.backgroundColor=[UIColor yellowColor];
        [self.magicView setNavigationSubview:bjView];
        self.magicView.navigationHeight = 5;
        self.magicView.sliderColor= [UIColor orangeColor];
        self.magicView.sliderHeight=3;
    }else if (self.type==VTDemoTypeSliderPageControl){
        self.magicView.sliderHidden=YES;
        self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.magicView.footerView.frame.size.width/2-160, 0, 320, 10)];
        [self.magicView.footerView addSubview:self.pageControl];
        self.magicView.footerHeight=15;
        self.magicView.footerView.hidden=NO;
        self.magicView.separatorHidden=YES;
    }
    NSInteger page = 1;
    [self generateTestData];
    if (self.type==VTDemoTypeSliderPageControl){
        self.pageControl.numberOfPages =self.menuList.count;
        self.pageControl.currentPage  = page; //默认
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];//未选中的颜色
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];//选中时的颜色
        [self.pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
     
    }
    [self.magicView reloadDataToPage:page];
    
}
- (void)pageControlChanged:(UIPageControl*)sender{
    [self.magicView switchToPage:sender.currentPage animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.type==VTDemoTypeDivide||self.type==VTDemoTypeSliderTriangle){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    for (MenuInfo *menu in _menuList) {
        [titleList addObject:menu.title];
    }
    return titleList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        if(self.type==VTDemoTypeSliderHideMenu){
            menuItem.hidden=YES;//隐藏菜单
        }
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"grid.identifier";
    VTGridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[VTGridViewController alloc] init];
    }
    viewController.menuInfo = _menuList[pageIndex];
    return viewController;
}
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{
    if (self.type==VTDemoTypeSliderPageControl){
        self.pageControl.currentPage =pageIndex;
    }
}
#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"取消／恢复菜单栏选中状态");
    // select/deselect menu item
    if (self.magicView.isDeselected) {
        [self.magicView reselectMenuItem];
        self.magicView.sliderHidden = NO;
    } else {
        [self.magicView deselectMenuItem];
        self.magicView.sliderHidden = YES;
    }
}
- (void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - functional methods
- (void)generateTestData {
    _menuList = @[[MenuInfo menuInfoWithTitle:@"国内"], [MenuInfo menuInfoWithTitle:@"国外"],
                  [MenuInfo menuInfoWithTitle:@"港澳"], [MenuInfo menuInfoWithTitle:@"台湾"]];
}

- (void)integrateComponents {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    self.magicView.leftNavigatoinItem = leftButton;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}

- (void)configCustomSlider {
    UIImageView *sliderView = [[UIImageView alloc] init];
    [sliderView setImage:[UIImage imageNamed:@"magic_arrow"]];
    sliderView.contentMode = UIViewContentModeScaleAspectFit;
    [self.magicView setSliderView:sliderView];
    self.magicView.sliderHeight = 5.f;
    self.magicView.sliderOffset = -2;
}

@end
