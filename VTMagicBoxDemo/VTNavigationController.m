//
//  VTNavigationController.m
//  VTMagic
//
//  Created by Suzhibin on 2023/1/17.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTNavigationController.h"

@interface VTNavigationController ()

@end

@implementation VTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationBar.translucent = NO;
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = [UIColor whiteColor];;
        appearance.shadowColor = [UIColor whiteColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:16]};
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
    }else{
        [self.navigationBar setTitleTextAttributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationBar.shadowImage = [UIImage new];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
