//
//  BaseViewController.h
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/10.
//

#import <VTMagicBox/VTMagic.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : VTMagicController
@property (nonatomic, assign) CGFloat barHeight;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong)  NSArray *menuList;

- (UIColor*)randomColor;

- (void)generateTestData;

- (void)generateTestDataArrCount:(NSInteger)arrCoun;
@end

NS_ASSUME_NONNULL_END

