//
//  VTBindSectionListrFooterView.m
//  VTMagic
//
//  Created by Suzhibin on 2023/1/29.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTBindSectionListrFooterView.h"

@implementation VTBindSectionListrFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor redColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:18];
    }
    return self;
}


@end
