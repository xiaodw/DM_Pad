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
#import "IQKeyboardManager.h"
#import "DMCommitAnswerData.h"

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
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, assign) BOOL isEditQuest;

@property (nonatomic, strong) UIView *topStatusView;
@property (nonatomic, strong) UIButton *statusButton;

@property (nonatomic, assign) BOOL statusDis;

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIView *teacherCommentsView;
@property (nonatomic, strong) UIImageView *noComView;
@property (nonatomic, strong) UILabel *noComLabel;

@property (nonatomic, strong)DMQuestData *myQuestObj;
@property (nonatomic, strong)DMQuestData *teachSurveyObj;

@property (nonatomic, assign) BOOL currentSegmentTeachSurvey;

@end

@implementation DMQuestionViewController

#define Top_H 180
#define Space_H 42

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DMTextQuestionnaire;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTransparence];
    [IQKeyboardManager sharedManager].enable = YES;
    self.isEditQuest = YES;
    self.questionList = [NSArray array];
    
    [self loadUI];
    
    [self getQuestionList];
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    if (userIdentity == 0) {
        [self getSurveyTeacher];
    }
    [self updateTopViewInfo:self.courseObj];
}

- (void)getQuestionList {
    WS(weakSelf);
    [DMApiModel getQuestInfo:self.courseObj.lesson_id block:^(BOOL result, DMQuestData *obj) {
        if (result && !OBJ_IS_NIL(obj) && obj.list.count > 0) {
            weakSelf.myQuestObj = obj;
            NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
            if (userIdentity != 0) {
                [weakSelf updateUIStatus:obj.survey.intValue];
            }
            [weakSelf updateTableStatus:obj isNetCallback:YES];
        } else {
            [weakSelf updateTableStatus:obj isNetCallback:NO];
        }
    }];
}

- (void)getSurveyTeacher {
    WS(weakSelf);
    [DMApiModel getTeacherAppraise:self.courseObj.lesson_id block:^(BOOL result, DMQuestData *obj) {
        if (result && !OBJ_IS_NIL(obj) && obj.list.count > 0) {
            weakSelf.teachSurveyObj = obj;
            if (weakSelf.currentSegmentTeachSurvey) {
                //weakSelf.isEditQuest = NO;
                [weakSelf updateTableStatus:obj isNetCallback:NO];
            }
        } else {
            if (weakSelf.currentSegmentTeachSurvey) {
                [weakSelf isDisplayNoComView:YES];
            }
        }
    }];
}

- (void)updateTableStatus:(DMQuestData *)obj isNetCallback:(BOOL)netCallBack {
    
    if (obj) {
        if (obj.survey.intValue == 1 || obj.survey.intValue == 2 || _currentSegmentTeachSurvey) {
            self.isEditQuest = NO;
        } else {
            self.isEditQuest = YES;
        }
        self.questionList = obj.list;
        [self.bTableView reloadData];
        if (self.bTableView.tableFooterView == nil && _bottomView) {
            [self updateBottomViewFrame];
            NSLog(@"ddddd = %f ---- %f", self.bTableView.contentSize.height, DMScreenHeight);
            self.bTableView.tableFooterView = _bottomView;
            
        }
        
        if (netCallBack) {
            [self performSelector:@selector(delayMethodDisplay) withObject:nil afterDelay:0.2];
        } else {
            [self delayMethodDisplay];
        }
    } else {
        self.bottomView.hidden = YES;
    }
}

- (void)delayMethodDisplay {
    self.bottomView.hidden = !self.isEditQuest;
}

