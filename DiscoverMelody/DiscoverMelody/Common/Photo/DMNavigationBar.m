
//
//  DMNavigationBar.m
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMNavigationBar.h"

@interface DMNavigationBar ()

@property (strong, nonatomic) UIButton *leftBarButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *rightBarButton;

@end

@implementation DMNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.leftBarButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBarButton];
}

- (void)setupMakeLayoutSubviews {
    [_leftBarButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.size.equalTo(CGSizeMake(44, 30));
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [_rightBarButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.bottom.width.height.equalTo(_leftBarButton);
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftBarButton);
        make.centerX.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = DMFontPingFang_Medium(16);
    }
    
    return _titleLabel;
}

- (UIButton *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [UIButton new];
        _rightBarButton.titleLabel.font = DMFontPingFang_Medium(16);
    }
    
    return _rightBarButton;
}

- (UIButton *)leftBarButton {
    if (!_leftBarButton) {
        _leftBarButton = [UIButton new];
        [_leftBarButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    }
    
    return _leftBarButton;
}

@end
