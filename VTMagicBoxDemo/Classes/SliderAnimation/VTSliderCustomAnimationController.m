//
//  VTSliderCustomAnimationController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/1/4.
//

#import "VTSliderCustomAnimationController.h"
#import "VTGridViewController.h"
@interface VTSliderCustomAnimationController ()
@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation VTSliderCustomAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.magicView.layoutStyle=VTLayoutStyleDefault;
    self.magicView.sliderWidth=15;
    self.magicView.sliderHeight=6;
    self.magicView.sliderColor = [UIColor redColor];
    [self generateTestData];
    [self.magicView reloadData];
}
#pragma mark - functional methods
- (void)generateTestData {
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:5];
    for (int index = 0; index < 20; index++) {
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
- (void)magicView:(VTMagicView *)magicView scale:(CGFloat)scale currentFrame:(CGRect)currentFrame nextFrame:(CGRect)nextFrame sliderView:(nonnull UIView *)sliderView{
    //随便写的，可自由发挥
    CGRect sliderFrame = sliderView.frame;
    CGFloat fromX = CGRectGetMidX(currentFrame) - sliderFrame.size.width/2.0f;
    CGFloat toX = CGRectGetMidX(nextFrame) - sliderFrame.size.width/2.0f;
    CGFloat progress =scale;
    if (progress > 0) {//向右移动
        if (progress <= 0.5) {
            sliderFrame.origin.y =sliderFrame.origin.y +progress;
            sliderFrame.origin.x = fromX;
            sliderView.frame = sliderFrame;
        }else if (progress >= 0.5) {
            sliderFrame.origin.y =magicView.navigationHeight -progress;
            sliderFrame.origin.x = toX;
            sliderView.frame = sliderFrame;
        }
    }else {//向左移动
        if (progress >= -0.5) {
            sliderFrame.origin.y =sliderFrame.origin.y -progress;
            sliderFrame.origin.x = fromX;
            sliderView.frame = sliderFrame;
        }else if (progress <= -0.5) {
            sliderFrame.origin.y =magicView.navigationHeight +progress;
            sliderFrame.origin.x = toX;
            sliderView.frame = sliderFrame;
        }
    }
}




@end
