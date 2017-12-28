#import "DMCourseListCell.h"
#import "DMButton.h"

#define kColor51 DMColorWithRGBA(51, 51, 51, 1)
#define kColor153 DMColorWithRGBA(153, 153, 153, 1)
#define kColorGreen DMColorWithRGBA(99, 213, 105, 1)
#define kColor204 DMColorWithRGBA(204, 204, 204, 1)

NSString *const kStatusTextKey = @"StatusTextKey";
NSString *const kStatusColorKey = @"StatusColorKey";

typedef NS_ENUM(NSInteger, DMCourseStatus) {
    DMCourseStatusWillStart, // 尚未开始
    DMCourseStatusInClass, // 上课中
    DMCourseStatusEnd, // 课程结束
    DMCourseStatusCanceled, // 本课取消
    DMCourseStatusRelook, // 回顾
    DMCourseStatusAll // 全部
};

@interface DMCourseListCell ()

@property (strong, nonatomic) UILabel *numberLabel; // 课程编号
@property (strong, nonatomic) UILabel *nameLabel; // 课程名称
@property (strong, nonatomic) UILabel *studentNameLabel; // 学生名
@property (strong, nonatomic) UILabel *dateLabel; // 日期
@property (strong, nonatomic) UILabel *detailDateLabel; // 时间
@property (strong, nonatomic) UILabel *periodLabel; // 课时
@property (strong, nonatomic) UILabel *statusLabel; // 状态: 标签
@property (strong, nonatomic) DMButton *statusButton; // 状态: 回看
@property (strong, nonatomic) UIView *filesPlaceholderView; // 课程文件占位view
@property (strong, nonatomic) UIButton *filesButton; // 课程文件
@property (strong, nonatomic) UIView *questionnairePlaceholderView; // 调查问卷占位view
@property (strong, nonatomic) UIButton *questionnaireButton; // 调查问卷

@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) NSArray *courseStatus;

@end

@implementation DMCourseListCell

- (void)setModel:(DMCourseDatasModel *)model {
    //课程状态
    NSInteger live_status = [model.live_status intValue];
    
    _numberLabel.text = [NSString stringWithFormat:@"    %@", model.lesson_id];
    _nameLabel.text = model.course_name;
    
    NSInteger userIdentity = [[DMAccount getUserIdentity] intValue];
    _studentNameLabel.text = (userIdentity == 0 ? model.teacher_name: model.student_name);
    _dateLabel.text = [DMTools timeFormatterYMDFromTs:model.start_time format:@"yyyy/MM/dd"];
    _detailDateLabel.text = [DMTools computationsPeriodOfTime:model.start_time duration:model.duration];
    _periodLabel.text = [[DMTools secondsConvertMinutes:model.duration] stringByAppendingString:DMTextMinutes];
    _statusLabel.hidden = NO;
    _filesButton.enabled = YES;
    _questionnaireButton.enabled = YES;
    
    if (live_status == DMCourseStatusEnd && [model.playback_status intValue] == 1) {
        //课程结束，并且 可回放状态，则显示回顾按钮
        _statusLabel.hidden = YES;
    }
    _statusButton.hidden = !_statusLabel.hidden;
    
    if(_statusButton.hidden) { //回顾按钮隐藏
        NSDictionary *statusDict = self.courseStatus[live_status%DMCourseStatusAll];
        NSString *text = statusDict[kStatusTextKey];
        UIColor *textColor = statusDict[kStatusColorKey];
        _statusLabel.text = text;
        _statusLabel.textColor = textColor;
    }
    
    NSInteger surveyEdit = [model.survey_edit intValue]; //0 不可点，1 ，2 可点击
    
    UIImage *normalImage = [UIImage imageNamed:@"icon_questionnaire_normal"];
    if (surveyEdit == 0) {
        _questionnaireButton.enabled = NO;
    }
    else if(surveyEdit == 1) {
        normalImage = [UIImage imageNamed:@"icon_questionnaire_selected"];
    }
    else if(surveyEdit == 2) {
        normalImage = [UIImage imageNamed:@"icon_questionnaire_disabled"];
    }
    [_questionnaireButton setImage:normalImage forState:UIControlStateNormal];
    
    if (live_status == DMCourseStatusCanceled) { //课程取消，文件和调查问卷 不可点
        _filesButton.enabled = NO;
        //_questionnaireButton.enabled = NO;
    }
}

- (void)didTapRelook {
    if (![self.delegate respondsToSelector:@selector(courseListCellDidTapRelook:)]) return;
    
    [self.delegate courseListCellDidTapRelook:self];
}

- (void)didTapFiles {
    if (![self.delegate respondsToSelector:@selector(courseListCellDidTapCoursesFiles:)]) return;
    
    [self.delegate courseListCellDidTapCoursesFiles:self];
}

- (void)didTapQuestionnaire {
    if (![self.delegate respondsToSelector:@selector(courseListCellDidTapQuestionnaire:)]) return;
    
    [self.delegate courseListCellDidTapQuestionnaire:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.studentNameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.detailDateLabel];
    [self.contentView addSubview:self.periodLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.statusButton];
    [self.contentView addSubview:self.filesPlaceholderView];
    [self.contentView addSubview:self.filesButton];
    [self.contentView addSubview:self.questionnairePlaceholderView];
    [self.contentView addSubview:self.questionnaireButton];
    [self.contentView addSubview:self.separatorView];
}

