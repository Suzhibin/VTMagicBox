//
//  VTShowController.m
//  VTMagicBoxDemo
//
//  Created by 苏志彬 on 2023/10/27.
//

#import "VTShowController.h"

@interface VTShowController ()
@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, weak) NSTimer     *timer;
@property (nonatomic, strong)NSArray *methods;
@property (nonatomic, strong)UILabel *infoLabel;
@end

@implementation VTShowController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    self.magicView.displayCentered = YES;
    self.magicView.againstStatusBar = YES;
    self.magicView.againstSafeAreaBottom = YES;
    //    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    self.magicView.separatorColor = [UIColor brownColor];
    self.magicView.separatorHidden=NO;
    self.magicView.separatorHeight=3;
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.headerView.backgroundColor=[UIColor redColor];
    self.magicView.footerView.backgroundColor=[UIColor orangeColor];
    // [self integrateComponents];
    
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.navigationHeight = 44;
//    self.magicView.positionStyle = VTPositionStyleBottom;
//    self.magicView.contentViewOffset=30;
    self.magicView.sliderHidden=NO;
    self.magicView.sliderColor=[UIColor blackColor];
    self.magicView.sliderOffset=-3;
    self.magicView.sliderWidth=15;
    self.magicView.itemSpacing=30;//间距
   
    [self generateTestData];
    
    [self.magicView reloadData];
    
    [self integrateComponents];
    
    self.methods=@[NSStringFromSelector(@selector(action0)), NSStringFromSelector(@selector(action1)), NSStringFromSelector(@selector(action2)), NSStringFromSelector(@selector(action3)), NSStringFromSelector(@selector(action4)), NSStringFromSelector(@selector(action5)), NSStringFromSelector(@selector(action6)), NSStringFromSelector(@selector(action7)), NSStringFromSelector(@selector(action8)), NSStringFromSelector(@selector(action9)), NSStringFromSelector(@selector(action10)), NSStringFromSelector(@selector(action11)), NSStringFromSelector(@selector(action12)), NSStringFromSelector(@selector(action13)),NSStringFromSelector(@selector(action14))];
    self.infoLabel.text=@"准备展示～～";
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
};
- (void)timerUpdate{
    NSInteger i = arc4random()%self.methods.count;
    [self performAction:self.methods[i]];
}
// 执行action
- (void)performAction:(NSString *)actionString {
    if (!actionString) {
        return;
    }
    SEL selector = NSSelectorFromString(actionString);
    if (![self respondsToSelector:selector]) {
        return;
    }
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
}
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self stopTimer];
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
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem ) {
        menuItem  = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem  setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        menuItem .titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        [menuItem  setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
    }
    return menuItem;
    
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"grid.identifier";
    UIViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[UIViewController alloc] init];
    }
    MenuInfo *menu =[_menuList objectAtIndex:pageIndex];
    viewController.view.backgroundColor = menu.color;
    return viewController;
}
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{
    
}
#pragma mark - actions
- (void)action0{
    if(self.magicView.navigationHeight == 44){
        self.magicView.navigationHeight = 54;
    }else{
        self.magicView.navigationHeight = 44;
    }
    self.infoLabel.text=[NSString stringWithFormat:@"导航高度:%.2f",self.magicView.navigationHeight];
    [self.magicView reloadData];
}
- (void)action1{
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
    if(self.magicView.isHeaderHidden==YES){
        self.infoLabel.text=@"Header隐藏";
    }else{
        self.infoLabel.text=@"Header显示";
    }
}
- (void)action2{
    [self.magicView setFooterHidden:!self.magicView.isFooterHidden duration:0.35];
    if(self.magicView.isFooterHidden==YES){
        self.infoLabel.text=@"Footer隐藏";
    }else{
        self.infoLabel.text=@"Footer显示";
    }
}
- (void)action3{
    if(self.magicView.positionStyle==VTPositionStyleBottom){
        self.magicView.positionStyle=VTPositionStyleDefault;
        self.magicView.againstStatusBar = YES;
    }else{
        self.magicView.positionStyle=VTPositionStyleBottom;
        self.magicView.againstSafeAreaBottom = YES;
    }
    if(self.magicView.positionStyle==VTPositionStyleBottom){
        self.infoLabel.text=@"导航位置底部";
    }else{
        self.infoLabel.text=@"导航位置正常";
    }
    [self.magicView reloadData];
}
- (void)action4{
    NSInteger index = arc4random() %_menuList.count;
    [self.magicView switchToPage:index animated:YES];
    self.infoLabel.text=[NSString stringWithFormat:@"导航菜单切换位置:%ld",index];
}
- (void)action5{
    if(self.magicView.sliderWidth==15){
        self.magicView.sliderWidth=30;
    }else{
        self.magicView.sliderWidth=15;
    }
    self.infoLabel.text=[NSString stringWithFormat:@"滑块宽带:%.2f",self.magicView.sliderWidth];
    [self.magicView reloadMenuTitles];
}
- (void)action6{
    self.magicView.separatorHidden = !self.magicView.separatorHidden;
    if(self.magicView.separatorHidden==YES){
        self.infoLabel.text=@"隐藏分割线";
    }else{
        self.infoLabel.text=@"显示分割线";
    }
    [self.magicView reloadMenuTitles];
}
- (void)action7{
    if(self.magicView.itemSpacing==10){
        self.magicView.itemSpacing=30;
    }else{
        self.magicView.itemSpacing=10;
    }
    self.infoLabel.text=[NSString stringWithFormat:@"菜单item文本之间的间距:%.2f",self.magicView.itemSpacing];
    [self.magicView reloadMenuTitles];
}

