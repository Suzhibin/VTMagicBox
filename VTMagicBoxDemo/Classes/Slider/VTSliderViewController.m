//
//  VTSliderViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/4/10.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTSliderViewController.h"
#import "VTMenuItem.h"
#import "VTGridViewController.h"
@interface VTSliderViewController ()
@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, strong) UIView *slider;
@property (nonatomic, assign) NSInteger insetLeft;
@end

@implementation VTSliderViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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

    [self integrateComponents];

    if(self.type==VTDemoTypeSliderLine){
        self.magicView.sliderWidth=20;
        self.magicView.sliderColor =[UIColor redColor];
        [self createNavBtn];
    }else if(self.type==VTDemoTypeSliderItmeLine){
        self.magicView.sliderExtension=0;
        [self createNavBtn];
    }else if(self.type==VTDemoTypeSliderRandomColor){
       //代理中设置
        [self createNavBtn];
    }else if(self.type==VTDemoTypeSliderBubble){
        self.magicView.sliderStyle = VTSliderStyleBubble;
        self.magicView.sliderColor = RGBCOLOR(229, 229, 229);
        self.magicView.bubbleInset = UIEdgeInsetsMake(2, 7, 2, 7);
        self.magicView.bubbleRadius = 10;
        [self createNavBtn];
    }else if(self.type==VTDemoTypeSliderBubbleShadow){
        self.magicView.sliderStyle = VTSliderStyleBubble;
        self.magicView.bubbleInset = UIEdgeInsetsMake(2, 7, 2, 7);
        self.magicView.bubbleRadius = 10;
        UIView *slider = [[UIView alloc] init];
        slider.backgroundColor=RGBCOLOR(229, 229, 229);
        slider.layer.cornerRadius = 13;
        slider.layer.shadowColor = [UIColor blueColor].CGColor;
        slider.layer.shadowRadius = 3;
        slider.layer.shadowOffset = CGSizeMake(3, 4);
        slider.layer.shadowOpacity = 0.6;
        [self.magicView setSliderView:slider];
        [self createNavBtn];
    }else if(self.type==VTDemoTypeSliderBubbleSelect){
        self.magicView.sliderHidden=YES;
    }else if(self.type==VTDemoTypeSliderSquare){
        self.magicView.sliderStyle = VTSliderStyleBubble;
        self.magicView.sliderColor = RGBCOLOR(229, 229, 229);
        self.magicView.bubbleInset = UIEdgeInsetsMake(12, 7, 12, 7);
        self.magicView.bubbleRadius = 0;
        [self createNavBtn];
    }else if (self.type==VTDemoTypeSliderCircle){
        self.magicView.sliderStyle = VTSliderStyleBubble;
        self.magicView.bubbleInset = UIEdgeInsetsMake(4, 15, 4, 15);
        UIView *slider = [[UIView alloc] init];
        slider.layer.borderWidth = 1;
        slider.layer.borderColor = [UIColor blueColor].CGColor;
        slider.layer.masksToBounds = YES;
        slider.layer.cornerRadius = 13;
        [self.magicView setSliderView:slider];
        self.insetLeft=0;
        [self createNavBtn];
    }else if(self.type==VTDemoTypeSliderImage){
        [self configCustomSliderBanner];
    }else if(self.type==VTDemoTypeSliderZoom){
        self.magicView.sliderWidth=20;
        self.magicView.sliderColor =[UIColor redColor];
        self.magicView.sliderStyle=VTSliderStyleDefaultZoom;
        [self createNavBtn];
    }else if(self.type==VTDemoTypeSliderDotZoom){
        self.magicView.sliderWidth=10;
        self.magicView.sliderHeight=10;
        self.magicView.sliderStyle=VTSliderStyleDefaultZoom;
        UIView *slider = [[UIView alloc] init];
        slider.layer.masksToBounds = YES;
        slider.layer.cornerRadius = 5;
        self.magicView.sliderColor=[UIColor redColor];
        [self.magicView setSliderView:slider];
        [self createNavBtn];
    }
    
    [self addNotification];
    [self generateTestData];
    
    [self.magicView reloadData];
    
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
    static NSString *itemIdentifier = @"VTSliderViewIdentifier";
    VTMenuItem *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [VTMenuItem buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        if (self.type==VTDemoTypeSliderCircle){
            [menuItem setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        }else if(self.type==VTDemoTypeSliderBubbleSelect){
            if (@available(iOS 13.0, *)) {
                [menuItem setBackgroundImage:[UIImage systemImageNamed:@"rectangle"] forState:UIControlStateNormal];
            }
            if (@available(iOS 13.0, *)) {
                [menuItem setBackgroundImage:[UIImage systemImageNamed:@"capsule"] forState:UIControlStateSelected];
            }
        }else{
            [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        }
    }
   
    if(self.type==VTDemoTypeMenuVLine){
        menuItem.verticalLineHidden=(_menuList.count-1==itemIndex)?YES:NO;
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
    if(self.type==VTDemoTypeSliderRandomColor){
        self.magicView.sliderColor =[self randomColor];
    }
}

- (void)magicView:(VTMagicView *)magicView scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSLog(@"offsetX：%.2f",offsetX);
}

#pragma mark - actions
- (void)subscribeAction {
    NSLog(@"subscribeAction");
    // against status bar or not
    if (self.type==VTDemoTypeSliderCircle||self.type==VTDemoTypeSliderBubble||self.type==VTDemoTypeSliderSquare||self.type==VTDemoTypeSliderBubbleShadow){
        self.insetLeft=self.insetLeft+10;
        self.magicView.navigationInset=UIEdgeInsetsMake(0, self.insetLeft, 0, 0);
    }else{
        if(self.magicView.sliderOffset==0){
            if(self.type==VTDemoTypeSliderDotZoom){
                self.magicView.sliderOffset=-32;
            }else{
                self.magicView.sliderOffset=-40;
            }
        }else{
            self.magicView.sliderOffset=0;
        }
    }
    [self.magicView reloadMenuTitles];
}
- (void)rightButtonAction{
    NSLog(@"取消／恢复菜单栏选中状态");
    // select/deselect menu item
    if (self.magicView.isDeselected) {
        [self.magicView reselectMenuItem];
        if(self.type!=VTDemoTypeSliderBubbleSelect){
            self.magicView.sliderHidden = NO;
        }
    } else {
        [self.magicView deselectMenuItem];
        self.magicView.sliderHidden = YES;
    }
}
#pragma mark - functional methods
- (void)integrateComponents {
   
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"home_moreIcon"] forState:UIControlStateNormal];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}
- (void)createNavBtn{
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightNavBtn addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.type==VTDemoTypeSliderCircle||self.type==VTDemoTypeSliderBubble||self.type==VTDemoTypeSliderSquare||self.type==VTDemoTypeSliderBubbleShadow){
        [rightNavBtn setTitle:@"导航边距" forState:UIControlStateNormal];
    }else{
        [rightNavBtn setTitle:@"滑块位置" forState:UIControlStateNormal];
    }
    rightNavBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [rightNavBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem];
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
            }else if(self.type==VTDemoTypeSliderImage||self.type==VTDemoTypeSliderBubbleSelect){
                title = [NSString stringWithFormat:@"省份%d", index];
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
- (void)configCustomSliderBanner {
    UIImageView *sliderView = [[UIImageView alloc] init];
    [sliderView setImage:[UIImage imageNamed:@"homeBanner_icon"]];
    sliderView.contentMode = UIViewContentModeScaleAspectFit;
    [self.magicView setSliderView:sliderView];
    self.magicView.sliderHeight = 44.f;
    self.magicView.sliderWidth = 44.f;
    self.magicView.sliderOffset = -2;
}
- (UIColor*)randomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}

@end
