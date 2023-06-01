//
//  VTBindListViewController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/1/29.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTBindListViewController.h"
#import "VTRelateViewController.h"
#import "MenuInfo.h"
#import "VTBindSectionListrFooterView.h"
@interface VTBindListViewController ()<VTMagicViewDataSource, VTMagicViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSMutableArray *menuList;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSValue *> *sectionRectArray;
@end

@implementation VTBindListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//从导航下方布局
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    _menuList = [[NSMutableArray alloc]init];
    [self.view addSubview:self.tableView];
    self.sectionRectArray=[[NSMutableArray alloc]init];
    
    for (int i = 0; i<15; i++) {
        MenuInfo *info=[[MenuInfo alloc]init];
        info.title=[NSString stringWithFormat:@"菜单%d",i];
        NSMutableArray *listArr = [NSMutableArray array];
        for (int j = 0; j <= 10; j ++) {
            [listArr  addObject:[NSString stringWithFormat:@"%@ 具体内容",info.title]];
        }
        info.listArr =listArr;
        [_menuList addObject:info];
    }
  
    [_magicController.magicView reloadMenuTitles];
    
    [self lastSectionContentInset];//最后一个Section  ContentInset调整
}
- (void)lastSectionContentInset{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *rects = [NSMutableArray array];
        CGRect lastHeaderRect = CGRectZero;
        
        CGRect rect = [self.tableView rectForHeaderInSection:self.menuList.count - 1];
        [rects addObject:[NSValue valueWithCGRect:rect]];
        lastHeaderRect = rect;
        
        MenuInfo *menu  = [self.menuList lastObject];
        CGRect lastCellRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow: menu.listArr.count - 1 inSection:self.menuList.count - 1]];
        CGFloat lastSectionHeight = CGRectGetMaxY(lastCellRect) - CGRectGetMinY(lastHeaderRect);
        CGFloat value = self.view.bounds.size.height+self.magicController.magicView.navigationHeight- lastSectionHeight;
        if (value > 0) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, value, 0);
        }
    });
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
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    return nil;
}
- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{
    NSLog(@"点击:%ld",itemIndex);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:itemIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating)) {
        //不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
        return;
    }
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    BOOL dircetionUp = (point.y >= 0);    /// 滑动方向
    NSIndexPath *firstIndexPath = dircetionUp?[self.tableView indexPathsForVisibleRows].lastObject:[self.tableView indexPathsForVisibleRows].firstObject;
    firstIndexPath = [self.tableView indexPathsForVisibleRows].firstObject;
    [self.magicController.magicView switchToPage:firstIndexPath.section animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MenuInfo *menu  = [self.menuList objectAtIndex:section];
    return menu.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *userCell = @"BindSectionListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    MenuInfo *menu  = [self.menuList objectAtIndex:indexPath.section];
    cell.textLabel.text = [menu.listArr objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VTBindSectionListrFooterView *headerView = (VTBindSectionListrFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([VTBindSectionListrFooterView class])];
    MenuInfo *menu  = [self.menuList objectAtIndex:section];
    headerView.textLabel.text = menu.title;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.magicController.magicView.navigationHeight, self.view.frame.size.width, self.view.frame.size.height-self.magicController.magicView.navigationHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[UIView new];
        _tableView.backgroundColor=RGBCOLOR(239, 239, 239);
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        if (@available(iOS 11.0,*))  {
            _tableView.estimatedRowHeight=0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
        [self.tableView registerClass:[VTBindSectionListrFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([VTBindSectionListrFooterView class])];
        
    }
    return _tableView;
}
#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.needPreloading=NO;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.sliderExtension = 2.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.displayCentered = YES;
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
