//
//  UIButton+ZBKit.h
//  ZBKit
//
//  Created by Suzhibin on 2019/8/19.
//  Copyright © 2019 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, ZBUIButtonEdgeInsetsStyle) {
    ZBUIButtonEdgeInsetsStyleLeft, // image在左，label在右
    ZBUIButtonEdgeInsetsStyleRight,// image在右，label在左
    ZBUIButtonEdgeInsetsStyleTop, // image在上，label在下
    ZBUIButtonEdgeInsetsStyleBottom // image在下，label在上
    
};
@interface UIButton (ZBKit)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ZBUIButtonEdgeInsetsStyle)style
                                  space:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END
