//
//  DMQuestionViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/13.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMQuestionViewController.h"
#import "DMTabBarView.h"
#import "DMConst.h"
#import "DMTitleView.h"
#import "DMQuestionCell.h"
@interface DMQuestionViewController () <DMTabBarViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *hImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSArray *questionList;
@property (nonatomic, strong) DMTabBarView *tabBarView;
@property (nonatomic, strong) UITableView *bTableView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation DMQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DMTextQuestionnaire;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTransparence];
    self.questionList = [NSArray array];
    [self loadUI];
    [self getQuestionList];
    [self updateTopViewInfo:nil];
}

- (void)getQuestionList {
    WS(weakSelf);
    [DMApiModel getQuestInfo:self.lessonID block:^(BOOL result, NSArray *list) {
        if (result && list.count > 0) {
            weakSelf.questionList = list;
            [weakSelf.bTableView reloadData];
            if (weakSelf.bTableView.tableFooterView == nil && _bottomView) {
                weakSelf.bTableView.tableFooterView = _bottomView;
            }
        }
    }];
}

- (void)clickCommitBtn:(id)sender {
    NSLog(@"点击提交");
    [DMApiModel commitQuestAnswer:self.lessonID answers:nil block:^(BOOL result) {
        
    }];
}

#pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section < self.questionList.count) {
//        DMQuestSingleData *obj = [self.questionList objectAtIndex:indexPath.section];
//        if (obj.type.intValue == 1) {
//            if (indexPath.row < obj.options.count) {
//                DMQuestOptions *op = [obj.options objectAtIndex:indexPath.row];
//            }
//        }
//    }
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.questionList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    if (sectionIndex < self.questionList.count) {
        DMQuestSingleData *obj = [self.questionList objectAtIndex:sectionIndex];
        if (obj.type.intValue == 1) {
            return obj.options.count;
        }
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *qCell = @"questionCell";
    DMQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:qCell];
    if (!cell) {
        cell = [[DMQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:qCell];
    }
    if (indexPath.section < self.questionList.count) {
        
        DMQuestSingleData *obj = [self.questionList objectAtIndex:indexPath.section];
        [cell configObj:obj indexRow:indexPath.row];
    }
  
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *tvH = @"tvheader";
    DMTitleView *infoV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:tvH];
    if(infoV==nil) {
        infoV = [[DMTitleView alloc]
                 initWithReuseIdentifier:tvH
                 frame:CGRectMake(0, 0, self.bTableView.frame.size.width, 50)];
    }
    if (section < self.questionList.count) {
        DMQuestSingleData *obj = [self.questionList objectAtIndex:section];
        [infoV updateInfo:section+1 content:obj.name];
    }
    return infoV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


- (void)loadUI {
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.image = [UIImage imageNamed:@"question_bg"];

    UIView *headView2 = [[UIView alloc] init];
    headView2.backgroundColor = [UIColor whiteColor];
    headView2.alpha = 0.1;
    headView2.layer.cornerRadius = 50/2;
    headView2.layer.masksToBounds = YES;
    
    [self.view addSubview:topImageView];
    [topImageView addSubview:self.timeLabel];
    [topImageView addSubview:self.classNameLabel];
    [topImageView addSubview:self.typeLabel];
    [topImageView addSubview:headView2];
    [topImageView addSubview:self.hImageView];
    [topImageView addSubview:self.nameLabel];
    
    _bTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _bTableView.delegate = self;
    _bTableView.dataSource = self;
    _bTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bTableView.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
    UIView *hV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    hV.backgroundColor = [UIColor whiteColor];
    
    _bTableView.tableHeaderView = hV;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, 130)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
//    bottomView.layer.shadowColor = DMColorWithRGBA(221, 221, 221, 1).CGColor; // shadowColor阴影颜色
//    bottomView.layer.shadowOffset = CGSizeMake(0,-9); // shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
//    bottomView.layer.shadowOpacity = 1; // 阴影透明度，默认0
//    bottomView.layer.shadowRadius = 9; // 阴影半径，默认3
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = DMColorBaseMeiRed;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn.titleLabel setFont:DMFontPingFang_Regular(16)];
    [commitBtn addTarget:self action:@selector(clickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 5;
    commitBtn.layer.masksToBounds = YES;
    commitBtn.frame = CGRectMake((_bottomView.frame.size.width-130)/2, (_bottomView.frame.size.height-40)/2+30, 130, 40);
    //[self.view addSubview:bottomView];
    [_bottomView addSubview:commitBtn];
    [self.view addSubview:_bTableView];
    
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    if (userIdentity == 0) {
        _tabBarView = [DMTabBarView new];
        _tabBarView.delegate = self;
        _tabBarView.isFullScreen = YES;
        
        self.tabBarView.titles = @[DMTitleStudentQuestionFild, DMTitleTeacherQuestionFild];
        _tabBarView.layer.shadowColor = DMColorWithRGBA(221, 221, 221, 1).CGColor; // shadowColor阴影颜色
        _tabBarView.layer.shadowOffset = CGSizeMake(-3,9); // shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
        _tabBarView.layer.shadowOpacity = 1; // 阴影透明度，默认0
        _tabBarView.layer.shadowRadius = 9; // 阴影半径，默认3
        [self.view addSubview:_tabBarView];
    }

//    [bottomView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view).offset(0);
//        make.centerX.equalTo(topImageView);
//        make.height.equalTo(120);
//    }];
////
//    [commitBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(bottomView.mas_bottom).offset(-43);
//        make.centerX.equalTo(bottomView);
//        make.height.equalTo(40);
//        make.width.equalTo(130);
//    }];
//
    [topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(180);
    }];
    
    if (userIdentity == 0) {
        
        [_tabBarView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageView.mas_bottom).offset(0);
            make.left.right.equalTo(self.view);
            make.height.equalTo(50);
        }];
        
        [_bTableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tabBarView.mas_bottom).equalTo(0);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).equalTo(0);
        }];
        
    } else {
        [_bTableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImageView.mas_bottom).equalTo(0);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).equalTo(0);
        }];
    }

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
