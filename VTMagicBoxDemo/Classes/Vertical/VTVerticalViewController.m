//
//  VTVerticalViewController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/16.
//

#import "VTVerticalViewController.h"

@interface VTVerticalViewController ()

@end

@implementation VTVerticalViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#if TARGET_OS_MACCATALYST
    [self.navigationController setNavigationBarHidden:YES animated:YES];
#else

#endif
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    if(self.type == VTDemoTypeVerticalRight){
        self.magicView.navPosition = VTNavPositionRight;
        self.magicView.sliderStyle = VTSliderStyleBubble;
        self.magicView.bubbleRadius = 5;
        self.magicView.bubbleSize = CGSizeMake(60, 30);
    }else{
        self.magicView.navPosition = VTNavPositionLeft;
        self.magicView.sliderStyle = VTSliderStyleDefaultZoom;
    }
    if (self.type == VTDemoTypeSliderChunkZoom) {
        [self createNavBtn];
    }
    
//    self.magicView.headerHidden = NO;
//    self.magicView.footerHidden = NO;
//    self.magicView.headerHeight=20;
//    self.magicView.footerHeight=20;
    self.magicView.headerView.backgroundColor = [UIColor redColor];
    self.magicView.footerView.backgroundColor = [UIColor grayColor];
//    self.magicView.navigationInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    self.magicView.separatorHidden = YES;
    self.magicView.displayCentered = YES;

#if TARGET_OS_MACCATALYST
    self.magicView.againstStatusBar =YES;
    self.magicView.navigationWidth = 120;
    UIImageView *navImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,     self.magicView.navigationWidth, self.view.frame.size.height)];
    navImage.image=[UIImage imageNamed:@"bg"];
    [self.magicView setNavigationSubview:navImage];
#else
//    self.magicView.againstStatusBar =YES;
    self.magicView.navigationWidth = 80;
#endif
  
    [self generateTestData];

}

- (void)createNavBtn{
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightNavBtn addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightNavBtn setTitle:@"布局变动" forState:UIControlStateNormal];
    rightNavBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [rightNavBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem];
}
- (void)subscribeAction {
    if (self.magicView.navPosition == VTNavPositionLeft) {
        self.magicView.navPosition = VTNavPositionDefault;
        self.magicView.sliderHeight = 35;
        self.magicView.sliderOffset = -5;
        self.magicView.bubbleRadius = 5;
    } else {
        self.magicView.navPosition = VTNavPositionLeft;
        self.magicView.sliderHeight = 2;
        self.magicView.sliderOffset = 0;
        self.magicView.bubbleRadius = 0;
    }

    [self.magicView reloadDataToPage:0];
}
@end
