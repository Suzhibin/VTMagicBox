//
//  BaseViewController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/10.
//

#import "BaseViewController.h"
#import "VTRecomViewController.h"
#import "VTGridViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#if TARGET_OS_MACCATALYST
    self.color = [UIColor blackColor];
    self.barHeight = 36;
#else
    self.color = [UIColor whiteColor];
    self.barHeight = kStatusBarHeight;
#endif
    self.color = [UIColor whiteColor];
    self.view.backgroundColor = self.color;

 
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

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
        NSLog(@"index:%ld viewDidAppear", (long)pageIndex);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
        NSLog(@"index:%ld viewDidDisappear", (long)pageIndex);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
        NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

#pragma mark - functional methods
- (void)generateTestData{
    [self generateTestDataArrCount:24];
}
- (void)generateTestDataArrCount:(NSInteger)arrCount{
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:25];
    NSString *title;
    for (int index = 0; index < arrCount; index++) {
        if(index==0){
            title = @"推荐";
        }else{
            title = [NSString stringWithFormat:@"省份%d", index];
        }
        MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
        menu.color=[self randomColor];
        NSMutableArray *listArr = [NSMutableArray array];
        for (int j = 0; j <= 10; j ++) {
            [listArr  addObject:[NSString stringWithFormat:@"%@ 具体内容",menu.title]];
        }
        menu.listArr =listArr;
        [menuList addObject:menu];
    }
    _menuList = menuList;
    [self.magicView reloadData];
}

- (void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIColor*)randomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}
@end
