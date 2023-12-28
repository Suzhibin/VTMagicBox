//
//  VTScrollController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/12/28.
//

#import "VTScrollController.h"
#import "VTGridViewController.h"
#import "VTScrollView.h"
@interface VTScrollController ()
@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, strong)VTScrollView *headerView;
@property (nonatomic, strong)VTScrollView *footerView;
@end

@implementation VTScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.magicView.layoutStyle=VTLayoutStyleDivide;
    [self createScrollView];
    [self generateTestData];
    [self.magicView reloadData];
}
#pragma mark - functional methods
- (void)generateTestData {
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:5];
    for (int index = 0; index < 5; index++) {
        NSString *title = [NSString stringWithFormat:@"省份%d", index];
        MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
        [menuList addObject:menu];
    }
    _menuList = menuList;
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
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    MenuInfo *menuInfo = _menuList[pageIndex];
    static NSString *gridId = @"grid.identifier";
    VTGridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[VTGridViewController alloc] init];
    }
    viewController.menuInfo = menuInfo;
    return viewController;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    [self.headerView scrollViewToBeScroll:scrollView.contentOffset];
    [self.footerView scrollViewToBeScroll:scrollView.contentOffset];
}


- (void)createScrollView{
    self.magicView.headerHidden=NO;
    self.magicView.headerHeight=120;
    VTScrollView *headerView=[[VTScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    headerView.images=@[@"image_0",@"image_1",@"image_2",@"image_3",@"image_4"];//等于menuList个数
    [self.magicView.headerView addSubview:headerView];
    self.headerView=headerView;
    
    self.magicView.footerHidden=NO;
    self.magicView.footerHeight=80;
    VTScrollView *footerView=[[VTScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footerView.images=@[@"image_5",@"image_6",@"image_7",@"image_8",@"image_9"];//等于menuList个数
    [self.magicView.footerView addSubview:footerView];
    self.footerView=footerView;

}


@end
