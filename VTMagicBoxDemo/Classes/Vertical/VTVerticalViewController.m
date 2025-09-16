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
    }else{
        self.magicView.navPosition = VTNavPositionLeft;
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
    self.magicView.sliderStyle = VTSliderStyleBubble;
    self.magicView.bubbleRadius = 5;
    self.magicView.bubbleSize = CGSizeMake(60, 30);
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


@end
