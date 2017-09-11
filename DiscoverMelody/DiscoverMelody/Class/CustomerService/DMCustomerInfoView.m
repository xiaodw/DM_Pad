//
//  DMCustomerInfoView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCustomerInfoView.h"

@interface DMCustomerInfoView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, assign) BOOL isTap;
@end

@implementation DMCustomerInfoView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame
                     isTap:(BOOL)tap blockTapEvent:(BlockTapEvent)blockTapEvent {
    self = [super initWithFrame:frame];
    if (self) {
        self.isTap = tap;
        self.blockTapEvent = blockTapEvent;
        [self loadUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame isTap:(BOOL)tap {
    self = [super initWithFrame:frame];
    if (self) {
        self.isTap = tap;
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
    self.titleLabel.font = DMFontPingFang_Thin(16);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.infoButton setTitle:@"" forState:UIControlStateNormal];
    [self.infoButton setTitleColor:DMColorWithRGBA(246, 8, 122, 1) forState:UIControlStateNormal];
    [self.infoButton.titleLabel setFont:DMFontPingFang_Thin(16)];
    self.infoButton.userInteractionEnabled = NO;
    self.infoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (_isTap) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
        [self addGestureRecognizer:tap];
    }

    [self addSubview:self.infoButton];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = DMColorWithRGBA(221, 221, 221, 1);
    [self addSubview:self.lineLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18);
        make.top.bottom.equalTo(self);
        make.width.equalTo(DMScreenWidth/3);
    }];
    
    [self.infoButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18);
        make.top.bottom.equalTo(self);
        make.width.equalTo(DMScreenWidth/3);
    }];
    
    [self.lineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self).offset(0);
        make.height.equalTo(0.5);
    }];
}

- (void)updateSubViewsObj:(id)obj {
    self.titleLabel.text = @"咨询电话";
    if (self.isTap) {
        [self.infoButton setImage:[UIImage imageNamed:@"customer_bottom_arrow"] forState:UIControlStateNormal];
    } else {
        [self.infoButton setTitle:@"400-008-2899" forState:UIControlStateNormal];
    }
}


- (void)updateSubViewsObj:(id)obj isFurled: (BOOL)isFurled {
    self.titleLabel.text = @"寻律微信客服";
    if (isFurled) {
        [self.infoButton setImage:[UIImage imageNamed:@"customer_bottom_arrow"] forState:UIControlStateNormal];
    } else {
        [self.infoButton setImage:[UIImage imageNamed:@"customer_top_arrow"] forState:UIControlStateNormal];
    }
    
}

- (void)sectionClick:(UITapGestureRecognizer *)tap {
    
    if (self.blockTapEvent) {
        self.blockTapEvent();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
