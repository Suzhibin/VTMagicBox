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
    self.magicView.againstStatusBar =YES;
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
    self.magicView.navigationWidth = 80;
    self.magicView.separatorHidden = YES;
    self.magicView.displayCentered = YES;
    self.magicView.sliderStyle = VTSliderStyleBubble;
    self.magicView.bubbleRadius = 5;
    self.magicView.bubbleSize = CGSizeMake(60, 30);

    [self generateTestData];
    
    self.magicView.headerHidden = NO;
    
    self.magicView.footerHidden = NO;
}


@end
