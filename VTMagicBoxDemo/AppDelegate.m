//
//  AppDelegate.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/6/1.
//

#import "AppDelegate.h"
#import "VTNavigationController.h"
#import "MainViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *mainVC=[[MainViewController alloc]init];
    VTNavigationController *nc=[[VTNavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController =nc;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
