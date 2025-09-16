//
//  UIScrollView+VTMagic.m
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "UIScrollView+VTMagic.h"

@implementation UIScrollView (VTMagic)

- (BOOL)vtm_isNeedDisplayWithFrame:(CGRect)frame isVertical:(BOOL)isVertical preloading:(BOOL)preloading {
    if(isVertical==YES){
        CGRect visibleRect = (CGRect){CGPointMake(0, self.contentOffset.y), self.frame.size};
        CGRect intersectRegion = CGRectIntersection(frame, visibleRect);
        BOOL isOnScreen =  !CGRectIsNull(intersectRegion) || !CGRectIsEmpty(intersectRegion);
        if (!preloading) {
            BOOL isNotBorder = 0 != (int)self.contentOffset.y%(int)self.frame.size.height;
            return isOnScreen && (isNotBorder ?: 0 != intersectRegion.size.height);
        }
        return isOnScreen;
    }else{
        CGRect visibleRect = (CGRect){CGPointMake(self.contentOffset.x, 0), self.frame.size};
        CGRect intersectRegion = CGRectIntersection(frame, visibleRect);
        BOOL isOnScreen =  !CGRectIsNull(intersectRegion) || !CGRectIsEmpty(intersectRegion);
        if (!preloading) {
            BOOL isNotBorder = 0 != (int)self.contentOffset.x%(int)self.frame.size.width;
            return isOnScreen && (isNotBorder ?: 0 != intersectRegion.size.width);
        }
        return isOnScreen;
    }
}

- (BOOL)vtm_isItemNeedDisplayWithFrame:(CGRect)frame isVertical:(BOOL)isVertical{
    if(isVertical==YES){
        frame.size.height *= 2;
    }else{
        frame.size.width *= 2;
    }
    BOOL isOnScreen = [self vtm_isNeedDisplayWithFrame:frame isVertical:isVertical preloading:YES];
    if (isOnScreen) {
        return YES;
    }
    if(isVertical==YES){
        frame.size.height *= 0.5;
        frame.origin.y -= frame.size.height;
    }else{
        frame.size.width *= 0.5;
        frame.origin.x -= frame.size.width;
    }
    isOnScreen = [self vtm_isNeedDisplayWithFrame:frame isVertical:isVertical preloading:YES];
    return isOnScreen;
}

@end
