//
//  VTScrollController.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/12/28.
//

#import "VTScrollController.h"
#import "VTGridViewController.h"
#import "VTScrollView.h"
@interface VTScrollController ()
@property (nonatomic, strong)VTScrollView *headerView;
@property (nonatomic, strong)VTScrollView *footerView;
@property (nonatomic, strong)NSArray *headerImages;
@property (nonatomic, strong)NSArray *footerImages;
@end

@implementation VTScrollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headerImages = @[@"image_0",@"image_1",@"image_2",@"image_3",@"image_4"];
    self.footerImages = @[@"image_5",@"image_6",@"image_7",@"image_8",@"image_9"];
    self.magicView.layoutStyle=VTLayoutStyleDivide;
    [self createScrollView];
    [self generateTestDataArrCount:self.headerImages.count];
    [self.magicView reloadData];
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView scrollViewDidScroll:(nonnull UIScrollView *)scrollView {
    [self.headerView scrollViewToBeScroll:scrollView.contentOffset];
    [self.footerView scrollViewToBeScroll:scrollView.contentOffset];
}


- (void)createScrollView{
    self.magicView.headerHidden=NO;
    self.magicView.headerHeight=120;
    VTScrollView *headerView=[[VTScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    headerView.images=self.headerImages;
    [self.magicView.headerView addSubview:headerView];
    self.headerView=headerView;
    
    self.magicView.footerHidden=NO;
    self.magicView.footerHeight=80;
    VTScrollView *footerView=[[VTScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    footerView.images=self.footerImages;
    [self.magicView.footerView addSubview:footerView];
    self.footerView=footerView;

}


@end
