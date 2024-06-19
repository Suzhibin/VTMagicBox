//
//  VTCustomMenuBarCell.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/17.
//

#import "VTCustomMenuBarCell.h"
@interface VTCustomMenuBarCell()
@property(nonatomic,strong)UILabel *tilteLabel;
@end
@implementation VTCustomMenuBarCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}
- (void)setModel:(VTCustomMenuBarModel *)model{
    _model = model;
    self.tilteLabel.text = model.text;
    if(model.isSele==YES){
        self.tilteLabel.textColor = [UIColor redColor];
    }else{
        self.tilteLabel.textColor = [UIColor grayColor];
    }
}
- (void)createUI{
    [self.contentView addSubview:self.tilteLabel];

}
- (UILabel*)tilteLabel{
    if(!_tilteLabel){
        _tilteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 44)];
        _tilteLabel.textColor = [UIColor grayColor];
        _tilteLabel.font=[UIFont systemFontOfSize:16];
        _tilteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tilteLabel;
}
@end
