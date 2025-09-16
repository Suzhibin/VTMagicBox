//
//  MenuInfo.h
//  VTMagic
//
//  Created by tianzhuo on 6/30/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuInfo : NSObject
/**
 *  富文本菜单标题
 */
@property (nonatomic, copy) NSString *attTitle;
/**
 *  菜单标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  菜单id
 */
@property (nonatomic, copy) NSString *menuId;
/**
 *  最近一次刷新时间，自动刷新时间间隔为1h
 */
@property (nonatomic, assign) NSTimeInterval lastTime;

/**
    列表绑定使用
 */
@property (nonatomic, strong)NSMutableArray *listArr;

@property (nonatomic, assign) BOOL subVCChange;//子视图响应

@property (nonatomic, strong)UIColor *color;
/**
 *  根据标题自动生成相应menu
 *
 *  @param title 标题
 *
 *  @return MenuInfo对象
 */
+ (instancetype)menuInfoWithTitle:(NSString *)title;

@end
