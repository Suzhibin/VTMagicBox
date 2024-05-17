//
//  VTCustomMenuBarModel.h
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTCustomMenuBarModel : NSObject
@property(nonatomic,assign)BOOL isSele;//是否选中
@property(nonatomic,copy)NSString * text;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
