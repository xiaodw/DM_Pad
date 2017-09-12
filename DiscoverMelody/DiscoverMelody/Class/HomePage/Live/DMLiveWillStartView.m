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
        // 外部
        CGFloat exteriorLayerWH = 406;
        CALayer *exteriorLayer = [CALayer new];
        exteriorLayer.frame = CGRectMake(0, 0, exteriorLayerWH, exteriorLayerWH);
        exteriorLayer.backgroundColor = DMColorWithRGBA(2, 25, 31, 0.15).CGColor;
        exteriorLayer.cornerRadius = exteriorLayerWH * 0.5;
        
        // 中间
        CGFloat middleLayerWH = 370;
        CGFloat middleLayerXY = (exteriorLayerWH - middleLayerWH) * 0.5;
        CALayer *middleLayer = [CALayer new];
        middleLayer.frame = CGRectMake(middleLayerXY, middleLayerXY, middleLayerWH, middleLayerWH);
        middleLayer.backgroundColor = DMColorWithRGBA(2, 24, 27, 0.2).CGColor;
        middleLayer.cornerRadius = middleLayerWH * 0.5;
        
        // 内部
        CGFloat insideLayerWH = 336;
        CGFloat insideLayerXY = (exteriorLayerWH - insideLayerWH) * 0.5;
        CALayer *insideLayer = [CALayer new];
        insideLayer.frame = CGRectMake(insideLayerXY, insideLayerXY, insideLayerWH, insideLayerWH);
        insideLayer.backgroundColor =  DMColorWithRGBA(6, 15, 20, 0.3).CGColor;
        insideLayer.cornerRadius = insideLayerWH * 0.5;
        
        [self.layer addSublayer:exteriorLayer];
        [self.layer addSublayer:middleLayer];
        [self.layer addSublayer:insideLayer];
        self.clipsToBounds = YES;
        
        [self addSubview:self.willStartDescribeLabel];
        [self addSubview:self.willStartDescribeImageView];
        
        [_willStartDescribeImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(113);
            make.centerX.equalTo(self);
            make.size.equalTo(CGSizeMake(95, 111));
        }];
        
        [_willStartDescribeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_willStartDescribeImageView.mas_bottom).offset(31);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)willStartDescribeLabel {
    if (!_willStartDescribeLabel) {
        _willStartDescribeLabel = [UILabel new];
        _willStartDescribeLabel.textColor = [UIColor whiteColor];
        _willStartDescribeLabel.font = DMFontPingFang_Thin(20);
        _willStartDescribeLabel.text = @"距离上课时间还有5分钟";
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
