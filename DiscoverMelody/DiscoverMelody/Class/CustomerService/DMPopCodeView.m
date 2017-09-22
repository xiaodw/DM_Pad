//
//  DMPopCodeView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMPopCodeView.h"

@interface DMPopCodeView()
@property(nonatomic, strong)UIView *blackView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *messageLabel;
@property(nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *msgStr;
@property (nonatomic, strong) NSString *imageName;
@end

@implementation DMPopCodeView

-(instancetype)initWithTitle:title message:messge imageName:(NSString *)imageName {
    if (self=[super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        _titleStr = title;
        _msgStr = messge;
        _imageName = imageName;
        [self setUp];
    }
    return self;
}

-(void)setUp {
    //黑色背景
    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, DMScreenHeight)];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.7;
    [self addSubview:_blackView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlackView)];
    [_blackView addGestureRecognizer:tap1];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    //imageView.image = [UIImage imageNamed:_imageName];
    [self addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageName] placeholderImage:[UIImage imageNamed:@""]];
    
    //标题
    UILabel *alertTitle = [[UILabel alloc] init];
    alertTitle.text = _titleStr;
    alertTitle.textAlignment = NSTextAlignmentCenter;
    alertTitle.textColor = [UIColor whiteColor];
    alertTitle.font = DMFontPingFang_Light(22);
    [self addSubview:alertTitle];
    
    //消息内容
    UILabel *message = [[UILabel alloc] init];
    message.text = _msgStr;
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    message.textColor = [UIColor whiteColor];
    message.font = DMFontPingFang_UltraLight(14);
    [self addSubview:message];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset((DMScreenHeight-300)/2);
        make.size.equalTo(CGSizeMake(300, 300));
        make.centerX.equalTo(self);
    }];

    [alertTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(33);
        make.left.right.equalTo(self).offset(0);
        make.width.equalTo(22);
        make.centerX.equalTo(self);
    }];

    [message makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertTitle.mas_bottom).offset(11);
        make.left.right.equalTo(self).offset(0);
        make.width.equalTo(16);
        make.centerX.equalTo(self);
    }];

}

-(void)show {
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
}

- (void)tapBlackView {
    self.alpha = 0.0;
    [self removeFromSuperview];
    _blackView=nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
