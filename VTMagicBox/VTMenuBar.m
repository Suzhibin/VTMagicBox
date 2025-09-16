//
//  VTMenuBar.m
//  VTMagicView
//
//  Created by tianzhuo on 15/1/6.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "VTMenuBar.h"
#import "UIScrollView+VTMagic.h"
#import "VTMagicMacros.h"

static NSInteger const kVTMenuBarTag = 1000;

@interface VTMenuBar()

@property (nonatomic, strong) NSMutableArray *frameList; // frame数组
@property (nonatomic, strong) NSMutableArray *sliderList;   // slider frames
@property (nonatomic, strong) NSMutableDictionary *visibleDict; // 屏幕上可见的items
@property (nonatomic, strong) NSMutableSet *cacheSet; // 缓存池
@property (nonatomic, strong) NSString *identifier; // 重用标识符
@property (nonatomic, strong) NSMutableArray *indexList; // 索引集合
@property (nonatomic, strong) UIFont *itemFont;

@end

@implementation VTMenuBar
@dynamic delegate;

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = 44;
        _itemScale = 1.0;
        _itemSpacing = 25.f;
        _sliderHeight = 2.0f;
        _sliderExtension = CGFLOAT_MAX;
        _bubbleInset = UIEdgeInsetsMake(2, 5, 2, 5);
        _indexList = [[NSMutableArray alloc] init];
        _frameList = [[NSMutableArray alloc] init];
        _sliderList = [[NSMutableArray alloc] init];
        _visibleDict = [[NSMutableDictionary alloc] init];
        _cacheSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL mandatory = _menuTitles.count && !_visibleDict.count;
    if (!mandatory && _needSkipLayout && !self.isDecelerating) {
        return;
    }
    BOOL isVertical = NO;
    if (_navPosition == VTNavPositionLeft||_navPosition == VTNavPositionRight){
        isVertical = YES;
    }
    UIButton *menuItem = nil;
    CGRect frame = CGRectZero;
    NSArray *indexList = [_visibleDict allKeys];
    for (NSNumber *index in indexList) {
        menuItem = _visibleDict[index];
        if([index integerValue] < _frameList.count){
            frame = [_frameList[[index integerValue]] CGRectValue];
        }
        if (![self vtm_isItemNeedDisplayWithFrame:frame isVertical:isVertical]) {
            [menuItem setSelected:NO];
            [menuItem removeFromSuperview];
            [_visibleDict removeObjectForKey:index];
            [_cacheSet addObject:menuItem];
        } else {
            menuItem.selected = NO;
            menuItem.frame = frame;
        }
    }
    
    NSMutableArray *leftIndexList = [_indexList mutableCopy];
    [leftIndexList removeObjectsInArray:indexList];
    for (NSNumber *index in leftIndexList) {
        frame = [_frameList[[index integerValue]] CGRectValue];
        if ([self vtm_isItemNeedDisplayWithFrame:frame isVertical:isVertical]) {
            [self loadItemAtIndex:[index integerValue]];
        }
    }
    
    BOOL transformScale = !self.isDecelerating || !_needSkipLayout;
    [self updateSelectedItem:transformScale];
}

#pragma mark - update menuItem state
- (void)updateSelectedItem:(BOOL)transformScale {
    _selectedItem.selected = NO;
    UIButton *originalItem = _selectedItem;
    _selectedItem = _visibleDict[@(_currentIndex)];
    _selectedItem.selected = _deselected ? NO : YES;
    if(_selectedFont>0&&_normalFont>0){
        [self updateAllFrames];
        [UIView animateWithDuration:0.25 animations:^{
            self.selectedItem.titleLabel.font = self.selectedFont;
            if (![originalItem isEqual:self.selectedItem]) {
                originalItem.titleLabel.font = self.normalFont;
            }
        }];
    }else{
        if (!transformScale || 1.0 == _itemScale) {
            return;
        }
        
        _selectedItem.titleLabel.layer.transform = CATransform3DMakeScale(_itemScale, _itemScale, _itemScale);
        if (![originalItem isEqual:_selectedItem]) {
            originalItem.titleLabel.layer.transform = CATransform3DIdentity;
        }
    }
}

