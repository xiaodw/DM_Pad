//
//  DMHomeView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/6.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMHomeView.h"
#import "DMHomeCell.h"

@interface DMHomeView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *bTableView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *courseLabel; //课程名称
@property (nonatomic, strong) UILabel *nameLabel;   //老师姓名
@property (nonatomic, strong) UILabel *timeLabel;   //上课时间

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) UIView *noCourseView;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DMHomeView

- (void)reloadHomeTableView {
    [self.bTableView reloadData];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<DMHomeVCDelegate>) delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self configSubViews];
        [self setupMakeLayoutSubviews];
        //[self updateTopViewInfo:nil];
    }
    return self;
}

- (void)updateTopViewInfo:(DMCourseDatasModel *)obj {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:obj.avatar] placeholderImage:[UIImage imageNamed:@"timg1.jpg"]];
    _courseLabel.text = obj.course_name;
    _nameLabel.text = obj.teacher_name;
    _timeLabel.text = [@"上课时间：" stringByAppendingString:
                       [DMTools timeFormatterYMDFromTs:obj.start_time format:@"MM月dd日 HH:mm"]];//@"上课时间：9月8日 18:00";
    if (_timeLabel.layer.cornerRadius == 0) {
        _timeLabel.layer.cornerRadius = 5;
        _timeLabel.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        _timeLabel.layer.borderWidth = 1;
    }

}

- (void)disPlayNoCourseView:(BOOL)display isError:(BOOL)error {
    _noCourseView.hidden = !display;
    if (display) {
        if (error) {
            //网络错误
            self.iconImageView.image = [UIImage imageNamed:@"error_icon"];
            self.titleLabel.text = @"数据加载失败";
            self.reloadButton.hidden = NO;
        } else {
            //无课程
            self.iconImageView.image = [UIImage imageNamed:@"icon_noCourse"];
            self.titleLabel.text = @"您暂时还没有课程哦";
            self.reloadButton.hidden = YES;
        }
    }
    _topView.hidden = display;
    _bTableView.hidden = display;

}

#pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    if ([_delegate respondsToSelector:@selector(selectedCourse:)]) {
        if (indexPath.row < self.datas.count) {
            DMCourseDatasModel *data = [self.datas objectAtIndex:indexPath.row];
            [_delegate selectedCourse:data];
        }
    }
    [tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *homeCell = @"homecell";
    DMHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell];
    if (!cell) {
        cell = [[DMHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeCell];
    }
    DMCourseDatasModel *data = [self.datas objectAtIndex:indexPath.row];
    if ([indexPath isEqual:self.selectedIndexPath]) {
        [cell isSelectedCell:YES];
        [self updateTopViewInfo:data];
    } else {
        [cell isSelectedCell:NO];
    }
    cell.nameLabel.text = data.course_name;
    cell.timeLabel.text = [@"上课时间：" stringByAppendingString:
                           [DMTools timeFormatterYMDFromTs:data.start_time format:@"MM月dd日 HH:mm"]];//@"上课时间：8月16日 10:00";
    cell.statusLabel.text = @"未开始";
    if (data.live_status.intValue == 0) {
        cell.statusLabel.text = @"未开始";
    } else if (data.live_status.intValue == 1) {
        cell.statusLabel.text = @"上课中";
    } else if (data.live_status.intValue == 2) {
        cell.statusLabel.text = @"课程结束";
    } else if (data.live_status.intValue == 3) {
        cell.statusLabel.text = @"取消课程";
    }
//    else if (data.live_status.intValue == 4) {
//        cell.statusLabel.text = @"结束";
//    }
    
    return cell;
}

- (void)configSubViews {
    [self addSubview:self.topView];
    [self addSubview:self.bTableView];
    [self addSubview:self.noCourseView];
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
        make.width.equalTo(self.frame.size.width);
    }];
    [_noCourseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.size.equalTo(self);
        make.centerX.equalTo(self);
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
    cfLabel.text = DMTextThisClassFile;
    cfLabel.textAlignment = NSTextAlignmentCenter;
    cfLabel.textColor = [UIColor whiteColor];
    cfLabel.font = DMFontPingFang_Medium(14);
    
    UIButton *crBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [crBtn setImage:[UIImage imageNamed:@"hp_enter_classroom"] forState:UIControlStateNormal];
    [crBtn addTarget:self action:@selector(clickClassRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *crLabel = [[UILabel alloc] init];
    crLabel.text = DMTextJoinClass;
    crLabel.textAlignment = NSTextAlignmentCenter;
    crLabel.textColor = [UIColor whiteColor];
    crLabel.font = DMFontPingFang_Medium(14);
    
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
- (UIView *)noCourseView {
    if (!_noCourseView) {
        _noCourseView = [UIView new];
        _noCourseView.hidden = YES;
        _noCourseView.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
        
        UIImageView *topImageView = [UIImageView new];
        topImageView.image = [UIImage imageNamed:@"hp_no_course_icon"];
        
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"icon_noCourse"];
        
        _titleLabel = [UILabel new];
        _titleLabel.text = DMTextRecentNotClass;
        _titleLabel.font = DMFontPingFang_Light(20);
        _titleLabel.textColor = DMColorWithRGBA(204, 204, 204, 1);
        
        self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reloadButton.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
        [self.reloadButton setTitle:DMTitleRefresh forState:UIControlStateNormal];
        [self.reloadButton addTarget:self action:@selector(clickReload:) forControlEvents:UIControlEventTouchUpInside];
        [self.reloadButton setTitleColor:DMColorWithRGBA(204, 204, 204, 1) forState:UIControlStateNormal];
        self.reloadButton.titleLabel.font = DMFontPingFang_Light(16);
        _reloadButton.layer.cornerRadius = 5;
        _reloadButton.layer.borderColor = DMColorWithRGBA(204, 204, 204, 1).CGColor;//[UIColor colorWithWhite:1 alpha:0.5].CGColor;
        _reloadButton.layer.borderWidth = 1;
        
        [_noCourseView addSubview:topImageView];
        [_noCourseView addSubview:_iconImageView];
        [_noCourseView addSubview:_titleLabel];
        [_noCourseView addSubview:self.reloadButton];
        
        [topImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_noCourseView).offset(0);
            make.height.equalTo(64);
        }];
        
        [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noCourseView);
            make.centerY.equalTo(_noCourseView);
            make.size.equalTo(CGSizeMake(134, 118));
        }];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconImageView.mas_bottom).offset(5);
            make.centerX.equalTo(_iconImageView);
        }];
        
        [_reloadButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.centerX.equalTo(_iconImageView);
            make.size.equalTo(CGSizeMake(70, 35));
        }];
    }
    
    return _noCourseView;
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

- (void)clickReload:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickReload)]) {
        [self.delegate clickReload];
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
        _bTableView.delegate = self;
        _bTableView.dataSource = self;
        _bTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        UIView *hV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
        hV.backgroundColor = UIColorFromRGB(0xf6f6f6);
        
        _bTableView.tableHeaderView = hV;
        
    }
    return _bTableView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = 72/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}

- (UILabel *)courseLabel {
    if (!_courseLabel) {
        _courseLabel = [[UILabel alloc] init];
        _courseLabel.textAlignment = NSTextAlignmentCenter;
        _courseLabel.textColor = [UIColor whiteColor];
        _courseLabel.font = DMFontPingFang_Medium(22);
    }
    return _courseLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = DMFontPingFang_Medium(18);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = DMFontPingFang_Medium(20);
    }
    return _timeLabel;
}


@end