- (void)clickCommitBtn:(id)sender {
    NSLog(@"点击提交");
    WS(weakSelf);
    NSMutableArray *array = [NSMutableArray array];
    for (DMQuestSingleData *data in self.questionList) {
        DMCommitAnswerData *obj = [[DMCommitAnswerData alloc] init];
        obj.lesson_id = self.courseObj.lesson_id;
        obj.question_id = data.question_id;
        obj.content = data.answer_content;
        [array addObject:obj];
    }
    NSArray *dicArray = [DMCommitAnswerData mj_keyValuesArrayWithObjectArray:array];
    [DMApiModel commitQuestAnswer:self.lessonID answers:dicArray block:^(BOOL result) {
        if (result) {
            //weakSelf.isEditQuest = NO;
            weakSelf.myQuestObj.survey = @"1";
            [weakSelf updateTableStatus:weakSelf.myQuestObj isNetCallback:NO];
//            weakSelf.bottomView.hidden = !weakSelf.isEditQuest;
//            [weakSelf.bTableView reloadData];
        }
    }];
}

- (void)tabBarView:(DMTabBarView *)tabBarView didTapBarButton:(UIButton *)button {
    
    if (button.tag == 0) {
        NSLog(@"学生问卷");
        _currentSegmentTeachSurvey = NO;
        _bTableView.hidden = NO;
        _teacherCommentsView.hidden = YES;
        self.questionList = self.myQuestObj.list;
        
        if (self.myQuestObj) {
            [self updateTableStatus:self.myQuestObj isNetCallback:NO];
        } else {
            [self updateTableStatus:self.myQuestObj isNetCallback:YES];
        }
        //[self.bTableView reloadData];
    } else {
        NSLog(@"老师评语");
        _currentSegmentTeachSurvey = YES;
        _bTableView.hidden = YES;
        _teacherCommentsView.hidden = NO;
        if (self.teachSurveyObj == nil) {
            [self isDisplayNoComView:YES];
        } else {
            _bTableView.hidden = NO;
            _teacherCommentsView.hidden = YES;
            self.questionList = self.teachSurveyObj.list;
            [self updateTableStatus:self.teachSurveyObj isNetCallback:NO];
            //[self.bTableView reloadData];
        }
    }
}

- (void)isDisplayNoComView:(BOOL)isDisplay {
    //显示没有评语的效果
    if (_noComView == nil) {
        self.noComView = [[UIImageView alloc] init];
        self.noComView.image = [UIImage imageNamed:@"quest_no_teacher_com"];//DMTitleNoTeacherQuestionComFild
        [self.teacherCommentsView addSubview:self.noComView];
        
        self.noComLabel = [[UILabel alloc] init];
        self.noComLabel.text = DMTitleNoTeacherQuestionComFild;
        self.noComLabel.textAlignment = NSTextAlignmentCenter;
        self.noComLabel.font = DMFontPingFang_Light(16);
        self.noComLabel.textColor = DMColorWithRGBA(204, 204, 204, 1);
        [self.teacherCommentsView addSubview:self.noComLabel];
        
        [self.noComView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_teacherCommentsView);
            make.centerY.equalTo(_teacherCommentsView).offset(-80);
            //make.top.equalTo(_teacherCommentsView).offset(133);
        }];
        
        [self.noComLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_noComView.mas_bottom).offset(22);
            make.left.right.equalTo(_teacherCommentsView);
            make.height.equalTo(16);
        }];
        
    }
    self.noComLabel.hidden = !isDisplay;
    self.noComView.hidden = !isDisplay;
}

- (void)updateTopViewInfo:(DMCourseDatasModel *)obj {
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    NSString *type = @"老师：";
    if (userIdentity == 0) {
        [_hImageView sd_setImageWithURL:[NSURL URLWithString:obj.avatar] placeholderImage:HeadPlaceholderName];
    } else {
        _hImageView.image = nil;
        type = @"学生：";
    }
    _classNameLabel.text = obj.course_name;//@"未来之星1v1--钢琴";
    _nameLabel.text = (userIdentity == 0)?obj.teacher_name:obj.student_name;//@"郎郎";
    _timeLabel.text = [@"上课时间：" stringByAppendingString:
                       [DMTools timeFormatterYMDFromTs:obj.start_time format:@"YYYY年MM月dd日"]];//@"上课时间：9月8日 18:00";
    _typeLabel.text = type;
}