- (void)deselectMenuItem {
    self.deselected = YES;
    _selectedItem.selected = NO;
}

- (void)reselectMenuItem {
    self.deselected = NO;
    _selectedItem.selected = YES;
}

#pragma mark - functional methods
- (void)reloadData {
    [self resetCacheData];
    [self resetItemFrames];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)resetCacheData {
    [_indexList removeAllObjects];
    NSInteger pageCount = _menuTitles.count;
    for (NSInteger index = 0; index < pageCount; index++) {
        [_indexList addObject:@(index)];
    }
    
    NSArray *visibleItems = [_visibleDict allValues];
    for (UIButton *menuItem in visibleItems) {
        [menuItem setSelected:NO];
        [menuItem removeFromSuperview];
        [_cacheSet addObject:menuItem];
    }
    [_visibleDict removeAllObjects];
}

#pragma mark reset item frames
- (void)updateAllFrames {
    // 重置item frame
    [self resetItemFrames];
    
    // 关闭隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // 更新button的frame
    NSInteger count = _frameList.count;
    for (NSInteger index = 0; index < count; index++) {
        NSValue *value = _frameList[index];
        CGRect frame = value.CGRectValue;
        UIButton *menuItem = [self itemAtIndex:index];
        
        if(index == _currentIndex) {
            menuItem.titleLabel.font = _selectedFont;
        } else {
            menuItem.titleLabel.font = _normalFont;
        }
        menuItem.frame = frame;
    }
    [CATransaction commit];
}

- (void)resetItemFrames {
    [_frameList removeAllObjects];
    
    if (!_menuTitles.count) {
        return;
    }
    
    UIButton *menuItem = nil;
    if (!_itemFont) {
        menuItem = [self createItemAtIndex:_currentIndex];
        _itemFont = menuItem.titleLabel.font;
        NSAssert(_itemFont != nil, @"item shouldn't be nil, you must conform VTMagicViewDataSource");
    }
    
    switch (_layoutStyle) {
        case VTLayoutStyleDivide:
            [self resetFramesForDivide];
            break;
        case VTLayoutStyleCenter:
            [self resetFramesForCenter];
            break;
        case VTLayoutStyleLast:
            [self resetFramesForLast];
            break;
        default:
            [self resetFramesForDefault];
            break;
    }
    
    [self resetSliderFrames];
    CGRect lastFrame = [[_frameList lastObject] CGRectValue];
    if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
        CGFloat contentHeight = CGRectGetMaxY(lastFrame);
        contentHeight += _menuInset.bottom;
        self.contentSize = CGSizeMake(0, contentHeight);
    }else{
        CGFloat contentWidth = CGRectGetMaxX(lastFrame);
        contentWidth += _menuInset.right;
        self.contentSize = CGSizeMake(contentWidth, 0);
    }
  
    if (menuItem && _currentIndex < _frameList.count) {
        menuItem.frame = [_frameList[_currentIndex] CGRectValue];
    }
}

- (void)resetFramesForDefault {
    if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
        CGFloat itemHeight = _itemHeight;
        CGRect frame = CGRectZero;
        CGFloat itemY = _menuInset.top;
        CGFloat width = self.frame.size.width;
        width -= _menuInset.left + _menuInset.right;
        for (int index = 0; index < _menuTitles.count; index++) {
            frame = CGRectMake( _menuInset.left, itemY, width, itemHeight);
            [_frameList addObject:[NSValue valueWithCGRect:frame]];
            itemY += frame.size.height + _acturalSpacing;
        }
    }else{
        CGFloat itemWidth = 0;
        NSString *title = nil;
        CGRect frame = CGRectZero;
        CGFloat itemX = _menuInset.left;
        CGFloat height = self.frame.size.height;
        height -= _menuInset.top + _menuInset.bottom;
        for (int index = 0; index < _menuTitles.count; index++) {
            BOOL isSelected = (index == _currentIndex);
            itemWidth = [self itemWidthAtIndex:index];
            if (!itemWidth) {
                title = [_menuTitles objectAtIndex:index];
                itemWidth = _itemWidth ?: ([self sizeWithTitle:title isSelected:isSelected].width + _itemSpacing);
            }
            frame = CGRectMake(itemX, _menuInset.top, itemWidth, height);
            [_frameList addObject:[NSValue valueWithCGRect:frame]];
            itemX += frame.size.width + _acturalSpacing;
        }
    }
}

