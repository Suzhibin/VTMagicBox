//
//  VTMagicMacros.h
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#ifndef VTMagicMacros_h
#define VTMagicMacros_h

/** 自定义Log，日志开关 0-关闭 1-开启 */
#define __LOGDEBUG__ (0)

#if defined(__LOGDEBUG__) && __LOGDEBUG__ && DEBUG
#define VTLog(...) NSLog(__VA_ARGS__)
#else
#define VTLog(...)
#endif

// deprecated macro
#define VT_DEPRECATED_IN(VERSION) __attribute__((deprecated("This property has been deprecated and will be removed in VTMagic " VERSION ".")))

// weakSelf
#define __DEFINE_WEAK_SELF__ __weak __typeof(&*self) weakSelf = self;
#define __DEFINE_STRONG_SELF__ __strong __typeof(&*weakSelf) strongSelf = weakSelf;

// 打印当前方法名
#define VTPRINT_METHOD VTLog(@"==%@:%p running method '%@'==", self.class, self, NSStringFromSelector(_cmd));

// 打印方法运行时间
#define TIME_BEGIN NSDate * startTime = [NSDate date];
#define TIME_END VTLog(@"time interval: %f", -[startTime timeIntervalSinceNow]);

// 设置RGBA颜色值
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(1.f)]
// 十六进制转UIColor
#define kVTColorFromHex(hexValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

// 判断设备是否是iPhone
#define kiPhoneDevice ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define KiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//#warning andi 添加IPhoneX系列及状态栏 宏判断
#define IS_IPhoneX_All \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define kStatusBarHeight \
^(){\
 if (@available(iOS 13.0, *)) {\
     UIStatusBarManager *statusBarManager = [[[UIApplication sharedApplication] windows] objectAtIndex:0].windowScene.statusBarManager;\
     return statusBarManager.statusBarFrame.size.height;\
 }else{\
     return [[UIApplication sharedApplication] statusBarFrame].size.height;\
 }\
}()

#define kSafeBottomHeight \
^(){\
 if (@available(iOS 13.0, *)) {\
     NSSet *set = [UIApplication sharedApplication].connectedScenes;\
     UIWindowScene *windowScene = [set anyObject];\
     UIWindow *window = windowScene.windows.firstObject;\
     return  (CGFloat)window.safeAreaInsets.bottom;\
 }else if (@available(iOS 11.0, *)) {\
     UIWindow *window = [UIApplication sharedApplication].windows.firstObject;\
     return (CGFloat)window.safeAreaInsets.bottom;\
 }else{\
     return (CGFloat)0;\
 }\
}()

// tabbar高度
#define VTTABBAR_HEIGHT (IS_IPhoneX_All?(49.0 + 34.0):(49.0))
// 状态栏高度
#define VTSTATUSBAR_HEIGHT (kStatusBarHeight)

//#define VTSAFEAREA_BOTTOM_HEIGHT (CGFloat)(IS_IPhoneX_All?(34.0):(0.0))
#define VTSAFEAREA_BOTTOM_HEIGHT (CGFloat)(kSafeBottomHeight)
#endif

