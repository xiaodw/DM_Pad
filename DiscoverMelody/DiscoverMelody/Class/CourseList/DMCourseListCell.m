#import "DMCourseListCell.h"
#import "DMButton.h"

#define kColor51 DMColorWithRGBA(51, 51, 51, 1)
#define kColor153 DMColorWithRGBA(153, 153, 153, 1)
#define kColorGreen DMColorWithRGBA(99, 213, 105, 1)
#define kColorRed DMColorWithRGBA(246, 8, 122, 1)
#define kColor204 DMColorWithRGBA(204, 204, 204, 1)

NSString *const kStatusTextKey = @"StatusTextKey";
NSString *const kStatusColorKey = @"StatusColorKey";

typedef NS_ENUM(NSInteger, DMCourseStatus) {
    DMCourseStatusWillStart, // 尚未开始
    DMCourseStatusInClass, // 上课中
    DMCourseStatusEnd, // 课程结束
    DMCourseStatusCanceled, // 本课取消
    DMCourseStatusRelook // 回顾
};

@interface DMCourseListCell ()

@property (strong, nonatomic) UILabel *numberLabel; // 课程编号
@property (strong, nonatomic) UILabel *nameLabel; // 课程名称
@property (strong, nonatomic) UILabel *studentNameLabel; // 学生名
@property (strong, nonatomic) UILabel *dateLabel; // 日期
@property (strong, nonatomic) UILabel *detailDateLabel; // 时间
@property (strong, nonatomic) UILabel *periodLabel; // 课时
@property (strong, nonatomic) UILabel *statusLabel; // 状态
@property (strong, nonatomic) DMButton *statusButton; // 状态
@property (strong, nonatomic) UIView *filesPositionView; // 课程文件自使用适应宽度的一个view
@property (strong, nonatomic) UIButton *filesButton; // 课程文件
@property (strong, nonatomic) UIView *questionnairePositionView; // 调查问卷自使用适应宽度的一个view
@property (strong, nonatomic) UIButton *questionnaireButton; // 调查问卷

@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) NSArray *courseStatus;

@end

@implementation DMCourseListCell

- (void)setModel:(NSObject *)model {
    NSInteger random = arc4random_uniform(5);
    DMLog(@"%zd", random);
    
    
    _numberLabel.text = [NSString stringWithFormat:@"    %@", @"1234567"];
    _nameLabel.text = @"未来之星1V1--钢琴";
    _studentNameLabel.text = @"frank";
    _dateLabel.text = @"2017/2/22";
    _detailDateLabel.text = @"09:00-10:00";
    _periodLabel.text = @"1hr";
    _statusLabel.hidden = random == DMCourseStatusRelook;
    _statusButton.hidden = !_statusLabel.hidden;
    if(random < DMCourseStatusRelook) {
        NSDictionary *statusDict = self.courseStatus[random];
        NSString *text = statusDict[kStatusTextKey];
        UIColor *textColor = statusDict[kStatusColorKey];
        _statusLabel.text = text;
        _statusLabel.textColor = textColor;
    }
    
    _filesButton.enabled = random;
    
    UIImage *normalImage = [UIImage imageNamed:@"icon_questionnaire_normal"];
    if(random == 1) {
        normalImage = [UIImage imageNamed:@"icon_questionnaire_selected"];
    }
    if(random == 2) {
        normalImage = [UIImage imageNamed:@"icon_questionnaire_disabled"];
    }
    [_questionnaireButton setImage:normalImage forState:UIControlStateNormal];
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
    [self.contentView addSubview:self.filesPositionView];
    [self.contentView addSubview:self.filesButton];
    [self.contentView addSubview:self.questionnairePositionView];
    [self.contentView addSubview:self.questionnaireButton];
    [self.contentView addSubview:self.separatorView];
}

- (void)setupMakeLayoutSubviews {
    [_numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(80));
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numberLabel.mas_right).offset(30);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(144));
    }];
    
    [_studentNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(30);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(58));
    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_studentNameLabel.mas_right).offset(30);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(108));
    }];
    
    [_detailDateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(130));
    }];
    
    [_periodLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_detailDateLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(66));
    }];
    
    [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_periodLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(DMScaleWidth(140));
    }];
    
    [_statusButton makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_statusLabel);
        make.size.equalTo(CGSizeMake(63, 30));
    }];
    
    [_filesPositionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusLabel.mas_right);
        make.height.equalTo(2);
        make.width.equalTo(DMScaleWidth(76));
        make.bottom.equalTo(self.contentView);
    }];
    
    [_filesButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_filesPositionView);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(22, 20));
    }];
    
    [_questionnairePositionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_filesPositionView.mas_right);
        make.height.equalTo(2);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_questionnaireButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_questionnairePositionView);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(21, 23));
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
        _statusButton.layer.borderColor = kColorRed.CGColor;
        _statusButton.layer.borderWidth = 0.5;
        _statusButton.titleLabel.font = DMFontPingFang_Light(14);
        [_statusButton setTitleColor:kColorRed forState:UIControlStateNormal];
        [_statusButton setTitle:@"回顾" forState:UIControlStateNormal];
        [_statusButton setImage:[UIImage imageNamed:@"btn_relook_arrow_right"] forState:UIControlStateNormal];
    }
    
    return _statusButton;
}

- (UIView *)setupPositionView {
    UIView *positionView = [UIView new];
    positionView.hidden = YES;
    
    return positionView;
}

- (UIView *)filesPositionView {
    if (!_filesPositionView) {
        _filesPositionView = [self setupPositionView];
    }
    
    return _filesPositionView;
}

- (UIButton *)filesButton {
    if (!_filesButton) {
        _filesButton = [UIButton new];
        [_filesButton setImage:[UIImage imageNamed:@"icon_file_normal"] forState:UIControlStateNormal];
        [_filesButton setImage:[UIImage imageNamed:@"icon_file_disabled"] forState:UIControlStateDisabled];
    }
    
    return _filesButton;
}

- (UIView *)questionnairePositionView {
    if (!_questionnairePositionView) {
        _questionnairePositionView = [self setupPositionView];
    }
    
    return _questionnairePositionView;
}

- (UIButton *)questionnaireButton {
    if (!_questionnaireButton) {
        _questionnaireButton = [UIButton new];
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
        NSDictionary *willStartDict = @{kStatusTextKey: @"尚未开始", kStatusColorKey: kColor51};
        NSDictionary *inClassDict = @{kStatusTextKey: @"上课中...", kStatusColorKey: kColorGreen};
        NSDictionary *endDict = @{kStatusTextKey: @"课程结束", kStatusColorKey: kColor153};
        NSDictionary *canceledDict = @{kStatusTextKey: @"本课取消", kStatusColorKey: kColor204};
        _courseStatus = @[willStartDict, inClassDict, endDict, canceledDict];
    }
    
    return _courseStatus;
}

@end