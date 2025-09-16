//
//  VTMenuItem.m
//  VTMagic
//
//  Created by tianzhuo on 7/8/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTMenuItem.h"
#import <VTMagicBox/VTMagic.h>

@interface VTMenuItem()

@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UIView *verticalLineView;
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation VTMenuItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dotHidden = YES;
        _dotView = [[UIView alloc] init];
        _dotView.translatesAutoresizingMaskIntoConstraints = NO;
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.layer.masksToBounds = YES;
        _dotView.layer.cornerRadius = 4.f;
        _dotView.hidden = _dotHidden;
        [self addSubview:_dotView];
        
        _verticalLineHidden = YES;
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _verticalLineView.backgroundColor = [UIColor redColor];
        _verticalLineView.hidden = _verticalLineHidden;
        [self addSubview:_verticalLineView];
        
        
        _numberHidden = YES;
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _numberLabel.backgroundColor = [UIColor redColor];
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.layer.cornerRadius = 18/2;
        _numberLabel.text=@"12";
        _numberLabel.textColor=[UIColor whiteColor];
        _numberLabel.font=[UIFont systemFontOfSize:10];
        _numberLabel.textAlignment=NSTextAlignmentCenter;
        _numberLabel.hidden = _numberHidden;
        [self addSubview:_numberLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_dotView(8)]-20-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_dotView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_dotView(8)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_dotView)]];
    
    _verticalLineView.frame=CGRectMake(self.frame.size.width-1, 12, 1, 20);
  
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_numberLabel(18)]-16-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_numberLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_numberLabel(18)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_numberLabel)]];
    [super updateConstraints];
}

- (void)vtm_prepareForReuse {
    VTLog(@"menuItem will be reused: %@", self);
}

#pragma mark - accessor methods
- (void)setDotHidden:(BOOL)dotHidden {
    _dotHidden = dotHidden;
    _dotView.hidden = dotHidden;
}

- (void)setVerticalLineHidden:(BOOL)verticalLineHidden{
    _verticalLineHidden=verticalLineHidden;
    _verticalLineView.hidden=verticalLineHidden;
}

- (void)setNumberHidden:(BOOL)numberHidden{
    _numberHidden=numberHidden;
    _numberLabel.hidden=numberHidden;
}
- (void)setNumberText:(NSString *)numberText{
    _numberText=numberText;
    _numberLabel.text=numberText;
}
@end