- (void)setupMakeLayoutSubviews {
    [_numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(70));
    }];
    
    [_questionnairePlaceholderView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(DMScaleWidth(70));
        make.height.equalTo(2);
        make.right.equalTo(self.contentView.mas_right).offset(-DMScaleWidth(16));
        make.bottom.equalTo(self.contentView);
    }];
    
    [_questionnaireButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_questionnairePlaceholderView);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(DMScaleWidth(21), 23));
    }];

    [_filesPlaceholderView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_questionnairePlaceholderView.mas_left);
        make.height.equalTo(2);
        make.width.equalTo(DMScaleWidth(70));
        make.bottom.equalTo(self.contentView);
    }];

    [_filesButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_filesPlaceholderView);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(DMScaleWidth(22), 20));
    }];

    [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_filesPlaceholderView.mas_left);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(100));
    }];

    [_statusButton makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_statusLabel);
        make.size.equalTo(CGSizeMake(DMScaleWidth(DMCourseListCellStatusButtonWidth), 30));
    }];

    [_periodLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_statusLabel.mas_left);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(66));
    }];

    [_detailDateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_periodLabel.mas_left);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(130));
    }];

    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_detailDateLabel.mas_left).offset(-DMScaleWidth(10));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(90));
    }];

    [_studentNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dateLabel.mas_left).offset(-DMScaleWidth(20));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(120));
    }];

    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numberLabel.mas_right).offset(DMScaleWidth(15));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(_studentNameLabel.mas_left).offset(-DMScaleWidth(20));
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.5);
    }];
}

- (UILabel *)setupLabel {
    UILabel *label = [UILabel new];
    label.font = DMFontPingFang_Light(14);
    label.textColor = kColor51;
    return label;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [self setupLabel];
    }
    
    return _numberLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [self setupLabel];
    }
    
    return _nameLabel;
}
- (UILabel *)studentNameLabel {
    if (!_studentNameLabel) {
        _studentNameLabel = [self setupLabel];
    }
    
    return _studentNameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [self setupLabel];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _dateLabel;
}

- (UILabel *)detailDateLabel {
    if (!_detailDateLabel) {
        _detailDateLabel = [self setupLabel];
        _detailDateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _detailDateLabel;
}

- (UILabel *)periodLabel {
    if (!_periodLabel) {
        _periodLabel = [self setupLabel];
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _periodLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.font = DMFontPingFang_Light(14);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _statusLabel;
}

- (DMButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [DMButton new];
        _statusButton.spacing = 7;
        _statusButton.layer.cornerRadius = 5;
        _statusButton.layer.borderColor = DMColorBaseMeiRed.CGColor;
        _statusButton.layer.borderWidth = 0.5;
        _statusButton.titleLabel.font = DMFontPingFang_Light(14);
        [_statusButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_statusButton setTitle:DMTitleClassRelook forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"btn_relook_arrow_right"] forState:UIControlStateNormal];
        [_statusButton addTarget:self action:@selector(didTapRelook) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _statusButton;
}

- (UIView *)setupPlaceholderView {
    UIView *positionView = [UIView new];
    positionView.hidden = YES;
    
    return positionView;
}

- (UIView *)filesPlaceholderView {
    if (!_filesPlaceholderView) {
        _filesPlaceholderView = [self setupPlaceholderView];
    }
    
    return _filesPlaceholderView;
}

- (UIButton *)filesButton {
    if (!_filesButton) {
        _filesButton = [UIButton new];
        [_filesButton setImage:[UIImage imageNamed:@"icon_file_normal"] forState:UIControlStateNormal];
        [_filesButton setImage:[UIImage imageNamed:@"icon_file_disabled"] forState:UIControlStateDisabled];
        [_filesButton addTarget:self action:@selector(didTapFiles) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _filesButton;
}

- (UIView *)questionnairePlaceholderView {
    if (!_questionnairePlaceholderView) {
        _questionnairePlaceholderView = [self setupPlaceholderView];
    }
    
    return _questionnairePlaceholderView;
}

- (UIButton *)questionnaireButton {
    if (!_questionnaireButton) {
        _questionnaireButton = [UIButton new];
        [_questionnaireButton addTarget:self action:@selector(didTapQuestionnaire) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _questionnaireButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = DMColorWithRGBA(221, 221, 221, 1);
    }
    
    return _separatorView;
}

- (NSArray *)courseStatus {
    if (!_courseStatus) {
        NSDictionary *willStartDict = @{kStatusTextKey: DMKeyStatusNotStart, kStatusColorKey: kColor51};
        NSDictionary *inClassDict = @{kStatusTextKey: DMKeyStatusInclass, kStatusColorKey: kColorGreen};
        NSDictionary *endDict = @{kStatusTextKey: DMKeyStatusClassEnd, kStatusColorKey: kColor153};
        NSDictionary *canceledDict = @{kStatusTextKey: DMKeyStatusClassCancel, kStatusColorKey: kColor204};
        _courseStatus = @[willStartDict, inClassDict, endDict, canceledDict];
    }
    
    return _courseStatus;
}

@end
