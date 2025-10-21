//
//  ViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTHomeViewController.h"
#import "VTRecomViewController.h"
#import "VTGridViewController.h"
#import "ViewController.h"
@interface VTHomeViewController ()

@property (nonatomic, strong)  NSArray *menuList;

@property (nonatomic, strong)  UIButton *button4;
@property (nonatomic, assign)  CGFloat barHeight;
@property (nonatomic, strong)  UIView *searchView;
@property (nonatomic, strong)  UIButton *leftButton;
@end

@implementation VTHomeViewController

#pragma mark - Lifecycle
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"widthSubviews:%.2f",self.view.frame.size.width);
    self.leftButton.frame = CGRectMake(20, self.barHeight, 44, 44);
    self.searchView.frame =CGRectMake(80, self.barHeight,self.view.frame.size.width-160 , 44);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    

#if TARGET_OS_MACCATALYST
    self.barHeight = 44;
#else
    self.barHeight = kStatusBarHeight;
#endif
    
    //    self.magicView.bounces = YES;
    //    self.magicView.headerHidden = NO;
    //    self.magicView.itemSpacing = 20.f;
    //    self.magicView.switchEnabled = YES;
    //    self.magicView.separatorHidden = NO;
    //    self.magicView.acturalSpacing = 10;
//    self.magicView.headerHeight = self.barHeight+40;
//    self.magicView.navigationHeight = 44;
 
    self.magicView.displayCentered = YES;
    //    self.magicView.sliderExtension = 5.0;
    //    self.magicView.switchStyle = VTSwitchStyleStiff;
    //    self.magicView.navigationInset = UIEdgeInsetsMake(0, 50, 0, 0);
    self.magicView.headerView.backgroundColor =[UIColor whiteColor];
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.layoutStyle = VTLayoutStyleDefault;
 
    if(self.type!=VTDemoTypeBottomDivide){
        [self integrateComponents];
    }
    if(self.type==VTDemoTypeNormal){
        self.magicView.againstStatusBar = YES;
//        self.magicView.headerHidden = NO;
//        self.magicView.headerView.backgroundColor=[UIColor greenColor];
       [self configSeparatorView];
    }else if (self.type==VTDemoTypeHeader){
        self.magicView.againstStatusBar = NO;
        [self createHeaderView];
        [self configSeparatorView];
    }else if (self.type==VTDemoTypeFooter){
        self.magicView.againstStatusBar = YES;
        self.magicView.sliderWidth=20;
        [self createFooterView];
        [self configSeparatorView];
    }else if (self.type==VTDemoTypeHideNav){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.magicView.againstStatusBar = NO;
        self.magicView.navigationView.hidden=YES;
        self.magicView.navigationHeight = 0;
    }else if(self.type==VTDemoTypeBottom){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.magicView.navPosition = VTNavPositionBottom;
        self.magicView.againstSafeBottomBar =YES;
   
        self.magicView.headerHeight = 40;
//        self.magicView.headerHidden = NO;
        self.magicView.headerView.backgroundColor=[UIColor greenColor];
        self.magicView.footerHeight = 64;
//        self.magicView.footerHidden = NO;
        self.magicView.footerView.backgroundColor=[UIColor orangeColor];
        self.magicView.sliderWidth=20;
        [self configSeparatorView];
        self.magicView.navigationView.backgroundColor = [UIColor redColor];
        UIImageView *navImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.magicView.navigationHeight+kSafeBottomHeight)];
        navImage.image=[UIImage imageNamed:@"bg"];
        [self.magicView setNavigationSubview:navImage];
    }else if(self.type == VTDemoTypeBottomDivide){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.magicView.layoutStyle = VTLayoutStyleDivide;
        self.magicView.navPosition = VTNavPositionBottom;
        self.magicView.againstSafeBottomBar =YES;
        self.magicView.safeBottomHeight = IS_IPhoneX_All ? 34 : 0.0;
        self.magicView.sliderWidth=20;
        [self createRightNavBtn];
    }else if(self.type == VTDemoTypeAlphaNav){
        self.magicView.navigationColor = [UIColor clearColor];
        self.magicView.contentViewOffset = -(self.barHeight+60+44);
        self.magicView.separatorHidden=YES;
        self.magicView.sliderHidden = YES;
        self.magicView.itemScale = 1.2;
        self.magicView.headerHidden=NO;
        self.magicView.headerHeight = self.barHeight+60;
        self.magicView.headerView.backgroundColor = [UIColor clearColor];
        self.magicView.navigationHeight = 44;
        self.leftButton=[self createleftButton];
        [self.magicView.headerView addSubview:self.leftButton];
    
        self.searchView=[[UIView alloc]init];
        self.searchView.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.4];
        [self.magicView.headerView addSubview:self.searchView];
    }
    
    [self addNotification];
    [self generateTestData];
    [self.magicView reloadData];
}
#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"subscribeAction");
    // against status bar or not
    if(self.type==VTDemoTypeBottom){
        self.magicView.againstSafeBottomBar = !self.magicView.againstSafeBottomBar;
        self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
        [self.magicView setFooterHidden:!self.magicView.isFooterHidden duration:0.35];
        [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
    }else  if(self.type==VTDemoTypeFooter){
        [self.magicView setFooterHidden:!self.magicView.isFooterHidden];
    }else  if(self.type==VTDemoTypeNormal){
        [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
    }else {
        self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
        [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
    }
        

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type==VTDemoTypeHideNav||self.type==VTDemoTypeBottomDivide){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        if(self.type==VTDemoTypeAlphaNav){
            [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }else{
            [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
            [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        }
   
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    // 默认会自动完成赋值
    //    MenuInfo *menuInfo = _menuList[itemIndex];
    //    [menuItem setTitle:menuInfo.title forState:UIControlStateNormal];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    
    if(self.type==VTDemoTypeAlphaNav){
        static NSString *gridId = @"ViewController.identifier";
        ViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[ViewController alloc] init];
        }
        NSLog(@"pageIndex:%ld",pageIndex);
        viewController.index = pageIndex;
        return viewController;
        
    }else{
        MenuInfo *menuInfo = _menuList[pageIndex];
        if (0 == pageIndex) {
            static NSString *recomId = @"recom.identifier";
            VTRecomViewController *recomViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
            if (!recomViewController) {
                recomViewController = [[VTRecomViewController alloc] init];
            }
            recomViewController.menuInfo = menuInfo;
            return recomViewController;
        }
        
        static NSString *gridId = @"grid.identifier";
        VTGridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[VTGridViewController alloc] init];
        }
        viewController.menuInfo = menuInfo;
        return viewController;
    }
   
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    //    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}


- (void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)buttonAction:(UIButton *)sender{
    if(sender.tag==1000){
        self.magicView.sliderHidden = !self.magicView.sliderHidden;
    }
    if(sender.tag==2000){
        self.magicView.separatorHidden = !self.magicView.separatorHidden;
    }
    if(sender.tag==3000){
        if(self.magicView.sliderOffset==0){
            self.magicView.sliderOffset=-40;
        }else{
            self.magicView.sliderOffset=0;
        }
        [self.magicView reloadMenuTitles];
    }
    if(sender.tag==4000){
        //contentViewOffset 子页面距离导航的距离，设计师的考验
        if(self.magicView.contentViewOffset==0){
            self.magicView.contentViewOffset=arc4random() %30;
        }else{
            self.magicView.contentViewOffset=0;
        }

        [self.button4 setTitle:[NSString stringWithFormat:@"内容偏移量(%.f)",self.magicView.contentViewOffset] forState:UIControlStateNormal];
        [self.magicView reloadData];
    }
}
#pragma mark - functional methods
- (void)generateTestData {
    NSString *title = @"推荐";
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:24];
    [menuList addObject:[MenuInfo menuInfoWithTitle:title]];
    if(self.type==VTDemoTypeBottomDivide){
        for (int index = 0; index < 3; index++) {
            title = [NSString stringWithFormat:@"省份%d", index];
            MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
            [menuList addObject:menu];
        }
    }else{
        for (int index = 0; index < 20; index++) {
            title = [NSString stringWithFormat:@"省份%d", index];
            MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
            [menuList addObject:menu];
        }
    }

    _menuList = menuList;
}
- (UIButton *)createleftButton{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 44)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    if(self.type==VTDemoTypeAlphaNav){
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    }
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];

    return leftButton;
}
- (void)integrateComponents {

    if (self.type==VTDemoTypeHeader){
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"home_moreIcon"] forState:UIControlStateNormal];
        rightButton.center = self.view.center;
        self.magicView.rightNavigatoinItem = rightButton;
    }else{
        if  (self.type==VTDemoTypeAlphaNav){
        }else{
            UIButton *leftButton=[self createleftButton];
            self.magicView.leftNavigatoinItem =leftButton;
            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
            [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
            [rightButton setImage:[UIImage imageNamed:@"home_moreIcon"] forState:UIControlStateNormal];
            rightButton.center = self.view.center;
            self.magicView.rightNavigatoinItem = rightButton;
        }
    }
//    if(self.type==VTDemoTypeNormal){
//        UIButton *leftButton=[self createleftButton];
//        self.magicView.rightNavigatoinItem =leftButton;
//    }else if (self.type==VTDemoTypeBottom){
//       
//    }else

}

