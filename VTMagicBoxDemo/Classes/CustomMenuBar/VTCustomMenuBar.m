//
//  VTCustomMenuBar.m
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2024/5/17.
//

#import "VTCustomMenuBar.h"
#import "VTCustomMenuBarModel.h"
#import "VTCustomMenuBarCell.h"
@interface VTCustomMenuBar()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@end
@implementation VTCustomMenuBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createCategoryViewUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self createCategoryViewUI];

    }
    return self;
}
- (void)setTitles:(NSArray *)titles{
    [titles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VTCustomMenuBarModel *model = [[VTCustomMenuBarModel alloc]init];
        if(idx==0){
            model.isSele=YES;
        }
        model.text = obj;
        CGSize size =[self getSizeWithString:obj andWithWidth:UIScreen.mainScreen.bounds.size.width andWithFont:[UIFont systemFontOfSize:16]];
        model.width =size.width+20;
        [self.dataArray addObject:model];
    }];
    [self.collectionView reloadData];
    
}
- (void)selectItemAtIndex:(NSInteger)index{
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    VTCustomMenuBarModel *model = [self.dataArray objectAtIndex:index];
    [self.dataArray enumerateObjectsUsingBlock:^(VTCustomMenuBarModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([model.text isEqualToString:obj.text]){
            obj.isSele=YES;
        }else{
            obj.isSele=NO;
        }
    }];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(index*model.width-UIScreen.mainScreen.bounds.size.width/2, 0) animated:YES];
}
- (void)createCategoryViewUI{
    [self addSubview:self.collectionView];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VTCustomMenuBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VTCustomMenuBarCell class]) forIndexPath:indexPath];
    VTCustomMenuBarModel *model = [self.dataArray objectAtIndex:indexPath.item];
    cell.model=model;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    VTCustomMenuBarModel *model = [self.dataArray objectAtIndex:indexPath.item];
    return CGSizeMake(model.width, 44);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VTCustomMenuBarModel *model = [self.dataArray objectAtIndex:indexPath.item];
    [self.dataArray enumerateObjectsUsingBlock:^(VTCustomMenuBarModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([model.text isEqualToString:obj.text]){
            obj.isSele=YES;
        }else{
            obj.isSele=NO;
        }
    }];
    [self.collectionView reloadData];
    if(self.didSelectItemBlock){
        self.didSelectItemBlock(indexPath.item);
    }
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44) collectionViewLayout: layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.scrollEnabled = NO;
        _collectionView.allowsSelection = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[VTCustomMenuBarCell class] forCellWithReuseIdentifier:NSStringFromClass([VTCustomMenuBarCell class])];
    }
    return _collectionView;
}
- (CGSize)getSizeWithString:(NSString *)aString andWithWidth:(CGFloat)width andWithFont:(UIFont *)font{
    CGSize size = [aString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}
- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
@end