- (void)updateUIStatus:(NSInteger)survey {
    if (survey != 0) {
        [_topStatusView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(40);
        }];
        
        switch (survey) {
            case 1:
                [_statusButton setImage:[UIImage imageNamed:@"t_q_review_icon"] forState:UIControlStateNormal];
                [_statusButton setTitle:DMTitleTeacherQuestionReviewFild forState:UIControlStateNormal];
                break;
            case 2:
                [_statusButton setImage:[UIImage imageNamed:@"t_q_review_success"] forState:UIControlStateNormal];
                [_statusButton setTitle:DMTitleTeacherQuestionSuccessFild forState:UIControlStateNormal];
                break;
            case 3:
                [_statusButton setImage:[UIImage imageNamed:@"t_q_review_fail"] forState:UIControlStateNormal];
                [_statusButton setTitle:DMTitleTeacherQuestionFailedFild forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (void)updateBottomViewFrame {
    if (_bTableView.contentSize.height > (DMScreenHeight-180)) {
        NSLog(@"1");
        _bottomView.frame = CGRectMake(0, 0, DMScreenWidth, 130);
    } else {
        NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
        if (userIdentity != 0) {
            _bottomView.frame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-180-_bTableView.contentSize.height-(self.myQuestObj.survey.intValue == 3 ? 40: 0));
        } else {
            _bottomView.frame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-180-_bTableView.contentSize.height);
        }
    }
    _commitBtn.frame = CGRectMake((_bottomView.frame.size.width-130)/2, _bottomView.frame.size.height-40-35, 130, 40);
    //_bottomView.backgroundColor = [UIColor randomColor];
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
        cell.tag = indexPath.section;
        DMQuestSingleData *obj = [self.questionList objectAtIndex:indexPath.section];
        [cell configObj:obj indexRow:indexPath.row indexSection:indexPath.section];
        cell.userInteractionEnabled = self.isEditQuest;
    }
    WS(weakSelf);
    cell.clickButtonBlock = ^{
        [weakSelf.bTableView reloadData];
    };
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

    _topImageView = [[UIImageView alloc] init];
    _topImageView.image = [UIImage imageNamed:@"question_bg"];

    UIView *headView2 = [[UIView alloc] init];
    headView2.backgroundColor = [UIColor whiteColor];
    headView2.alpha = 0.1;
    headView2.layer.cornerRadius = 50/2;
    headView2.layer.masksToBounds = YES;
    
    [self.view addSubview:_topImageView];
    [_topImageView addSubview:self.timeLabel];
    [_topImageView addSubview:self.classNameLabel];
    [_topImageView addSubview:self.typeLabel];
    [_topImageView addSubview:headView2];
    [_topImageView addSubview:self.hImageView];
    [_topImageView addSubview:self.nameLabel];
    
    _bTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _bTableView.delegate = self;
    _bTableView.dataSource = self;
    _bTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bTableView.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
    UIView *hV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    hV.backgroundColor = [UIColor whiteColor];
    _bTableView.tableHeaderView = hV;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, 130)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.backgroundColor = DMColorBaseMeiRed;
    [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBtn.titleLabel setFont:DMFontPingFang_Regular(16)];
    [_commitBtn addTarget:self action:@selector(clickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn.layer.cornerRadius = 5;
    _commitBtn.layer.masksToBounds = YES;
    //commitBtn.frame = CGRectMake((_bottomView.frame.size.width-130)/2, (_bottomView.frame.size.height-40)/2+10, 130, 40);
    _commitBtn.frame = CGRectMake((_bottomView.frame.size.width-130)/2, _bottomView.frame.size.height-40-35, 130, 40);
    //[self.view addSubview:bottomView];
    [_bottomView addSubview:_commitBtn];
    
    [self.view addSubview:_bTableView];
    _bottomView.hidden = YES;
    
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    if (userIdentity == 0) {
        
        _teacherCommentsView = [[UIView alloc] init];
        _teacherCommentsView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_teacherCommentsView];
        _teacherCommentsView.hidden = YES;
        
        _tabBarView = [DMTabBarView new];
        _tabBarView.delegate = self;
        _tabBarView.isFullScreen = YES;
        
        self.tabBarView.titles = @[DMTitleStudentQuestionFild, DMTitleTeacherQuestionFild];
        _tabBarView.layer.shadowColor = DMColorWithRGBA(221, 221, 221, 1).CGColor; // shadowColor阴影颜色
        _tabBarView.layer.shadowOffset = CGSizeMake(-3,9); // shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
        _tabBarView.layer.shadowOpacity = 1; // 阴影透明度，默认0
        _tabBarView.layer.shadowRadius = 9; // 阴影半径，默认3
        [self.view addSubview:_tabBarView];
        
    } else {
        _topStatusView = [[UIView alloc] init];
        _topStatusView.backgroundColor = DMColorWithRGBA(225, 140, 40, 1);
        [self.view addSubview:_topStatusView];
        
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.titleLabel.font = DMFontPingFang_Light(15);
        [_statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.topStatusView addSubview:self.statusButton];
        
    }

    [_topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(180);
    }];
    
    if (userIdentity == 0) {
        
        [_tabBarView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topImageView.mas_bottom).offset(0);
            make.left.right.equalTo(self.view);
            make.height.equalTo(50);
        }];
        
        [_bTableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tabBarView.mas_bottom).equalTo(0);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).equalTo(0);
        }];
        
        [_teacherCommentsView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_bTableView);
        }];
        
    } else {
        float Y = 0;
        if (_statusDis) {
            Y = 40;
        }
        
        [_topStatusView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topImageView.mas_bottom).offset(0);
            make.left.right.equalTo(self.view);
            make.height.equalTo(Y);
        }];
        [_statusButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(_topStatusView);
        }];
        [_bTableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topStatusView.mas_bottom).equalTo(0);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).equalTo(0);
        }];
    }

    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topImageView.mas_bottom).offset(-Space_H);
        make.centerX.equalTo(_topImageView);
        make.size.equalTo(CGSizeMake(240, 40));
    }];
    [_classNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topImageView.mas_bottom).offset(-Space_H);
        make.left.equalTo(_topImageView).offset(40);
        make.right.equalTo(_timeLabel.mas_left).offset(-52);
        make.height.equalTo(40);
    }];
    [_typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topImageView.mas_bottom).offset(-Space_H);
        make.left.equalTo(_timeLabel.mas_right).offset(52);
        make.size.equalTo(CGSizeMake(50, 40));
    }];

    float headView2_w = 50;
    float hImageView_v = 7;
    float hImageView_w = 40;
    float name_r = 20;
    if (userIdentity == 1) {
        hImageView_v = 0;
        hImageView_w = 0;
        name_r = 0;
        headView2_w = 0;
    }
    [headView2 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topImageView.mas_bottom).offset(-37);
        make.left.equalTo(_typeLabel.mas_right).offset(2);
        make.size.equalTo(CGSizeMake(headView2_w, headView2_w));
    }];
    [_hImageView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topImageView.mas_bottom).offset(-Space_H);
        make.left.equalTo(_typeLabel.mas_right).offset(hImageView_v);
        make.size.equalTo(CGSizeMake(hImageView_w, hImageView_w));
    }];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topImageView.mas_bottom).offset(-Space_H);
        make.left.equalTo(_hImageView.mas_right).offset(name_r);
        make.right.equalTo(_topImageView.mas_right).offset(-40);
        make.height.equalTo(40);
    }];
    
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
        _timeLabel.layer.borderWidth = .5;
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
/*
 //    bottomView.layer.shadowColor = DMColorWithRGBA(221, 221, 221, 1).CGColor; // shadowColor阴影颜色
 //    bottomView.layer.shadowOffset = CGSizeMake(0,-9); // shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
 //    bottomView.layer.shadowOpacity = 1; // 阴影透明度，默认0
 //    bottomView.layer.shadowRadius = 9; // 阴影半径，默认3
 
 
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
 
 
 */

@end
