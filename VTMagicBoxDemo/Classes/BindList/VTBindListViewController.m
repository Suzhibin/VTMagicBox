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
@interface VTBindListViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    if(self.type == VTDemoTypeBindListLeft){
        self.magicView.navPosition = VTNavPositionLeft;
        self.tableView.frame = CGRectMake(100, 0, self.view.frame.size.width-100, self.view.frame.size.height);
    }else{
        self.magicView.navPosition = VTNavPositionDefault;
        self.magicView.navigationHeight = 40.f;
    }
    
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = RGBCOLOR(169, 37, 37);
    self.magicView.switchStyle = VTSwitchStyleStiff;
    self.magicView.needPreloading=NO;
    self.magicView.sliderExtension = 2.f;
    self.magicView.displayCentered = YES;

    [self.view addSubview:self.tableView];
    self.sectionRectArray=[[NSMutableArray alloc]init];
    
    [self lastSectionContentInset];//最后一个Section  ContentInset调整
    [self generateTestData];
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
        if(self.type == VTDemoTypeBindListLeft){
            CGFloat value = self.view.bounds.size.height+self.magicView.navigationWidth- lastSectionHeight;
            if (value > 0) {
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, value, 0);
            }
        }else{
            CGFloat value = self.view.bounds.size.height+self.magicView.navigationHeight- lastSectionHeight;
            if (value > 0) {
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, value, 0);
            }
        }
       
    });
}
#pragma mark - VTMagicViewDataSource
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    return nil;
}
#pragma mark - VTMagicViewDelegate
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
    [self.magicView switchToPage:firstIndexPath.section animated:YES];
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.magicView.navigationHeight, self.view.frame.size.width, self.view.frame.size.height-self.magicView.navigationHeight) style:UITableViewStyleGrouped];
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


@end