- (void)action8{
    self.magicView.navigationColor=[self randomColor];
    self.infoLabel.text=[NSString stringWithFormat:@"切换导航背景颜色"];
}

- (void)action9{
    if(self.magicView.itemScale==1.0){
        self.magicView.itemScale=1.3;
    }else{
        self.magicView.itemScale=1.0;
    }
    self.infoLabel.text=[NSString stringWithFormat:@"选中时文本的放大倍数:%.2f",self.magicView.itemScale];
    
    [self.magicView reloadMenuTitles];
}
- (void)action10{
    if(self.magicView.normalFont>0&&self.magicView.selectedFont>0){
        self.magicView.itemScale=1.0;
    }else{
        self.magicView.normalFont=[UIFont systemFontOfSize:15];
        self.magicView.selectedFont=[UIFont boldSystemFontOfSize:18];
        self.infoLabel.text=[NSString stringWithFormat:@"切换为选中字体大小"];
    }
    [self.magicView reloadMenuTitles];
}
- (void)action11{
    if(self.magicView.sliderOffset==-3){
        self.infoLabel.text=[NSString stringWithFormat:@"滑块位于导航菜单顶部"];
        self.magicView.sliderOffset=-42;
    }else{
        self.magicView.sliderOffset=-3;
        self.infoLabel.text=[NSString stringWithFormat:@"滑块位于导航菜单底部"];
    }
    [self.magicView reloadMenuTitles];
}
- (void)action12{
    if(self.magicView.navigationInset.left==0){
        [self.magicView switchToPage:0 animated:YES];
        self.magicView.navigationInset=UIEdgeInsetsMake(0, self.view.frame.size.width/2, 0, 0);
    }else{
        self.magicView.navigationInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.infoLabel.text=[NSString stringWithFormat:@"导航菜单左侧偏移量:%.2f",self.magicView.navigationInset.left];
    [self.magicView reloadMenuTitles];
}
- (void)action13{
    if(self.magicView.contentViewOffset==0){
        self.magicView.contentViewOffset=30;
    }else{
        self.magicView.contentViewOffset=0;
    }
    self.infoLabel.text=[NSString stringWithFormat:@"内容页面偏移量(%.f)",self.magicView.contentViewOffset];
    [self.magicView reloadData];
}
- (void)action14{
    if(self.magicView.sliderStyle==VTSliderStyleDefault){
        self.magicView.sliderStyle=VTSliderStyleBubble;
        self.magicView.sliderColor = RGBCOLOR(229, 229, 229);
        self.magicView.bubbleInset = UIEdgeInsetsMake(2, 7, 2, 7);
        self.magicView.bubbleRadius = 10;
        self.infoLabel.text=@"导航栏滑块样式 气泡样式";
    }else{
        self.magicView.sliderStyle=VTSliderStyleDefault;
        self.magicView.sliderColor=[UIColor blackColor];
        self.infoLabel.text=@"导航栏滑块样式 下划线";
    }

    [self.magicView reloadMenuTitles];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - functional methods
- (void)integrateComponents {
   
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, 50, 44)];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.backgroundColor=[UIColor whiteColor];
    [self.view addSubview: backButton];
    
    UILabel *infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 350, self.view.frame.size.width-20, 44)];
    infoLabel.textAlignment=NSTextAlignmentCenter;
    infoLabel.backgroundColor=[UIColor whiteColor];
    infoLabel.textColor=[UIColor blackColor];
    [self.view addSubview: infoLabel];
    self.infoLabel=infoLabel;
}
- (void)generateDivideTestData{
    NSString *title = @"省份";
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:4];
    for (int index = 0; index < 4; index++) {
        title = [NSString stringWithFormat:@"省份%d", index];
        MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
        menu.color=[self randomColor];
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
        menu.color=[self randomColor];
        [menuList addObject:menu];
    }
    _menuList = menuList;
}
- (UIColor*)randomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}
@end
