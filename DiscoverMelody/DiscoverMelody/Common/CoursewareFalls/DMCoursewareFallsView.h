//
//  DMCoursewareFallsView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMCoursewareFallsCellEventType) {
    DMCoursewareFallsCellEventType_Preview = 0,
    DMCoursewareFallsCellEventType_Select,
};

typedef NS_ENUM(NSInteger, DMItemsOperation) {
    DMItemsOperation_None = 0, //默认
    DMItemsOperation_Add,//添加item，在DMCoursewareFallsCellEventType_Select下的行为操作
    DMItemsOperation_Remove,//移除item，在DMCoursewareFallsCellEventType_Select下的行为操作
};


typedef void (^BlockDidSelectItemAtIndexPath)(NSIndexPath *indexPath, DMItemsOperation iOt, DMCoursewareFallsCellEventType type); //cell的点击回调

@interface DMCoursewareFallsView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) BlockDidSelectItemAtIndexPath blockDidSelectItemAtIndexPath;

@property (nonatomic, assign) BOOL isSelected;
-(void)didSelectItemAtIndexPath:(BlockDidSelectItemAtIndexPath)blockDidSelectItemAtIndexPath;
/**
 *
 *  @param frame            区域大小
 *  @param columns          列数
 *  @param lineSpacing      行间距
 *  @param columnSpacing    列间距
 *  @param leftMargin       左边距
 *  @param rightMargin      右边距
 */
- (id)initWithFrame:(CGRect)frame
            columns:(NSInteger)columns
        lineSpacing:(CGFloat)lineSpacing
      columnSpacing:(CGFloat)columnSpacing
         leftMargin:(CGFloat)leftMargin
        rightMargin:(CGFloat)rightMargin;

- (void)updateCollectionViewStatus:(BOOL)isSelected;

@end
