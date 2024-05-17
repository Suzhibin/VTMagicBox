//
//  VTCustomMenuBar.h
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTCustomMenuBar : UIView
@property(nonatomic,strong)NSArray * titles;
@property (nonatomic, copy)  void(^didSelectItemBlock)(NSUInteger index);
- (void)selectItemAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
