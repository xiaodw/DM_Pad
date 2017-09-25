//
//  DMRadioView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMRadioView.h"

@interface DMRadioView ()
@property (nonatomic, strong) UIView *radioView;
@end

@implementation DMRadioView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.backgroundColor = DMColorWithRGBA(245, 245, 245, 1);
    
    self.radioView = [[UIView alloc] initWithFrame:self.bounds];
    self.radioView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.radioView];
    
    self.selButton = [self createRadioButton:@"  "];
    [self.radioView addSubview:self.selButton];
    
    [self.radioView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.selButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.radioView).offset(10);
        make.top.bottom.equalTo(self.radioView);
        make.size.equalTo(92);
    }];
}

- (UIButton *)createRadioButton:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:DMColorWithRGBA(102, 102, 102, 1) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"question_radio_nor"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"question_radio_sel"] forState:UIControlStateSelected];
    [btn.titleLabel setFont:DMFontPingFang_Light(14)];
    btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //btn.userInteractionEnabled = NO;
    return btn;
}

- (void)updateButtonTitle:(NSString *)title {
    [_selButton setTitle:title forState:UIControlStateNormal];
}

@end
