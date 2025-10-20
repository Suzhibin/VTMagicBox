//
//  VTJXCategoryViewController.m
//  VTMagicBoxDemo
//
//  Created by jaco on 2025/10/17.
//

#import "VTJXCategoryViewController.h"
#import "VTRecomViewController.h"
#import "VTGridViewController.h"
#import <JXCategoryView/JXCategoryView.h>
@interface VTJXCategoryViewController ()<JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorBackgroundView *indicatorView;
@end

@implementation VTJXCategoryViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateTestData];
    
    /**
        第三方或自定义仅 支持VTNavPositionDefault、VTNavPositionBottom位置
        原生 menuBar 设置全部失效，需要在第三方或自定义导航上 设置与实现
     */
    
    self.magicView.navPosition=VTNavPositionDefault;
    self.magicView.headerView.backgroundColor=[UIColor greenColor];
    self.magicView.footerView.backgroundColor=[UIColor orangeColor];
    [self.magicView setMenuView:self.categoryView];
    
    NSMutableArray *titleList = [NSMutableArray array];
    for (MenuInfo *menu in self.menuList) {
        [titleList addObject:menu.title];
    }
    self.categoryView.titles =titleList;
    self.categoryView.contentScrollView = self.magicView.contentView; //移动内容视图 绑定 第三方或自定义菜单
    
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
#pragma mark -JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.magicView switchToPage:index animated:YES];//点击绑定内容视图跳转
}
#pragma mark - VTMagicViewDelegate
//- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
//    [self.categoryView selectItemAtIndex:pageIndex];//移动内容视图 绑定 第三方或自定义菜单
//}

- (void)rightNavBtnAction{
//    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [self.magicView setFooterHidden:!self.magicView.isFooterHidden duration:0.25];
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.25];
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
        _categoryView.delegate = self;
        _categoryView.indicators = @[self.indicatorView];
    }
    return _categoryView;
}

- (JXCategoryIndicatorBackgroundView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[JXCategoryIndicatorBackgroundView alloc]init];
        _indicatorView.indicatorWidthIncrement = 30;
        _indicatorView.verticalMargin = 0;
        _indicatorView.indicatorHeight = 30;
        _indicatorView.indicatorCornerRadius = 15;
    }
    return _indicatorView;
}
@end
