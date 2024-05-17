//
//  VTSliderCustomAnimationController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/1/4.
//

#import "VTSliderCustomAnimationController.h"
#import "VTGridViewController.h"
@interface VTSliderCustomAnimationController ()

@end

@implementation VTSliderCustomAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.magicView.layoutStyle=VTLayoutStyleDefault;
    self.magicView.sliderWidth=15;
    self.magicView.sliderHeight=6;
    self.magicView.sliderColor = [UIColor redColor];
    [self generateTestData];
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView scale:(CGFloat)scale currentFrame:(CGRect)currentFrame nextFrame:(CGRect)nextFrame sliderView:(nonnull UIView *)sliderView{
    //随便写的，可自由发挥
    CGRect sliderFrame = sliderView.frame;
    CGFloat fromX = CGRectGetMidX(currentFrame) - sliderFrame.size.width/2.0f;
    CGFloat toX = CGRectGetMidX(nextFrame) - sliderFrame.size.width/2.0f;
    CGFloat progress =scale;
    if (progress > 0) {//向右移动
        if (progress <= 0.5) {
            sliderFrame.origin.y =sliderFrame.origin.y +progress;
            sliderFrame.origin.x = fromX;
            sliderView.frame = sliderFrame;
        }else if (progress >= 0.5) {
            sliderFrame.origin.y =magicView.navigationHeight -progress;
            sliderFrame.origin.x = toX;
            sliderView.frame = sliderFrame;
        }
    }else {//向左移动
        if (progress >= -0.5) {
            sliderFrame.origin.y =sliderFrame.origin.y -progress;
            sliderFrame.origin.x = fromX;
            sliderView.frame = sliderFrame;
        }else if (progress <= -0.5) {
            sliderFrame.origin.y =magicView.navigationHeight +progress;
            sliderFrame.origin.x = toX;
            sliderView.frame = sliderFrame;
        }
    }
}

@end
