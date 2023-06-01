//
//  VTBubbleViewController.m
//  VTMagic
//
//  Created by tianzhuo on 6/4/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTBubbleViewController.h"
#import "VTGridViewController.h"
#import "VTMenuItem.h"
#import "UIButton+ZBKit.h"
@interface VTBubbleViewController ()

@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, strong) UIView *slider;
@end

@implementation VTBubbleViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightNavBtn addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setImage:[UIImage imageNamed:@"magic_search"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem];
    
    self.magicView.navigationHeight = 44;
    self.magicView.displayCentered = YES;
//    self.magicView.againstStatusBar = YES;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.magicView.headerView.backgroundColor = RGBCOLOR(243, 40, 47);
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.navigationColor = [UIColor whiteColor];
    if(self.type==VTDemoTypeFirstFixed){
        self.magicView.navigationInset=UIEdgeInsetsMake(0, -60, 0, 0);//隐藏第一个菜单  使用left 代替
        self.magicView.sliderWidth=20;
        self.magicView.sliderColor =[UIColor redColor];
        self.magicView.sliderOffset=-1;
        [self integrateComponents];
    }

    [self addNotification];
    [self generateTestData];
    
    [self.magicView reloadDataToPage:2];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification
- (void)addNotification {
    [self removeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
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
    static NSString *itemIdentifier = @"BubbleitemIdentifier";
    VTMenuItem *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [VTMenuItem buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
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
    [UIView animateWithDuration:0.25 animations:^{
        if(pageIndex==0){
            self.slider.hidden=NO;
        }else{
            self.slider.hidden=YES;
        }
    }];
  
}
#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"subscribeAction");
    // against status bar or not
    //self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}
- (void)leftButtonAction:(UIButton *)sender{
    [self.magicView switchToPage:0 animated:YES];
}
#pragma mark - functional methods
- (void)integrateComponents {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
//    [leftButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [leftButton setTitle:@"精选" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.magicView.leftNavigatoinItem = leftButton;
    
    self.slider=[[UIView alloc]initWithFrame:CGRectMake(15, leftButton.frame.size.height-3, 20, 2)];
    self.slider.backgroundColor=[UIColor redColor];
    [leftButton addSubview:self.slider];
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"home_moreIcon"] forState:UIControlStateNormal];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}

- (void)generateTestData {
    NSString *title = @"省份";
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:24];
    for (int index = 0; index < 20; index++) {
        title = [NSString stringWithFormat:@"省份%d", index];
        MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
        [menuList addObject:menu];
    }
    _menuList = menuList;
}

@end
