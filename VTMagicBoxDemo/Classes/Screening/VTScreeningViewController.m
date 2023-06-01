//
//  VTScreeningViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/5/30.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTScreeningViewController.h"
#import "UIButton+ZBKit.h"
@interface VTScreeningViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, assign) NSInteger index;
@end

@implementation VTScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;//从导航下方布局
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];

    [self.magicController.magicView deselectMenuItem];//取消菜单item的选中状态
    
    self.menuList = [NSArray arrayWithObjects:@"筛选1", @"筛选2",@"筛选3",@"筛选3",@"排序", nil];
    [self.magicController.magicView reloadMenuTitles];
}


#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.menuList;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:12];
        [menuItem setImage:[UIImage imageNamed:@"grayArrow"] forState:UIControlStateNormal];
        [menuItem setImage:[UIImage imageNamed:@"orangeArrow"] forState:UIControlStateSelected];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [menuItem layoutButtonWithEdgeInsetsStyle:ZBUIButtonEdgeInsetsStyleRight space:2];
    });
  
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    return nil;
}
- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{
    NSString *title=[self.menuList objectAtIndex:itemIndex];
    [self deselectMenuItemAtIndex:itemIndex];
    NSLog(@"点击:%ld",itemIndex);
    self.index=itemIndex;

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deselectMenuItemAtIndex:self.index];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self deselectMenuItemAtIndex:self.index];
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];;
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark - 菜单按钮 选中/取消选中
- (void)deselectMenuItemAtIndex:(NSUInteger)itemIndex{
    if (self.magicController.magicView.isDeselected) {
        [self.magicController.magicView reselectMenuItem];
    }else{
        if(self.index==itemIndex){
            [self.magicController.magicView deselectMenuItem];
            //可隐藏或删除筛选视图
        }
    }
}
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.sliderHidden=YES;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.navigationHeight = 44.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}
- (void)updateViewConstraints {
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}
@end
