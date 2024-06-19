//
//  VTCenterViewController.m
//  VTMagic
//
//  Created by tianzhuo on 6/1/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTCenterViewController.h"
#import "VTGridViewController.h"
#import <VTMagicBox/VTMagic.h>

#define kSearchBarWidth (60.0f)

@interface VTCenterViewController()<VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) VTGridViewController *topicViewController;
@property (nonatomic, strong) VTGridViewController *forumViewController;
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong)UIView *sbackgroundView;
@property (nonatomic, assign)CGFloat sHeight;
@end

@implementation VTCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sHeight=34;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    [self integrateComponents];
    if(self.type==VTDemoTypeCenter){
        self.magicController.magicView.layoutStyle = VTLayoutStyleCenter;
    }else if(self.type==VTDemoTypeRight){
        self.magicController.magicView.layoutStyle = VTLayoutStyleLast;
    }else if(self.type==VTDemoTypeSegmentedControl){
        self.magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        [self.magicController.magicView setNavigationSubview:self.sbackgroundView];
        self.magicController.magicView.itemSpacing=53;//间隔
        self.magicController.magicView.sliderStyle = VTSliderStyleBubble;
        self.magicController.magicView.sliderColor = [UIColor redColor];
        self.magicController.magicView.bubbleInset = UIEdgeInsetsMake(7, 22, 7, 22);
        self.magicController.magicView.bubbleRadius = (self.sHeight-2)/2;
    }
    [self generateTestData];
    [self.magicController.magicView reloadData];
}
- (UIView *)sbackgroundView{
    if(!_sbackgroundView){
        _sbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-80, VTSTATUSBAR_HEIGHT+5, 160, self.sHeight)];
        _sbackgroundView.layer.borderWidth = 1;
        _sbackgroundView.layer.borderColor = [UIColor redColor].CGColor;
        _sbackgroundView.layer.masksToBounds = YES;
        _sbackgroundView.layer.cornerRadius = self.sHeight/2;
    }
    return _sbackgroundView;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

#pragma mark - functional methods
- (void)integrateComponents {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    self.magicController.magicView.leftNavigatoinItem = leftButton;
    if(self.type==VTDemoTypeCenter||self.type==VTDemoTypeSegmentedControl){
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setImage:[UIImage imageNamed:@"magic_search"] forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        searchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        searchButton.frame = CGRectMake(0, 0, 44, 20);
        [self.magicController.magicView setRightNavigatoinItem:searchButton];
        
        if(self.magicController.magicView.leftNavigatoinItem==nil){
            self.magicController.magicView.navigationInset = UIEdgeInsetsMake(0, kSearchBarWidth, 0, 0);
        }
    }
}

#pragma mark - actions
- (void)searchAction:(UIButton *)sender {
    NSLog(@"searchAction");
    if(self.magicController.currentPage==0){
        [self.magicController switchToPage:1 animated:YES];
    }else{
        [self.magicController switchToPage:0 animated:YES];
    }
}
- (void)leftButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
        if(self.type==VTDemoTypeSegmentedControl){
            [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
            [menuItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }else{
            [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
            [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        }
    
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    MenuInfo *menuInfo = _menuList[pageIndex];
    if ([menuInfo.title isEqualToString:@"专题"]) { // if (0 == pageIndex) {
        return self.topicViewController;
    } else {
        return self.forumViewController;
    }
}

#pragma mark - functional methods
- (void)generateTestData {
    _menuList = @[[MenuInfo menuInfoWithTitle:@"专题"], [MenuInfo menuInfoWithTitle:@"论坛"]];
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
        _magicController.magicView.sliderWidth=20;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 44.f;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (UIViewController *)topicViewController {
    if (!_topicViewController) {
        _topicViewController = [[VTGridViewController alloc] init];
    }
    return _topicViewController;
}

- (VTGridViewController *)forumViewController {
    if (!_forumViewController) {
        _forumViewController = [[VTGridViewController alloc] init];
    }
    return _forumViewController;
}

@end
