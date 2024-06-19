//
//  VTMenuViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/1/19.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTMenuViewController.h"
#import "VTGridViewController.h"
#import "VTMenuItem.h"
#import "UIButton+ZBKit.h"
@interface VTMenuViewController ()

@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong) UIImageView *navImage;
@end

@implementation VTMenuViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.type==VTDemoTypeMenuMTText){
        self.magicView.navigationHeight = 64;
    }else{
        self.magicView.navigationHeight = 44;
    }
    
    self.magicView.displayCentered = YES;
//    self.magicView.againstStatusBar = YES;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.magicView.headerView.backgroundColor = RGBCOLOR(243, 40, 47);
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.itemSpacing=30;//间距
    self.magicView.sliderWidth=20;

    if(self.type==VTDemoTypeMenuScale){
        //不可设置 normalFont  selectedFont
        self.magicView.itemScale=1.2;
    }else if(self.type==VTDemoTypeMenuFont){
        //normalFont selectedFont 优先级大于 itemScale
        self.magicView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.magicView.navigationInset= UIEdgeInsetsMake(0, 10, 0, 0);//菜单与下发内容左对齐
        self.magicView.normalFont=[UIFont systemFontOfSize:16];
        self.magicView.selectedFont=[UIFont boldSystemFontOfSize:18];
    }else if(self.type==VTDemoTypeMenuImage){
        self.magicView.itemSpacing=60;//间隔
    }else if(self.type==VTDemoTypeMenuNavigationImage){
        UIImageView *navImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.magicView.navigationHeight+kStatusBarHeight)];
        navImage.image=[UIImage imageNamed:@"bg"];
        self.navImage=navImage;
        [self.magicView setNavigationSubview:self.navImage];
        self.magicView.againstStatusBar=YES;//是否需要为状态栏留出区域
        self.magicView.headerHidden=NO;
        UIButton *leftButton=[self createleftButton];
        self.magicView.leftNavigatoinItem =leftButton;
        [self createFooterView];
    }
    [self integrateComponents];
    [self addNotification];
    [self generateTestData];
    
    [self.magicView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.type==VTDemoTypeMenuNavigationImage){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

}
- (void)buttonAction:(UIButton *)sender{
    NSInteger index = arc4random() %12;
    self.navImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"image_%ld",index]];
}
- (void)buttonAction2:(UIButton *)sender{
    if(self.magicView.navPosition==VTNavPositionBottom){
        self.magicView.navPosition=VTNavPositionDefault;
    }else{
        self.magicView.navPosition=VTNavPositionBottom;
    }
    [self.magicView reloadData];
}
- (void)createFooterView{
    self.magicView.footerHeight = 44;
    self.magicView.footerHidden=NO;
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 100, 30)];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"更换导航背景" forState:UIControlStateNormal];
    [button1 setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [button1 setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.magicView.footerView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 6, 100, 30)];
    [button2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"底部布局" forState:UIControlStateNormal];
    [button2 setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [button2 setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.magicView.footerView addSubview:button2];
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
    static NSString *itemIdentifier = @"menuitemIdentifier";
    VTMenuItem *menuItem ;
    if(self.type==VTDemoTypeMenuImageTop||self.type==VTDemoTypeMenuImageBottom||self.type==VTDemoTypeMenuImageLeft||self.type==VTDemoTypeMenuImageRight){
        //图片和文字都有的不在使用复用机制，防止导航滚动图片和title错位
    }else{
        menuItem=[magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    }

    if (!menuItem) {
        menuItem = [VTMenuItem buttonWithType:UIButtonTypeCustom];
        if(self.type==VTDemoTypeMenuImage){
            [menuItem setImage:[UIImage imageNamed:@"magic_search"] forState:UIControlStateNormal];
            [menuItem setImage:[UIImage imageNamed:@"magic_arrow"] forState:UIControlStateSelected];
            
        }else if (self.type==VTDemoTypeMenuScale||self.type==VTDemoTypeMenuFont||self.type==VTDemoTypeMenuVLine||self.type==VTDemoTypeMenuNavigationImage){
            [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
            menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
            [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        } else{
            [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
            menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
            [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
            if(self.type==VTDemoTypeMenuMTText){
                menuItem.titleLabel.numberOfLines=2;
                menuItem.titleLabel.textAlignment=NSTextAlignmentCenter;
            }else{
                [menuItem setImage:[UIImage imageNamed:@"magic_search"] forState:UIControlStateNormal];
                if(self.type==VTDemoTypeMenuImageTop||self.type==VTDemoTypeMenuImageBottom||self.type==VTDemoTypeMenuImageLeft||self.type==VTDemoTypeMenuImageRight){
                    [menuItem setImage:[UIImage imageNamed:@"magic_search"] forState:UIControlStateSelected];
                }
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(self.type==VTDemoTypeMenuImageTop){
                [menuItem layoutButtonWithEdgeInsetsStyle:ZBUIButtonEdgeInsetsStyleTop space:1];
            }else if (self.type==VTDemoTypeMenuImageBottom){
                [menuItem layoutButtonWithEdgeInsetsStyle:ZBUIButtonEdgeInsetsStyleBottom space:1];
            }else if (self.type==VTDemoTypeMenuImageLeft){
                [menuItem layoutButtonWithEdgeInsetsStyle:ZBUIButtonEdgeInsetsStyleLeft space:1];
            }else if (self.type==VTDemoTypeMenuImageRight){
                [menuItem layoutButtonWithEdgeInsetsStyle:ZBUIButtonEdgeInsetsStyleRight space:1];
            }
        });
        if(self.type==VTDemoTypeMenuVLine){
            menuItem.verticalLineHidden=(_menuList.count-1==itemIndex)?YES:NO;
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
  
}
#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"subscribeAction");
    // against status bar or not
//    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
  
    if(self.type==VTDemoTypeMenuNavigationImage){
        if(self.magicView.navPosition==VTNavPositionBottom){
            [self.magicView setFooterHidden:!self.magicView.isFooterHidden duration:0.35];
        }else{
            [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
        }
    }else{
        [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
    }
}

#pragma mark - functional methods
- (void)integrateComponents {
   
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"home_moreIcon"] forState:UIControlStateNormal];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}
- (UIButton *)createleftButton{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    return leftButton;
}
- (void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)generateTestData {
    NSString *title = @"省份";
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:24];
    for (int index = 0; index < 20; index++) {
        if(self.type==VTDemoTypeMenuImage){
            title =@"";
        }else{
            if(self.type==VTDemoTypeMenuMTText){
                title = [NSString stringWithFormat:@"省份\n城市%d", index];
            }else{
                if (index % 2) {
                    title = [NSString stringWithFormat:@"省份%d", index];
                }else{
                    title = [NSString stringWithFormat:@"比较长的名字省份%d", index];
                }
            }
        }
        MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
        [menuList addObject:menu];
    }
    _menuList = menuList;
}

@end
