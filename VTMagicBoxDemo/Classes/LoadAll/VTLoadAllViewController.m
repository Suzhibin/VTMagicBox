//
//  VTLoadAllViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/5/12.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTLoadAllViewController.h"
#import "VTRecomViewController.h"
#import "VTGridViewController.h"
@interface VTLoadAllViewController ()
@property (nonatomic, strong)  NSArray *menuList;
@property (nonatomic, strong) NSMutableArray *childVCs;
@end

@implementation VTLoadAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.magicView.displayCentered = YES;
    [self createRightNavBtn];
    [self generateTestData];
    [self.magicView reloadData];
}
//子视图响应
- (void)rightNavBtnAction:(UIButton *)sender{
    sender.selected=!sender.selected;
    if(self.type==VTDemoTypeAllController){
        //子视图已经全部创建
        if(sender.selected==YES){
            [self.childVCs enumerateObjectsUsingBlock:^(VTRecomViewController  *viewController, NSUInteger idx, BOOL * _Nonnull stop) {
                viewController.subVCChange=YES;
            }];
        }else{
            [self.childVCs enumerateObjectsUsingBlock:^(VTRecomViewController  *viewController, NSUInteger idx, BOOL * _Nonnull stop) {
                viewController.subVCChange=NO;
            }];
        }
    }else {
        //子视图是复用的
        if(sender.selected==YES){
            [_menuList enumerateObjectsUsingBlock:^(MenuInfo *menu, NSUInteger idx, BOOL * _Nonnull stop) {
                menu.subVCChange=YES;
            }];
        }else{
            [_menuList enumerateObjectsUsingBlock:^(MenuInfo *menu, NSUInteger idx, BOOL * _Nonnull stop) {
                menu.subVCChange=NO;
            }];
        }
        [self.magicView reloadData];
    }
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
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    if(self.type==VTDemoTypeAllController){ //子视图已经全部创建
        VTRecomViewController  *viewController=self.childVCs[pageIndex];
        viewController.menuInfo = _menuList[pageIndex];
        return viewController;
    }else{
        //子视图是复用的
        static NSString *gridId = @"grid.identifier";
        VTGridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
        if (!viewController) {
            viewController = [[VTGridViewController alloc] init];
        }
        viewController.menuInfo = _menuList[pageIndex];
        return viewController;
    }
}
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{
  
}
#pragma mark - functional methods
- (void)createRightNavBtn{
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightNavBtn addTarget:self action:@selector(rightNavBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setTitle:@"子视图响应" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    rightNavBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem];
}
#pragma mark - functional methods
- (void)generateTestData {
    NSString *title;
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:20];
    for (int index = 0; index < 20; index++) {
        title = [NSString stringWithFormat:@"省份%d", index];
        MenuInfo *menu = [MenuInfo menuInfoWithTitle:title];
        [menuList addObject:menu];
        if(self.type==VTDemoTypeAllController){
            //子视图已经全部创建
            VTRecomViewController *viewController = [[VTRecomViewController alloc] init];
            [self.childVCs addObject:viewController];
        }else{
            //子视图是复用的
        }
    }
    _menuList = menuList;
}
- (NSMutableArray *)childVCs {
    if (!_childVCs) {
        _childVCs=[[NSMutableArray alloc]init];
    }
    return _childVCs;
}
@end