- (void)resetFramesForDivide {
    if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
        CGRect frame = CGRectZero;
        NSInteger count = _menuTitles.count;
        CGFloat width = self.frame.size.width;
        width -= _menuInset.left + _menuInset.right;
        CGFloat totalSpace = _menuInset.top + _menuInset.bottom;
        totalSpace += 1 < count ? (count - 1) * _acturalSpacing : 0;
        CGFloat itemHeight = (CGRectGetHeight(self.frame) - totalSpace)/count;
        frame.origin = CGPointMake(_menuInset.left, _menuInset.top);
        frame.size = CGSizeMake(width, itemHeight);
        for (int index = 0; index < count; index++) {
            [_frameList addObject:[NSValue valueWithCGRect:frame]];
            frame.origin.y += itemHeight + _acturalSpacing;
        }
    }else{
        CGRect frame = CGRectZero;
        NSInteger count = _menuTitles.count;
        CGFloat height = self.frame.size.height;
        height -= _menuInset.top + _menuInset.bottom;
        CGFloat totalSpace = _menuInset.left + _menuInset.right;
        totalSpace += 1 < count ? (count - 1) * _acturalSpacing : 0;
        CGFloat itemWidth = (CGRectGetWidth(self.frame) - totalSpace)/count;
        frame.origin = CGPointMake(_menuInset.left, _menuInset.top);
        frame.size = CGSizeMake(itemWidth, height);
        for (int index = 0; index < count; index++) {
            [_frameList addObject:[NSValue valueWithCGRect:frame]];
            frame.origin.x += itemWidth + _acturalSpacing;
        }
    }
}

