//
//  VTGKViewController.m
//  VTMagicBoxDemo
//
//  Created by jaco on 2025/9/30.
//

#import "VTGKViewController.h"
#import <GKPageScrollView/GKPageScrollView.h>
#import "VTRecomViewController.h"
@interface VTGKViewController ()<GKPageScrollViewDelegate, VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) GKPageScrollView  *pageScrollView;

@property (nonatomic, strong) UIImageView       *headerView;

@property (nonatomic, strong) UIView            *pageView;

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray           *titles;
@property (nonatomic, strong) NSArray           *childVCs;
@end

@implementation VTGKViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.pageScrollView];
    
    [self.pageScrollView reloadData];
    
    [self.magicController.magicView reloadData];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, VTSTATUSBAR_HEIGHT, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.layer.cornerRadius=22;
    leftButton.layer.masksToBounds=YES;
    leftButton.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.3];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageScrollView.frame = self.view.frame;
}
#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.headerView;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.childVCs;
}
#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.titles;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    return self.childVCs[pageIndex];
}
- (void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载
- (GKPageScrollView *)pageScrollView {
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.mainTableView.bounces = false;
        UIScrollView *scrollView = self.magicController.magicView.contentView;
        _pageScrollView.horizontalScrollViewList = @[scrollView];
    }
    return _pageScrollView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400.0f)];
        _headerView.image=[UIImage imageNamed:@"bg"];
    }
    return _headerView;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = self.magicController.view;
    }
    return _pageView;
}

- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor redColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"详情", @"热门", @"相关", @"聊天"];
    }
    return _titles;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        VTRecomViewController *detailVC = [VTRecomViewController new];
        
        VTRecomViewController *hotVC = [VTRecomViewController new];
        
        VTRecomViewController *aboutVC = [VTRecomViewController new];
        
        VTRecomViewController *chatVC = [VTRecomViewController new];
        
        _childVCs = @[detailVC, hotVC, aboutVC, chatVC];
    }
    return _childVCs;
}

@end
