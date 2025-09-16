//
//  VTCustomMenuBarViewController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/17.
//

#import "VTCustomMenuBarViewController.h"
#import "VTRecomViewController.h"
#import "VTGridViewController.h"
#import "VTCustomMenuBar.h"
@interface VTCustomMenuBarViewController ()
@property (nonatomic, strong)VTCustomMenuBar *menuBar;
@end

@implementation VTCustomMenuBarViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
// [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateTestData];
    self.magicView.navPosition=VTNavPositionDefault;//自定义菜单 支持所有navPosition位置
    self.magicView.headerView.backgroundColor=[UIColor greenColor];
    self.magicView.footerView.backgroundColor=[UIColor orangeColor];
    self.menuBar=[[VTCustomMenuBar alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    __weak typeof(self) weakSelf = self;
    self.menuBar.didSelectItemBlock = ^(NSUInteger index) {
        [weakSelf.magicView switchToPage:index animated:YES];//点击绑定内容视图跳转
    };

    [self.magicView setMenuView:self.menuBar];

    NSMutableArray *titleList = [NSMutableArray array];
    for (MenuInfo *menu in self.menuList) {
        [titleList addObject:menu.title];
    }
    self.menuBar.titles =titleList;

    UIImageView *navImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44+kSafeBottomHeight)];
    navImage.image=[UIImage imageNamed:@"bg"];
    [self.magicView setNavigationSubview:navImage];
    
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightNavBtn addTarget:self action:@selector(rightNavBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setImage:[UIImage imageNamed:@"home_moreIcon"] forState:UIControlStateNormal];
    rightNavBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem];
    
   
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    [self.menuBar selectItemAtIndex:pageIndex];//移动内容视图 绑定 自定义菜单
}

- (void)rightNavBtnAction{
//    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [self.magicView setFooterHidden:!self.magicView.isFooterHidden duration:0.35];
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}
@end
