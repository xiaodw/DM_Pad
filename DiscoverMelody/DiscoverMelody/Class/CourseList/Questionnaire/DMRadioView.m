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
    
    self.radioView = [[UIView alloc] init];
    self.radioView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.radioView];
    
    self.yesButton = [self createRadioButton:@"YES"];
    self.noButton = [self createRadioButton:@"NO"];
    [self.radioView addSubview:self.yesButton];
    [self.radioView addSubview:self.noButton];
    
    [self.radioView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.yesButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.radioView);
        make.size.equalTo(92);
    }];
    [self.noButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.radioView);
        make.left.equalTo(self.yesButton.mas_right).offset(235);
        make.size.equalTo(92);
    }];

}

- (UIButton *)createRadioButton:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:DMColorWithRGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"question_radio_nor"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"question_radio_sel"] forState:UIControlStateSelected];
    return btn;
}

@end
