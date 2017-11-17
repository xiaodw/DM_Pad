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

@property (nonatomic, strong) UILabel *classInfoLabel;

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
@property (nonatomic, strong) NSString *lessonID;
@end

@implementation DMQuestionViewController

#define Top_H 180
#define Space_H 42

- (void)clickBackQuestion:(BlockQuestionBack)blockQuestionBack {
    self.blockQuestionBack = blockQuestionBack;
}

- (void)leftOneAction:(id)sender {
    if (self.blockQuestionBack) {//推送消息的使用
        //[self.navigationController popViewControllerAnimated:YES];
        self.blockQuestionBack();
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DMTextQuestionnaire;
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    NSLog(@"addchild = %@", self.childViewControllers);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarTransparence];
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
            DMCourseDatasModel *userInfo = [[DMCourseDatasModel alloc] init];
            userInfo.course_name = obj.course_name;
            userInfo.start_time = obj.start_time;
            userInfo.teacher_name = obj.teacher_name;
            userInfo.student_name = obj.student_name;
            [weakSelf updateTopViewInfo:userInfo];
            
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
        
        self.questionList = obj.list;
        
        if (obj.survey.intValue == 1 ||
            obj.survey.intValue == 2 ||
            _currentSegmentTeachSurvey ||
            self.questionList.count==0)
        {
            self.isEditQuest = NO;
        }
        else
        {
            self.isEditQuest = YES;
        }
        
        
        [self.bTableView reloadData];
        if (self.bTableView.tableFooterView == nil && _bottomView) {
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
        obj.content = STR_IS_NIL(data.answer_content)?@"":data.answer_content;
        [array addObject:obj];
    }
    NSArray *dicArray = [DMCommitAnswerData mj_keyValuesArrayWithObjectArray:array];
    [DMApiModel commitQuestAnswer:self.lessonID answers:dicArray block:^(BOOL result) {
        if (result) {
            weakSelf.myQuestObj.survey = @"1";
            NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
            if (userIdentity != 0) {
                [weakSelf updateUIStatus:weakSelf.myQuestObj.survey.intValue];
            }
            [weakSelf updateTableStatus:weakSelf.myQuestObj isNetCallback:NO];
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
    NSString *type = [NSString stringWithFormat:@"%@：", DMStringIDTeacher];
    if (userIdentity != 0) {
        type = [NSString stringWithFormat:@"%@：", DMStringIDStudent];
    }
    _classNameLabel.text = STR_IS_NIL(obj.course_name)?@"":obj.course_name;//@"未来之星1v1--钢琴";
    
    NSString *timeStr = STR_IS_NIL(obj.start_time)?@"": [DMTextStartClassTime stringByAppendingString:[DMTools timeFormatterYMDFromTs:obj.start_time format:DMDateFormatterYMD]];
    
    NSString *nameStr = @"";
    if (userIdentity == 0) {
        nameStr = STR_IS_NIL(obj.teacher_name)?@"":obj.teacher_name;
    } else {
        nameStr = STR_IS_NIL(obj.student_name)?@"":obj.student_name;
    }

    NSString *typeName = [type stringByAppendingString: nameStr];
    _classInfoLabel.text = [[timeStr stringByAppendingString:@"         "] stringByAppendingString:typeName];//9个空格
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

#pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
#define testStre @""
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
    if (section < self.questionList.count) {
        DMQuestSingleData *obj = [self.questionList objectAtIndex:section];
        CGFloat h = [DMTools getContactHeight:obj.name font:DMFontPingFang_Light(15) width:Content_Label_W];
        if (h > 21) {
            return 50+(h-21);
        }
    }
    return 50;
}


- (void)loadUI {

    [self.view addSubview:self.topImageView];
    [_topImageView addSubview:self.classNameLabel];
    [_topImageView addSubview:self.classInfoLabel];
    
    [self.view addSubview:self.bTableView];
    
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    if (userIdentity == 0) {
        [self.view addSubview:self.teacherCommentsView];
        [self.view addSubview:self.tabBarView];
    } else {
        [self.view addSubview:self.topStatusView];
        [self.topStatusView addSubview:self.statusButton];
    }
    
    [_topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).offset(0);
        make.height.equalTo(180);
    }];
    
    [_classNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_topImageView.mas_top).offset(115);
        make.left.equalTo(_topImageView.mas_left).offset(40);
        make.right.equalTo(_topImageView.mas_right).offset(-40);
        make.height.equalTo(40);
    }];
    
    [_classInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_classNameLabel.mas_bottom).offset(11);
        make.left.right.equalTo(_classNameLabel).offset(0);
        make.height.equalTo(22);
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
            make.left.right.equalTo(self.view).equalTo(0);
            make.bottom.equalTo(self.view).equalTo(0);
        }];
    }

}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"question_bg"];
    }
    return _topImageView;
}

