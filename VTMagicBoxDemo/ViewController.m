//
//  ViewController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/6/1.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    icon.image = [UIImage imageNamed:@"image_7"];
    [self.view addSubview:icon];
    
}


@end
