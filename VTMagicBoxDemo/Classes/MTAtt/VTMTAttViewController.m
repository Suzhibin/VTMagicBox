//
//  VTMTAttViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/4/14.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTMTAttViewController.h"
#import "VTMTAttMenuItem.h"
#import "VTGridViewController.h"
@interface VTMTAttViewController ()

@property (nonatomic, strong)  NSArray *menuList;

@end

@implementation VTMTAttViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.magicView.displayCentered = YES;
//    self.magicView.againstStatusBar = YES;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.magicView.headerView.backgroundColor = RGBCOLOR(243, 40, 47);

    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.itemSpacing=30;//间距
    self.magicView.sliderWidth=20;
   // [self integrateComponents];
    [self addNotification];
    
    if(self.type == VTDemoTypeMenuMTAtt){
        self.magicView.navigationHeight = 64;
        self.magicView.sliderStyle = VTSliderStyleBubble;
        self.magicView.sliderColor = RGBCOLOR(229, 229, 229);
        self.magicView.bubbleInset = UIEdgeInsetsMake(9, 7, 7, 7);
        self.magicView.bubbleRadius = 10;
        self.magicView.layoutStyle = VTLayoutStyleDefault;
        [self generateAttTestData];
    }
  
    [self.magicView reloadData];
    
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
    if(self.type == VTDemoTypeMenuMTAtt){
        static NSString *itemIdentifier = @"attMenuitemIdentifier";
        VTMTAttMenuItem *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
        if (!menuItem ) {
            menuItem  = [VTMTAttMenuItem buttonWithType:UIButtonTypeCustom];
            [menuItem  setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
            menuItem .titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
            [menuItem  setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        }
        MenuInfo *menu=[_menuList objectAtIndex:itemIndex];
        menuItem.topTitle=menu.attTitle;
        return menuItem;
    }else{
        static NSString *itemIdentifier = @"menuitemIdentifier";
        UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
        if (!menuItem ) {
            menuItem  = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuItem  setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
            menuItem .titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
            [menuItem  setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        }
        return menuItem;
    }
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
 
}
#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"subscribeAction");
    // against status bar or not
    //self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}

#pragma mark - functional methods
- (void)integrateComponents {
   
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"home_moreIcon"] forState:UIControlStateNormal];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}

- (void)generateAttTestData {
    NSString *province = @"省份";
    NSString *city = @"城市";
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:24];
    for (int index = 0; index < 20; index++) {
        province = [NSString stringWithFormat:@"省份%d", index];
        city= [NSString stringWithFormat:@"\n城市%d", index];
        MenuInfo *menu = [MenuInfo menuInfoWithTitle:city];
        menu.attTitle=province;
        [menuList addObject:menu];
    }
    _menuList = menuList;
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
