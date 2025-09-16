//
//  VTScrollView.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/12/28.
//

#import "VTScrollView.h"
#import "VTSectionModel.h"
#define imageWidth (SCREEN_WIDTH / 2) //每个按钮的宽度
#define imageDragScale 4.0//手动拖动scrollVIew滑动比例1:4
@interface VTScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign)CGPoint contentOfSet;
@property (nonatomic ,strong) NSMutableArray<UIButton *> *titleBtns;
// 记录上一个选中按钮
@property (nonatomic, weak) UIButton *selectButton;
@end
@implementation VTScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    //    self.scrollView.decelerationRate = 0.1;
    self.scrollView.backgroundColor = [UIColor whiteColor];
 
    [self addSubview:self.scrollView];
}
- (void)setImages:(NSArray *)images{
    _images=images;
    self.scrollView.contentSize = CGSizeMake((images.count-1) *  imageWidth+self.frame.size.width, 0);
    CGFloat btnW = imageWidth;
    CGFloat btnH = self.frame.size.height;
    [images enumerateObjectsUsingBlock:^(NSString *imageStr, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = (CGRect) {btnW * idx, 0, btnW, btnH};
        imageBtn.center = CGPointMake((self.frame.size.width / 2) + (idx * btnW), self.center.y);
        [imageBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
//        [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.tag = idx;
        [self.scrollView addSubview:imageBtn];
        [self.titleBtns addObject:imageBtn];
    }];
//    //滑动减速
//    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
//    [self scrollViewDidScroll:self.scrollView];
}

#pragma mark 由于外部其他scrollVIew滚动照成本scrollView也要滚动与之联动
- (void)scrollViewToBeScroll:(CGPoint)contentOffSet {
    [self.scrollView setContentOffset:CGPointMake(contentOffSet.x / (SCREEN_WIDTH / imageWidth), 0) animated:NO];
    //选中合适的按钮
    NSInteger targetIndex = round(self.scrollView.contentOffset.x / imageWidth);
    if(targetIndex>=self.titleBtns.count){
        return;
    }
    UIButton *btn = self.titleBtns[targetIndex];
    self.selectButton=btn;
}

- (void)imageBtnClick:(UIButton *)sender{
    self.selectButton=sender;
    [self.scrollView setContentOffset:CGPointMake(sender.tag * imageWidth, 0) animated:YES];
}
#pragma mark 给scrollView的panGestureRecognizer手势添加target,滑动时减速
- (void)panAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint p = [panGestureRecognizer translationInView:self.scrollView];
//    NSLog(@"%ld",panGestureRecognizer.state);
//    NSLog(@"%@",NSStringFromCGPoint(p));
    if(panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.contentOfSet = self.scrollView.contentOffset;
    }
    if(self.scrollView.bounces) {
        self.scrollView.contentOffset = CGPointMake( self.contentOfSet.x - p.x/imageDragScale , 0);
    } else {
        if((self.contentOfSet.x - p.x/imageDragScale) < 0) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } else if((self.contentOfSet.x - p.x/imageDragScale) > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width, 0);
        } else {
            self.scrollView.contentOffset = CGPointMake( self.contentOfSet.x - p.x/imageDragScale , 0);
        }
    }
}

// scrollView一滚动就会调用,字体颜色渐变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x/imageWidth;
    // 左边label角标
    NSInteger leftIndex = offsetX;
    // 右边的label角标
    NSInteger rightIndex = leftIndex + 1;
    if(leftIndex>=self.titleBtns.count){
        return;
    }
    UIButton *leftBtn = self.titleBtns[leftIndex];
    
    UIButton *rightBtn;
    if (rightIndex < self.titleBtns.count ) {
        rightBtn = self.titleBtns[rightIndex];
    }
    
    // 计算下右边缩放比例
    CGFloat rightScale = offsetX - leftIndex;
    // 计算下左边缩放比例
    CGFloat leftScale = 1 - rightScale;
    NSLog(@"leftScale--%f",leftScale);
    NSLog(@"rightScale--%f\n",rightScale);
    // 0 ~ 1
    // 1 ~ 2
    // 左边缩放
    leftBtn.imageView.transform = CGAffineTransformMakeScale(leftScale * 1.0 + 1, leftScale * 1.0+ 1);
    leftBtn.imageView.alpha = leftScale;
    
    
    // 右边缩放
    rightBtn.imageView.transform = CGAffineTransformMakeScale(rightScale * 1.0 + 1, rightScale * 1.0+ 1);
    rightBtn.imageView.alpha = rightScale;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //回到适合的
    NSInteger targetIndex = round(scrollView.contentOffset.x / imageWidth);
    UIButton *btn = self.titleBtns[targetIndex];
    [self imageBtnClick:btn];
}
//停止拖拽且目标point
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if(velocity.x > 0) {//右划惯性
        if(self.selectButton != self.titleBtns.lastObject) {
            targetContentOffset -> x = (self.selectButton.tag + 1) * imageWidth;
            // 0.获取角标
            NSInteger i = self.selectButton.tag + 1;
            //                !self.didTitleClickblock ? : self.didTitleClickblock(i);
            // 1.让标题按钮选中
            self.selectButton=self.titleBtns[i];
            //                [self titleClick:self.titleBtns[self.selectButton.tag + 1]];
        } else {
            [self imageBtnClick:self.selectButton];
        }
        return ;
    } else if (velocity.x < 0) {//左划惯性
        if(self.selectButton != self.titleBtns.firstObject) {
            targetContentOffset -> x = (self.selectButton.tag - 1) * imageWidth;
            // 0.获取角标
            NSInteger i = self.selectButton.tag - 1;
            
            //                !self.didTitleClickblock ? : self.didTitleClickblock(i);
            // 1.让标题按钮选中
            self.selectButton=self.titleBtns[i];
            
            //                [self titleClick:self.titleBtns[self.selectButton.tag - 1]];
        } else {
            [self imageBtnClick:self.selectButton];
        }
        return;
    } else {//无惯性
        
        //回到适合的
        NSInteger targetIndex = round(scrollView.contentOffset.x / imageWidth);
        UIButton *btn = self.titleBtns[targetIndex];
        [self imageBtnClick:btn];
        return;
    }
}

- (NSMutableArray<UIButton *> *)titleBtns {
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}


@end
