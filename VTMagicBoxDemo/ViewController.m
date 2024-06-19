//
//  ViewController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/6/1.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIImageView *icon;
@end

@implementation ViewController
- (void)viewDidAppear:(BOOL)animated{
    if(self.index>12){
        self.icon.backgroundColor = [UIColor redColor];
    }else{
        NSString *imageStr = [NSString stringWithFormat:@"image_%ld",self.index];
        self.icon.image = [UIImage imageNamed:imageStr];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    icon.image = [UIImage imageNamed:@"image_0"];
    [self.view addSubview:icon];
    self.icon = icon;

}
- (void)setIndex:(NSInteger)index{
    _index=index;
    if(self.index>12){
        self.icon.backgroundColor = [UIColor redColor];
    }else{
        NSString *imageStr = [NSString stringWithFormat:@"image_%ld",self.index];
        self.icon.image = [UIImage imageNamed:imageStr];
    }
}
#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NSLog(@"clear old data if needed:%@", self);
    self.icon.image =nil;
}
@end