- (void)resetFramesForCenter {
    [self resetFramesForDefault];
    CGFloat itemOffset = 0;
    if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
        CGFloat menuHeight = CGRectGetHeight(self.frame);
        CGRect lastFame = [[_frameList lastObject] CGRectValue];
        CGFloat contentHeight = menuHeight - _menuInset.bottom;
        itemOffset = (contentHeight - CGRectGetMaxY(lastFame))/2;
        if (itemOffset <= 0) {
            return;
        }
    }else{
        CGFloat menuWidth = CGRectGetWidth(self.frame);
        CGRect lastFame = [[_frameList lastObject] CGRectValue];
        CGFloat contentWidth = menuWidth - _menuInset.right;
        itemOffset = (contentWidth - CGRectGetMaxX(lastFame))/2;
        if (itemOffset <= 0) {
            return;
        }
    }

    
    CGRect frame = CGRectZero;
    NSArray *frames = [NSArray arrayWithArray:_frameList];
    [_frameList removeAllObjects];
    for (NSValue *value in frames) {
        frame = [value CGRectValue];
        if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
            frame.origin.y += itemOffset;
        }else{
            frame.origin.x += itemOffset;
        }
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
    }
}
// 居尾部布局下重置frame
- (void)resetFramesForLast{
    [self resetFramesForDefault];
    CGFloat itemOffset = 0;
    if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
        CGFloat menuHeight = CGRectGetHeight(self.frame);
        CGRect lastFame = [[_frameList lastObject] CGRectValue];
        CGFloat contentHeight  = menuHeight - _menuInset.bottom;
        itemOffset = contentHeight - CGRectGetMaxY(lastFame)-8;
        if (itemOffset <= 0) {
            return;
        }
    }else{
        CGFloat menuWidth = CGRectGetWidth(self.frame);
        CGRect lastFame = [[_frameList lastObject] CGRectValue];
        CGFloat contentWidth = menuWidth - _menuInset.right;
        itemOffset = contentWidth - CGRectGetMaxX(lastFame)-8;
        if (itemOffset <= 0) {
            return;
        }
    }
    CGRect frame = CGRectZero;
    NSArray *frames = [NSArray arrayWithArray:_frameList];
    [_frameList removeAllObjects];
    for (NSValue *value in frames) {
        frame = [value CGRectValue];
        if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
            frame.origin.y += itemOffset;
        }else{
            frame.origin.x += itemOffset;
        }
        [_frameList addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (CGFloat)itemWidthAtIndex:(NSUInteger)itemIndex {// 获取Item宽度
    if ([self.delegate respondsToSelector:@selector(menuBar:itemWidthAtIndex:)]) {
        return [self.delegate menuBar:self itemWidthAtIndex:itemIndex];
    }
    return 0;
}

#pragma mark reset slider frames
- (void)resetSliderFrames {
    [_sliderList removeAllObjects];

    if (!_menuTitles.count) {
        return;
    }
    
    switch (_sliderStyle) {
        case VTSliderStyleBubble:
            [self resetSliderForBubble];
            break;
        default:
            [self resetSliderForDefault];
            break;
    }
}

- (void)resetSliderForDefault {
    NSInteger index = 0;
    CGRect itemFrame = CGRectZero;
    CGFloat sliderY = CGRectGetHeight(self.frame) - _sliderHeight + _sliderOffset;
    CGRect frame = CGRectMake(0, sliderY, 0, _sliderHeight);
    for (NSString *title in _menuTitles) {
        itemFrame = [self itemFrameAtIndex:index];
        frame.size.width = [self sliderWidthAtIndex:index];
        BOOL isSelected = (index == _currentIndex);
        if (!CGRectGetWidth(frame)) {
            if (_sliderWidth) {
                frame.size.width = _sliderWidth;
            } else if (CGFLOAT_MAX != _sliderExtension) {
                frame.size.width = [self sizeWithTitle:title isSelected:isSelected].width;
                frame.size.width += _sliderExtension * 2;
            } else {
                frame.size.width = itemFrame.size.width;
            }
        }
        if(self.navPosition == VTNavPositionLeft||self.navPosition == VTNavPositionRight){
            frame.origin.y =CGRectGetMaxY(itemFrame) - frame.size.height/2 - 1 + _sliderOffset;
            frame.origin.x = CGRectGetMidX(itemFrame) - frame.size.width/2;
        }else{
            if(_contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft){
                CGFloat titleWidth = [self sizeWithTitle:title isSelected:isSelected].width;
                frame.origin.x = CGRectGetMinX(itemFrame) + (titleWidth - frame.size.width)/2;
            }else{
                frame.origin.x = CGRectGetMidX(itemFrame) - frame.size.width/2;
            }
        }

        [_sliderList addObject:[NSValue valueWithCGRect:frame]];
        index++;
    }
}

- (void)resetSliderForBubble {
    NSInteger index = 0;
    CGSize size = CGSizeZero;
    CGRect frame = CGRectZero;
    CGRect itemFrame = CGRectZero;
    CGPoint bubblePoint = CGPointZero;
    for (NSString *title in _menuTitles) {
        BOOL isSelected = (index == _currentIndex);
        size = [self sizeWithTitle:title isSelected:isSelected];
        itemFrame = [self itemFrameAtIndex:index];
        if (_bubbleSize.width) {
            size.width = _bubbleSize.width;
        }else{
            size.width += _bubbleInset.left + _bubbleInset.right;
        }
        if (_bubbleSize.height) {
            size.height = _bubbleSize.height;
        }else{
            size.height += _bubbleInset.top + _bubbleInset.bottom;
        }
        bubblePoint.x = CGRectGetMidX(itemFrame) - size.width/2;
        bubblePoint.y = CGRectGetMidY(itemFrame) - size.height/2;
        frame = (CGRect){bubblePoint, size};
        [_sliderList addObject:[NSValue valueWithCGRect:frame]];
        index++;
    }
}

- (CGFloat)sliderWidthAtIndex:(NSUInteger)itemIndex {
    if ([self.delegate respondsToSelector:@selector(menuBar:sliderWidthAtIndex:)]) {
        [self.delegate menuBar:self sliderWidthAtIndex:itemIndex];
    }
    return 0;
}

- (CGSize)sizeWithTitle:(NSString *)title isSelected:(BOOL)isSelected{
    UIFont *font = _itemFont;
    if (_selectedFont>0&&_normalFont>0) {
        if (isSelected) {
            font = _selectedFont;
        } else {
            font = _normalFont;
        }
    }
    if (font == nil) {
        font = _itemFont;
    }
    CGSize size = CGSizeZero;
    if ([title respondsToSelector:@selector(sizeWithAttributes:)]) {
        size = [title sizeWithAttributes:@{NSFontAttributeName : font}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [title sizeWithFont:_itemFont];
#pragma clang diagnostic pop
    }
    return size;
}

#pragma mark - 查询
- (CGRect)itemFrameAtIndex:(NSUInteger)index {
    if (_frameList.count <= index) {
        return CGRectZero;
    }
    return [_frameList[index] CGRectValue];
}

- (UIButton *)itemAtIndex:(NSUInteger)index {
    return [self itemAtIndex:index autoCreate:NO];
}

- (UIButton *)createItemAtIndex:(NSUInteger)index {
    return [self itemAtIndex:index autoCreate:YES];
}

- (UIButton *)itemAtIndex:(NSUInteger)index autoCreate:(BOOL)autoCreate {
    if (_menuTitles.count <= index) {
        return nil;
    }
    
    UIButton *menuItem = _visibleDict[@(index)];
    if (autoCreate && !menuItem) {
        menuItem = [self loadItemAtIndex:index];
    }
    return menuItem;
}

- (UIButton *)loadItemAtIndex:(NSInteger)index {
    UIButton *menuItem = [_datasource menuBar:self menuItemAtIndex:index];
    NSAssert([menuItem isKindOfClass:[UIButton class]], @"The class of menu item:%@ must be UIButton", menuItem);
    if (menuItem) {
        [menuItem addTarget:self action:@selector(menuItemClick:) forControlEvents:UIControlEventTouchUpInside];
        menuItem.titleLabel.layer.transform = CATransform3DIdentity;
        menuItem.tag = index + kVTMenuBarTag;
        if (index < _frameList.count) {
            menuItem.frame = [_frameList[index] CGRectValue];
        }
        [menuItem setSelected:NO];
        [self addSubview:menuItem];
        menuItem.contentHorizontalAlignment = _contentHorizontalAlignment;
        if (_contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
            [menuItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _itemSpacing)];
        }
        [_visibleDict setObject:menuItem forKey:@(index)];
    }
    return menuItem;
}

- (CGRect)sliderFrameAtIndex:(NSUInteger)index {
    if (_sliderList.count <= index) {
        return CGRectZero;
    }
    return [_sliderList[index] CGRectValue];
}

- (UIButton *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    _identifier = identifier;
    UIButton *menuItem = [_cacheSet anyObject];
    if (menuItem) {
        [_cacheSet removeObject:menuItem];
    }
    return menuItem;
}

#pragma mark - item 点击事件
- (void)menuItemClick:(UIButton *)sender {
    NSInteger itemIndex = sender.tag - kVTMenuBarTag;
    if ([self.delegate respondsToSelector:@selector(menuBar:didSelectItemAtIndex:)]) {
        [self.delegate menuBar:self didSelectItemAtIndex:itemIndex];
    }
}

@end
