//
//  DMLiveWillStartView.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMLiveWillStartView.h"

@interface DMLiveWillStartView ()

@property (strong, nonatomic) UIImageView *willStartDescribeImageView; // 即将开始的View: 图标
@property (strong, nonatomic) UILabel *willStartDescribeLabel; // 即将开始的View: 标题

@end

@implementation DMLiveWillStartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.willStartDescribeImageView];
        [self addSubview:self.willStartDescribeLabel];
        
        [_willStartDescribeImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_willStartDescribeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_willStartDescribeImageView.mas_bottom).offset(-80);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)willStartDescribeLabel {
    if (!_willStartDescribeLabel) {
        _willStartDescribeLabel = [UILabel new];
        _willStartDescribeLabel.textColor = [UIColor whiteColor];
        _willStartDescribeLabel.font = DMFontPingFang_Thin(15);
    }
    
    return _willStartDescribeLabel;
}

- (UIImageView *)willStartDescribeImageView {
    if (!_willStartDescribeImageView) {
        _willStartDescribeImageView = [UIImageView new];
        _willStartDescribeImageView.image = [UIImage imageNamed:@"icon_noTime"];
    }
    
    return _willStartDescribeImageView;
}


@end
