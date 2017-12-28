#import "DMCourseListHeaderView.h"

#define kColor153 DMColorWithRGBA(153, 153, 153, 1)
#define kColor215 DMColorWithRGBA(215, 215, 215, 1)

@interface DMCourseListHeaderView()

@property (strong, nonatomic) UILabel *numberLabel; // 课程编号
@property (strong, nonatomic) UILabel *nameLabel; // 课程名称
@property (strong, nonatomic) UILabel *studentNameLabel; // 学生名
@property (strong, nonatomic) UILabel *dateLabel; // 日期
@property (strong, nonatomic) UILabel *detailDateLabel; // 时间
@property (strong, nonatomic) UILabel *periodLabel; // 课时
@property (strong, nonatomic) UILabel *statusLabel; // 状态
@property (strong, nonatomic) UILabel *filesLabel; // 课程文件
@property (strong, nonatomic) UILabel *questionnaireLabel; // 调查问卷

@end

@implementation DMCourseListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColor215;
        
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.numberLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.studentNameLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.detailDateLabel];
    [self addSubview:self.periodLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.filesLabel];
    [self addSubview:self.questionnaireLabel];
}

- (void)setupMakeLayoutSubviews {
    [_numberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(85));
    }];
    
    [_questionnaireLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(70));
        make.right.equalTo(self.mas_right).offset(-DMScaleWidth(16));
    }];
    
    [_filesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_questionnaireLabel.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(70));
    }];
    
    [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_filesLabel.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(100));
    }];
    
    [_periodLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_statusLabel.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(66));
    }];
    
    [_detailDateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_periodLabel.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(130));
    }];
    
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_detailDateLabel.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(110));
    }];
    
    [_studentNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dateLabel.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(DMScaleWidth(130));
    }];

    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_studentNameLabel.mas_left);
        make.left.equalTo(_numberLabel.mas_right);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)setupLabel {
    UILabel *label = [UILabel new];
    label.font = DMFontPingFang_Light(14);
    label.textColor = kColor153;
    return label;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [self setupLabel];
        _numberLabel.text = [NSString stringWithFormat:@"   %@", DMTextClassNumber];
    }
    
    return _numberLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [self setupLabel];
        _nameLabel.text = DMTextClassName;
    }
    
    return _nameLabel;
}

- (UILabel *)studentNameLabel {
    if (!_studentNameLabel) {
        _studentNameLabel = [self setupLabel];
        NSInteger userIdentity = [[DMAccount getUserIdentity] intValue];
        _studentNameLabel.text = (userIdentity==0 ? DMTextTeacherName:DMTextStudentName);
    }
    
    return _studentNameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [self setupLabel];
        _dateLabel.text = DMTextDate;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _dateLabel;
}

- (UILabel *)detailDateLabel {
    if (!_detailDateLabel) {
        _detailDateLabel = [self setupLabel];
        _detailDateLabel.text = DMTextDetailDate;
        _detailDateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _detailDateLabel;
}

- (UILabel *)periodLabel {
    if (!_periodLabel) {
        _periodLabel = [self setupLabel];
        _periodLabel.text = DMTextPeriod;
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _periodLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [self setupLabel];
        _statusLabel.text = DMTextStauts;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _statusLabel;
}

- (UILabel *)filesLabel {
    if (!_filesLabel) {
        _filesLabel = [self setupLabel];
        _filesLabel.text = DMTextFiles;
        _filesLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _filesLabel;
}

- (UILabel *)questionnaireLabel {
    if (!_questionnaireLabel) {
        _questionnaireLabel = [self setupLabel];
        _questionnaireLabel.text = DMTextQuestionnaire;
        _questionnaireLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _questionnaireLabel;
}

@end
