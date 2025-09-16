//
//  VTSectionModel.m
//  VTMagic
//
//  Created by Suzhibin on 2023/1/19.
//  Copyright © 2023 tianzhuo. All rights reserved.
//

#import "VTSectionModel.h"
@implementation VTTableItem

+ (instancetype)itemWithTitle:(NSString *)title descr:(NSString *)descr type:(VTDemoType)type{
    VTTableItem *model = [[self alloc] init];
    model.title = title;
    model.descr = descr;
    model.type = type;
    return model;
}

@end
@implementation VTSectionModel
+ (instancetype)sectionModeWithTitle:(NSString *)title items:(NSArray <VTTableItem *>*)items {
    VTSectionModel *sectionModel = [[self alloc] init];
    sectionModel.title = title;
    sectionModel.items = items;
    return sectionModel;
}

@end