- (UILabel *)classNameLabel {
    if (!_classNameLabel) {
        _classNameLabel = [[UILabel alloc] init];
        _classNameLabel.textAlignment = NSTextAlignmentCenter;
        _classNameLabel.textColor = [UIColor whiteColor];
        _classNameLabel.font = DMFontPingFang_Regular(18);
    }
    return _classNameLabel;
}

- (UILabel *)classInfoLabel {
    if (!_classInfoLabel) {
        _classInfoLabel = [[UILabel alloc] init];
        _classInfoLabel.textAlignment = NSTextAlignmentCenter;
        _classInfoLabel.textColor = [UIColor whiteColor];
        _classInfoLabel.font = DMFontPingFang_Thin(14);
    }
    return _classInfoLabel;
}

- (UITableView *)bTableView {
    if (!_bTableView) {
        _bTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bTableView.delegate = self;
        _bTableView.dataSource = self;
        _bTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bTableView.backgroundColor = [UIColor whiteColor];
        UIView *hV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        hV.backgroundColor = [UIColor whiteColor];
        _bTableView.tableHeaderView = hV;
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, 130)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        
        self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = DMColorBaseMeiRed;
        [_commitBtn setTitle:DMTitleSubmit forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn.titleLabel setFont:DMFontPingFang_Regular(16)];
        [_commitBtn addTarget:self action:@selector(clickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 5;
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.frame = CGRectMake((_bottomView.frame.size.width-130)/2, (_bottomView.frame.size.height-40)/2+10, 130, 40);
        [_bottomView addSubview:_commitBtn];
        _bottomView.hidden = YES;
    }
    return _bTableView;
}

- (UIView *)teacherCommentsView {
    if (!_teacherCommentsView) {
        _teacherCommentsView = [[UIView alloc] init];
        _teacherCommentsView.backgroundColor = [UIColor whiteColor];
        _teacherCommentsView.hidden = YES;
    }
    return _teacherCommentsView;
}

- (DMTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [DMTabBarView new];
        _tabBarView.delegate = self;
        _tabBarView.isFullScreen = YES;
        
        self.tabBarView.titles = @[DMTitleStudentQuestionFild, DMTitleTeacherQuestionFild];
        _tabBarView.layer.shadowColor = DMColorWithRGBA(221, 221, 221, 1).CGColor; // shadowColor阴影颜色
        _tabBarView.layer.shadowOffset = CGSizeMake(-3,9); // shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
        _tabBarView.layer.shadowOpacity = 1; // 阴影透明度，默认0
        _tabBarView.layer.shadowRadius = 9; // 阴影半径，默认3
    }
    return _tabBarView;
}

- (UIView *)topStatusView {
    if (!_topStatusView) {
        _topStatusView = [[UIView alloc] init];
        _topStatusView.backgroundColor = DMColorWithRGBA(225, 140, 40, 1);
    }
    return _topStatusView;
}

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.titleLabel.font = DMFontPingFang_Light(15);
        [_statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _statusButton.userInteractionEnabled = NO;
    }
    return _statusButton;
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
