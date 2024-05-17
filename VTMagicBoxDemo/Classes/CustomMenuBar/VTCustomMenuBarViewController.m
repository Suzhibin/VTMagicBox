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
    self.menuBar=[[VTCustomMenuBar alloc]init];
    __weak typeof(self) weakSelf = self;
    self.menuBar.didSelectItemBlock = ^(NSUInteger index) {
        [weakSelf.magicView switchToPage:index animated:YES];//点击绑定内容视图跳转
    };
    [self.magicView setNavigationView:self.menuBar];

    NSMutableArray *titleList = [NSMutableArray array];
    for (MenuInfo *menu in self.menuList) {
        [titleList addObject:menu.title];
    }
    self.menuBar.titles =titleList;

}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    [self.menuBar selectItemAtIndex:pageIndex];//移动内容视图 绑定 自定义菜单
}


@end
