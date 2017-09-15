//
//  DMBrowseCourseCell.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBrowseCourseCell.h"
#import "DMCourseModel.h"

@interface DMBrowseCourseCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation DMBrowseCourseCell

- (void)setCourseModel:(DMCourseModel *)courseModel{
    _courseModel = courseModel;
    
    if (!_isFullScreen) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:courseModel.url]];
        return;
    }
    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:courseModel.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        CGSize imageSize = image.size;
//        BOOL isVertical = imageSize.height > imageSize.width ;
//        
//        [_imageView remakeConstraints:^(MASConstraintMaker *make) {
//            if (imageSize.height > self.contentView.dm_height) {
//                
//            }else {
//                
//            }
//            
//            if (imageSize.height > self.contentView.dm_height) {
//                
//            }else {
//                
//            }
//        }];
//        
//        if (isVertical) { // 图片高度 > 宽度
//            // 图片 高度 > cell 高度
//            if (imageSize.height > self.contentView.dm_height) {
//                [_imageView remakeConstraints:^(MASConstraintMaker *make) {
//                    make.top.bottom.centerX.equalTo(self.contentView);
//                    if(imageSize.width > self.contentView.dm_width) {
//                        make.width.equalTo(self.contentView.dm_width);
//                    }else{
//                         make.width.equalTo(imageSize.width);
//                    }
//                }];
//                return;
//            }
//            
//            // 图片 高度 < cell 高度
//            [_imageView remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.bottom.centerX.equalTo(self.contentView);
//                if(imageSize.width > self.contentView.dm_width) {
//                    make.width.equalTo(self.contentView.dm_width);
//                }else{
//                    make.width.equalTo(imageSize.width);
//                }
//            }];
//            
//        }
//        else {// 高度 <= 宽度
//            // 图片 宽度 > cell 宽度
//            if (imageSize.width > self.contentView.dm_width) {
//                // 图片 宽度 > cell 宽度
//                [_imageView remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.right.centerY.equalTo(self.contentView);
//                    if (imageSize.height > self.contentView.dm_height) {
//                        make.height.equalTo(self.contentView.dm_height);
//                    }else{
//                        make.height.equalTo(imageSize.height);
//                    }
//                }];
//                return;
//            }
//            
//            // 图片 宽度 > cell 宽度
//            [_imageView remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.centerY.equalTo(self.contentView);
//                if (imageSize.height > self.contentView.dm_height) {
//                    make.height.equalTo(self.contentView.dm_height);
//                }else{
//                    make.height.equalTo(imageSize.height);
//                }
//            }];
//        }
//    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    
    return _imageView;
}

@end
