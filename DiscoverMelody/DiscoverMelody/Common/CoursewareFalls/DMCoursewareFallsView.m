//
//  DMCoursewareFallsView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCoursewareFallsView.h"
#import "DMCoursewareFallsCell.h"

@interface DMCoursewareFallsView ()
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end

@implementation DMCoursewareFallsView

- (id)initWithFrame:(CGRect)frame
            columns:(NSInteger)columns
        lineSpacing:(CGFloat)lineSpacing
      columnSpacing:(CGFloat)columnSpacing
         leftMargin:(CGFloat)leftMargin
        rightMargin:(CGFloat)rightMargin
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DMColorWithRGBA(240, 240, 240, 1);
        self.selectedArray = [NSMutableArray array];
        self.columns = columns;
        self.lineSpacing = lineSpacing;
        self.columnSpacing = columnSpacing;
        self.leftMargin = leftMargin;
        self.rightMargin = rightMargin;
        [self initCollectionViewObj];
    }
    return self;
}

- (void)updateCollectionViewStatus:(BOOL)isSelected {
    self.isSelected = isSelected;
    if (!isSelected) {
        [self.selectedArray removeAllObjects];
    }
    [_collectionView reloadData];
}

- (void)initCollectionViewObj {
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);//头部
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = DMColorWithRGBA(240, 240, 240, 1);
    
    //注册cell和ReusableView（相当于头部）
    [self.collectionView registerClass:[DMCoursewareFallsCell class] forCellWithReuseIdentifier:@"courseCcell"];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"courseCcell";
    DMCoursewareFallsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.tag = indexPath.row;
    [cell.courseImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"zu%ld.jpg", indexPath.row]]];
    [cell displayEditStatus:self.isSelected];
    if (self.isSelected) {
        NSString *indexRow = [NSString stringWithFormat:@"%ld", indexPath.row];
        if ([self.selectedArray containsObject:indexRow]) {
            NSLog(@"shuz = %@",self.selectedArray);
            [cell displaySelected:YES number:[self.selectedArray indexOfObject:indexRow]+1];
        } else {
            [cell displaySelected:NO number:0];
        }
        
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat value = (DMScreenWidth-(_leftMargin+_rightMargin)-(_columnSpacing*(_columns-1)))/_columns;
    return CGSizeMake(value, value);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 30, 20, 30);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 25;
}

//横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

#pragma mark --UICollectionViewDelegate
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择%ld",indexPath.row);
    if (self.blockDidSelectItemAtIndexPath) {
        if (self.isSelected) {
            //再选择状态下
            self.blockDidSelectItemAtIndexPath(indexPath, DMCoursewareFallsCellEventType_Select);
            NSString *indexRow = [NSString stringWithFormat:@"%ld", indexPath.row];
            DMCoursewareFallsCell *cell = (DMCoursewareFallsCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (![self.selectedArray containsObject:indexRow]) {
                [cell displaySelected:YES number:self.selectedArray.count+1];
                [self.selectedArray addObject:indexRow];
            }

        } else {
            //再非选择状态下
            self.blockDidSelectItemAtIndexPath(indexPath, DMCoursewareFallsCellEventType_Preview);
        }
    }
}

-(void)didSelectItemAtIndexPath:(BlockDidSelectItemAtIndexPath)blockDidSelectItemAtIndexPath {
    self.blockDidSelectItemAtIndexPath = blockDidSelectItemAtIndexPath;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
