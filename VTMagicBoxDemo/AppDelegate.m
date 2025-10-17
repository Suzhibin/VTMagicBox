//
//  AppDelegate.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/6/1.
//

#import "AppDelegate.h"
#import "VTNavigationController.h"
#import "MainViewController.h"
#import "VTVerticalViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
#if TARGET_OS_MACCATALYST
    UIWindowScene *windowScene  = self.window.windowScene;
    UITitlebar *titlebar        = windowScene.titlebar;
    titlebar.titleVisibility    = UITitlebarTitleVisibilityHidden;
    windowScene.sizeRestrictions.maximumSize = CGSizeMake(1200, 800);
    windowScene.sizeRestrictions.minimumSize = CGSizeMake(1200, 800);
    VTVerticalViewController *mainVC=[[VTVerticalViewController alloc]init];
    VTNavigationController *nc=[[VTNavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController =nc;
#else
    MainViewController *mainVC=[[MainViewController alloc]init];
    VTNavigationController *nc=[[VTNavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController =nc;
#endif
    [self.window makeKeyAndVisible];
    return YES;
}


@end
