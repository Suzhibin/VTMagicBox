//
//  VTScrollView.h
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTScrollView : UIView
@property(nonatomic,strong)NSArray *images;
- (void)scrollViewToBeScroll:(CGPoint)contentOffSet;
@end

NS_ASSUME_NONNULL_END
