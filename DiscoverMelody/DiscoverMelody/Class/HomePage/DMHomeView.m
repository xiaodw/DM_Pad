//
//  DMHomeView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/6.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMHomeView.h"

@interface DMHomeView()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *bTableView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *courseLabel; //课程名称
@property (nonatomic, strong) UILabel *nameLabel;   //老师姓名
@property (nonatomic, strong) UILabel *timeLabel;   //上课时间
@end

@implementation DMHomeView

-(id)initWithFrame:(CGRect)frame delegate:(id<DMHomeVCDelegate>) delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self configSubViews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)configSubViews {
    [self addSubview:self.topView];
    [self addSubview:self.bTableView];
}

- (void)setupMakeLayoutSubviews {
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(self.bounds.size.width, 426));
    }];
    [_bTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(0);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}

- (void)configTopView {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.topView.bounds];
    bgImageView.image = [UIImage imageNamed:@"hp_top_background"];
    [_topView addSubview:bgImageView];
    
    [bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
    
    [self configRightRegionView];
    [self configCourseInfoView];
}

- (void)configCourseInfoView {
    
    UIView *headView1 = [[UIView alloc] init];
    headView1.backgroundColor = [UIColor whiteColor];
    headView1.layer.cornerRadius = 89/2;
    headView1.layer.masksToBounds = YES;
    headView1.alpha = 0.05;
    
    UIView *headView2 = [[UIView alloc] init];
    headView2.backgroundColor = [UIColor whiteColor];
    headView2.alpha = 0.1;
    headView2.layer.cornerRadius = 80/2;
    headView2.layer.masksToBounds = YES;
    
    [_topView addSubview:headView1];
    [_topView addSubview:headView2];
    
    [_topView addSubview:self.headImageView];
    [_topView addSubview:self.courseLabel];
    [_topView addSubview:self.nameLabel];
    [_topView addSubview:self.timeLabel];
    
    [headView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_top).offset(32+64);
        make.centerX.equalTo(_topView);
        make.size.equalTo(CGSizeMake(89, 89));
    }];
    
    [headView2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView1.mas_top).offset(5);
        make.centerX.equalTo(_topView);
        make.size.equalTo(CGSizeMake(80, 80));
    }];
    
    [_headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView2.mas_top).offset(4);
        make.centerX.equalTo(_topView);
        make.size.equalTo(CGSizeMake(72, 72));
    }];
    
    [_courseLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView1.mas_bottom).offset(30);
        make.centerX.equalTo(_topView);
        make.size.equalTo(CGSizeMake(330, 20));
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_courseLabel.mas_bottom).offset(14);
        make.centerX.equalTo(_topView);
        make.size.equalTo(CGSizeMake(100, 20));
    }];
    
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(42);
        make.centerX.equalTo(_topView);
        make.size.equalTo(CGSizeMake(330, 58));
    }];
    

}

- (void)configRightRegionView {
    
    UIButton *cfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cfBtn setImage:[UIImage imageNamed:@"hp_course_file"] forState:UIControlStateNormal];
    [cfBtn addTarget:self action:@selector(clickCourseFileBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *cfLabel = [[UILabel alloc] init];
    cfLabel.text = @"本课文件";
    cfLabel.textAlignment = NSTextAlignmentCenter;
    cfLabel.textColor = [UIColor whiteColor];
    
    UIButton *crBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [crBtn setImage:[UIImage imageNamed:@"hp_enter_classroom"] forState:UIControlStateNormal];
    [crBtn addTarget:self action:@selector(clickClassRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *crLabel = [[UILabel alloc] init];
    crLabel.text = @"进入课堂";
    crLabel.textAlignment = NSTextAlignmentCenter;
    crLabel.textColor = [UIColor whiteColor];
    
    [_topView addSubview:cfBtn];
    [_topView addSubview:cfLabel];
    [_topView addSubview:crBtn];
    [_topView addSubview:crLabel];

    [cfBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_top).offset(117);
        make.right.equalTo(_topView.mas_right).offset(-46);
        make.size.equalTo(CGSizeMake(70, 70));
    }];
    
    [cfLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cfBtn.mas_bottom).offset(17);
        make.right.equalTo(_topView.mas_right).offset(-46);
        make.size.equalTo(CGSizeMake(70, 15));
    }];
    
    [crBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cfLabel.mas_bottom).offset(42);
        make.right.equalTo(_topView.mas_right).offset(-46);
        make.size.equalTo(CGSizeMake(70, 70));
    }];
    
    [crLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(crBtn.mas_bottom).offset(17);
        make.right.equalTo(_topView.mas_right).offset(-46);
        make.size.equalTo(CGSizeMake(70, 15));
    }];
}

- (void)clickCourseFileBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickCourseFiles)]) {
        [self.delegate clickCourseFiles];
    }
}

- (void)clickClassRoomBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickClassRoom)]) {
        [self.delegate clickClassRoom];
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        [self configTopView];
    }
    return _topView;
}

- (UITableView *)bTableView {
    if (!_bTableView) {
        _bTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _bTableView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"timg.jpg"];
        _headImageView.layer.cornerRadius = 72/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}

- (UILabel *)courseLabel {
    if (!_courseLabel) {
        _courseLabel = [[UILabel alloc] init];
        _courseLabel.text = @"未来之星";
        _courseLabel.textAlignment = NSTextAlignmentCenter;
        _courseLabel.textColor = [UIColor whiteColor];
    }
    return _courseLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"狼";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"上课时间：9月8日 18:00";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        
        _timeLabel.layer.cornerRadius = 5;
        //_timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _timeLabel.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        _timeLabel.layer.borderWidth = 1;
    }
    return _timeLabel;
}


@end
