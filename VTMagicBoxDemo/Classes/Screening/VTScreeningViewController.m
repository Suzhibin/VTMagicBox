//
//  VTScreeningViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/5/30.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTScreeningViewController.h"
#import "UIButton+ZBKit.h"
#import <VTMagicBox/VTMenuBar.h>
@interface VTScreeningViewController ()<VTMenuBarDatasource,VTMenuBarDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) VTMenuBar *menuBar;
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, assign) NSInteger index;
@end

@implementation VTScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;//从导航下方布局
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.menuBar];
    [self.menuBar deselectMenuItem];
    self.menuBar.layoutStyle = VTLayoutStyleDivide;
    self.menuList = [NSArray arrayWithObjects:@"筛选1", @"筛选2",@"筛选3",@"筛选4",@"排序", nil];
    self.menuBar.menuTitles =  self.menuList;
    [self.menuBar reloadData];
}

#pragma mark - VTMenuBarDatasource
- (UIButton *)menuBar:(VTMenuBar *)menuBar menuItemAtIndex:(NSUInteger)itemIndex{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [menuBar dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:12];
        [menuItem setImage:[UIImage imageNamed:@"grayArrow"] forState:UIControlStateNormal];
        [menuItem setImage:[UIImage imageNamed:@"orangeArrow"] forState:UIControlStateSelected];
    }
    [menuItem setTitle:_menuList[itemIndex] forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [menuItem layoutButtonWithEdgeInsetsStyle:ZBUIButtonEdgeInsetsStyleRight space:2];
    });
    
    return menuItem;
}
#pragma mark - VTMenuBarDelegate
- (void)menuBar:(VTMenuBar *)menuBar didSelectItemAtIndex:(NSUInteger)itemIndex{
    self.menuBar.currentIndex = itemIndex;
    [self.menuBar updateSelectedItem:YES];
    
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
    if (self.menuBar.isDeselected) {
        [self.menuBar reselectMenuItem];
    }else{
        if(self.index==itemIndex){
            [self.menuBar deselectMenuItem];
            //可隐藏或删除筛选视图
        }
    }
}

- (VTMenuBar *)menuBar {
    if (!_menuBar) {
        _menuBar = [[VTMenuBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _menuBar.backgroundColor = [UIColor whiteColor];
        _menuBar.showsHorizontalScrollIndicator = NO;
        _menuBar.showsVerticalScrollIndicator = NO;
        _menuBar.clipsToBounds = YES;
        _menuBar.scrollsToTop = NO;
        _menuBar.datasource = self;
        _menuBar.delegate = self;
    }
    return _menuBar;
}
@end
