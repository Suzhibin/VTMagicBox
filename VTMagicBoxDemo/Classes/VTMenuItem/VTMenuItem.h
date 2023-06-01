//
//  VTMenuItem.h
//  VTMagic
//
//  Created by tianzhuo on 7/8/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTMenuItem : UIButton


/**
 *  是否需要隐藏小圆点，默认YES
 */
@property (nonatomic, assign) BOOL dotHidden;

/**
 *  是否需要隐藏竖线，默认YES
 */
@property (nonatomic, assign) BOOL verticalLineHidden;

/**
 *  数字是否需要隐藏，默认YES
 */
@property (nonatomic, assign) BOOL numberHidden;

/**
 *  数字刷新
 */
@property (nonatomic, assign) NSString * numberText;
@end