- (void)configSeparatorView {
    //    UIImageView *separatorView = [[UIImageView alloc] init];
    //    [self.magicView setSeparatorView:separatorView];
    self.magicView.separatorHeight = 0.5;
    self.magicView.separatorColor = RGBCOLOR(22, 146, 211);
    self.magicView.navigationView.layer.shadowColor = RGBCOLOR(22, 146, 211).CGColor;
    self.magicView.navigationView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.magicView.navigationView.layer.shadowOpacity = 0.8;
    self.magicView.navigationView.clipsToBounds = NO;
}
- (void)createHeaderView{
    self.magicView.headerHidden=NO;
    self.magicView.headerHeight=VTSTATUSBAR_HEIGHT+200;
    self.magicView.headerView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.magicView.headerView.frame.size.width, self.magicView.headerHeight)];
    icon.image=[UIImage imageNamed:@"image_1"];
    icon.userInteractionEnabled=YES;
    [self.magicView.headerView addSubview:icon];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, VTSTATUSBAR_HEIGHT, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.layer.cornerRadius=22;
    leftButton.layer.masksToBounds=YES;
    leftButton.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.3];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [icon addSubview:leftButton];
}
- (void)createFooterView{
    self.magicView.footerHeight = 44;
    self.magicView.footerHidden=NO;

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 80, 30)];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [button1 setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [button1 setTitle:@"隐藏滑块" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    button1.tag=1000;
    [self.magicView.footerView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(90, 6, 80, 30)];
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [button2 setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [button2 setTitle:@"隐藏分割" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    button2.tag=2000;
    [self.magicView.footerView addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(170, 6, 80, 30)];
    [button3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [button3 setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [button3 setTitle:@"滑块位置" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:15];
    button3.tag=3000;
    [self.magicView.footerView addSubview:button3];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(250, 6, 120, 30)];
    [button4 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button4 setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [button4 setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [button4 setTitle:@"内容偏移量(0)" forState:UIControlStateNormal];
    button4.titleLabel.font = [UIFont systemFontOfSize:15];
    button4.tag=4000;
    [self.magicView.footerView addSubview:button4];
    self.button4=button4;
 
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
    line.backgroundColor= RGBCOLOR(22, 146, 211);
    [self.magicView.footerView addSubview:line];
}
- (void)rightNavBtnAction{
    if(self.magicView.layoutStyle == VTLayoutStyleDivide){
        self.magicView.layoutStyle = VTLayoutStyleCenter;
    }else if(self.magicView.layoutStyle == VTLayoutStyleCenter){
        self.magicView.layoutStyle = VTLayoutStyleDefault;
    }else if(self.magicView.layoutStyle == VTLayoutStyleDefault){
        self.magicView.layoutStyle = VTLayoutStyleLast;
    }else{
        self.magicView.layoutStyle = VTLayoutStyleDivide;
    }
    [self.magicView reloadData];
}
- (void)createRightNavBtn{
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightNavBtn addTarget:self action:@selector(rightNavBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setTitle:@"切换菜单布局" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightNavBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem];
}
@end
