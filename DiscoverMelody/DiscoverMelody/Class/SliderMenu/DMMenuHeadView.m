//
//  DMMenuHeadView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMMenuHeadView.h"

@interface DMMenuHeadView()

@end

@implementation DMMenuHeadView

#define Head_H 85

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DMColorWithRGBA(237, 237, 237, 1);//[UIColor whiteColor];
        [self configSubViews];
        [self configSubViewsLayout];
    }
    return self;
}

- (void)configSubViews {
    [self addSubview:self.headImageView];
    //[self addSubview:self.nameLabel];
    self.headImageView.image = [UIImage imageNamed:@"DM_LOGO"];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height- .5, self.frame.size.width, .5)];
    lineLabel.backgroundColor = UIColorFromRGB(0xdddddd);
    [self addSubview:lineLabel];
}

- (void)configSubViewsLayout {
    [_headImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(41);
//        make.centerX.equalTo(self);
//        make.size.equalTo(CGSizeMake(Head_H, Head_H));
        make.top.bottom.left.right.equalTo(self);
    }];
    
//    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_headImageView.mas_bottom).offset(21);
//        make.width.equalTo(self);
//        make.height.equalTo(10);
//    }];
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
//        _headImageView.layer.cornerRadius = Head_H/2;
//        _headImageView.layer.masksToBounds = YES;
        _headImageView.contentMode = UIViewContentModeCenter;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
        _nameLabel.font = DMFontPingFang_Light(12);
    }
    return _nameLabel;
}

@end
