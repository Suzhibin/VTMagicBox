//
//  RecomViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-13.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTRecomViewController.h"
#import "VTDetailViewController.h"
#import "VTRecomCell.h"

@interface VTRecomViewController ()

@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, copy)NSString *titleText;
@end

@implementation VTRecomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    self.tableView.scrollsToTop = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, VTTABBAR_HEIGHT, 0);
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    self.tableView.rowHeight = 70.f;
    [self fetchNewsData];
    if(self.subVCChange==YES){
        self.titleText=@"子视图响应改变了标题";
    }else{
        self.titleText=@"标题标题";
    }
    [self.tableView reloadData];
}
- (void)setSubVCChange:(BOOL)subVCChange{
    _subVCChange=subVCChange;
    if(subVCChange==YES){
        self.titleText=@"子视图响应改变了标题";
    }else{
        self.titleText=@"标题标题";
    }
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    VTPRINT_METHOD
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tableView.scrollsToTop = YES;
    VTPRINT_METHOD
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tableView.scrollsToTop = NO;
    VTPRINT_METHOD
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    VTPRINT_METHOD
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VTRecomCell *cell = nil;
    static NSString *cellID = @"cell.Identifier";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[VTRecomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *imageName = [NSString stringWithFormat:@"image_%ld", (long)indexPath.row%13];
    [cell.iconView setImage:[UIImage imageNamed:imageName]];
    cell.titleLabel.text =  self.titleText;
    cell.descLabel.text = @"景点描述景点描述景点描述景点描述景点描述";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VTDetailViewController *detailViewController = [[VTDetailViewController alloc] init];
    detailViewController.hidesBottomBarWhenPushed = YES;
#if TARGET_OS_MACCATALYST
    [self showViewController:detailViewController sender:nil];
#else
    [self.navigationController pushViewController:detailViewController animated:YES];
#endif
}

#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    [self.tableView setContentOffset:CGPointZero];
}

#pragma mark - functional methods
- (void)fetchNewsData {
    _newsList = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 50; index++) {
        [_newsList addObject:[NSString stringWithFormat:@"新闻%ld", (long)index]];
    }
}

@end
