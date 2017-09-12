//
//  DMCoursewareFallsCell.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCoursewareFallsCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *selectedView;
- (void)displayEditStatus:(BOOL)isDisplay;
- (void)displaySelected:(BOOL)isDisplay number:(NSInteger)i;
@end
