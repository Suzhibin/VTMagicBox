//
//  VTMTAttMenuItem.m
//  VTMagic
//
//  Created by Suzhibin on 2023/4/14.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTMTAttMenuItem.h"
@interface VTMTAttMenuItem()

@property (nonatomic, strong) UILabel *topTitleLabel;
@end
@implementation VTMTAttMenuItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.numberOfLines=2;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        _topTitleLabel = [[UILabel alloc] init];
        _topTitleLabel.textAlignment=NSTextAlignmentCenter;
        _topTitleLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:_topTitleLabel];
        [self bringSubviewToFront:_topTitleLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    _topTitleLabel.frame=CGRectMake(0, 15, self.frame.size.width, 17);

    [super updateConstraints];
}

- (void)setTopTitle:(NSString *)topTitle{
    _topTitle=topTitle;
    _topTitleLabel.text=topTitle;
}


@end
