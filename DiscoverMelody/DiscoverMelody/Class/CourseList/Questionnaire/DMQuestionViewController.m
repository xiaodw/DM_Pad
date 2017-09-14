//
//  DMQuestionViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/13.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMQuestionViewController.h"

@interface DMQuestionViewController ()
@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *hImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation DMQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"调查问卷";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTransparence];
    
    [self loadUI];
    [self updateTopViewInfo:nil];
}

- (void)loadUI {
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.image = [UIImage imageNamed:@"question_bg"];
    [self.view addSubview:topImageView];
    
    [topImageView addSubview:self.timeLabel];
    [topImageView addSubview:self.classNameLabel];
    [topImageView addSubview:self.typeLabel];
    
    UIView *headView2 = [[UIView alloc] init];
    headView2.backgroundColor = [UIColor whiteColor];
    headView2.alpha = 0.1;
    headView2.layer.cornerRadius = 50/2;
    headView2.layer.masksToBounds = YES;
    [topImageView addSubview:headView2];
    
    [topImageView addSubview:self.hImageView];
    [topImageView addSubview:self.nameLabel];
    
    [topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(180);
    }];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImageView.mas_bottom).offset(-47);
        make.centerX.equalTo(topImageView);
        make.size.equalTo(CGSizeMake(240, 40));
    }];
    [_classNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImageView.mas_bottom).offset(-47);
        make.left.equalTo(topImageView);
        make.right.equalTo(_timeLabel.mas_left).offset(-52);
        make.height.equalTo(40);
    }];
    [_typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImageView.mas_bottom).offset(-47);
        make.left.equalTo(_timeLabel.mas_right).offset(52);
        make.size.equalTo(CGSizeMake(50, 40));
    }];
    [headView2 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImageView.mas_bottom).offset(-42);
        make.left.equalTo(_typeLabel.mas_right).offset(2);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    [_hImageView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImageView.mas_bottom).offset(-47);
        make.left.equalTo(_typeLabel.mas_right).offset(7);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImageView.mas_bottom).offset(-47);
        make.left.equalTo(_hImageView.mas_right).offset(20);
        make.right.equalTo(topImageView.mas_right).offset(0);
        make.height.equalTo(40);
    }];
    
}
- (void)updateTopViewInfo:(id)obj {
    [_hImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"timg1.jpg"]];
    _classNameLabel.text = @"未来之星1v1--钢琴";
    _nameLabel.text = @"郎郎";
    _timeLabel.text = @"上课时间：9月8日 18:00";
    _typeLabel.text = @"老师：";
}


- (UIImageView *)hImageView {
    if (!_hImageView) {
        _hImageView = [[UIImageView alloc] init];
        _hImageView.layer.cornerRadius = 40/2;
        _hImageView.layer.masksToBounds = YES;
        _hImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hImageView;
}

- (UILabel *)classNameLabel {
    if (!_classNameLabel) {
        _classNameLabel = [[UILabel alloc] init];
        _classNameLabel.textAlignment = NSTextAlignmentRight;
        _classNameLabel.textColor = [UIColor whiteColor];
        _classNameLabel.font = DMFontPingFang_Light(16);
    }
    return _classNameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = DMFontPingFang_Light(16);
    }
    return _typeLabel;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = DMFontPingFang_Light(16);
    }
    return _nameLabel;
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = DMFontPingFang_Light(16);
        
        _timeLabel.layer.cornerRadius = 5;
        //_timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _timeLabel.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        _timeLabel.layer.borderWidth = 1;
    }
    return _timeLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
