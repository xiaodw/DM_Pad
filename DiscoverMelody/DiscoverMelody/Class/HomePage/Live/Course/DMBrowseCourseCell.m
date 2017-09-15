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
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:courseModel.url]];
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
