#import "DMCourseListCell.h"


typedef NS_ENUM(NSInteger, DMCourseStatus) {
    DMCourseStatusWillStart, // 没开始
    DMCourseStatusInClass, // 上课中
    DMCourseStatusEnd, // 结束
    DMCourseStatusCanceled, // 取消
    DMCourseStatusRelook // 回看
};

@interface DMCourseListCell ()

@property (strong, nonatomic) UILabel *numberLabel; // 课程编号
@property (strong, nonatomic) UILabel *nameLabel; // 课程名称
@property (strong, nonatomic) UILabel *studentNameLabel; // 学生名
@property (strong, nonatomic) UILabel *dateLabel; // 日期
@property (strong, nonatomic) UILabel *detailDateLabel; // 时间
@property (strong, nonatomic) UILabel *periodLabel; // 课时
@property (strong, nonatomic) UILabel *statusLabel; // 状态
@property (strong, nonatomic) UIButton *statusButton; // 状态
@property (strong, nonatomic) UIButton *filesButton; // 课程文件
@property (strong, nonatomic) UIImageView *questionnaireImageView; // 调查问卷

@end

@implementation DMCourseListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    [self.contentView addSubview:self.filesButton];
    [self.contentView addSubview:self.questionnaireImageView];
}

- (void)setupMakeLayoutSubviews {
    
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
    }
    
    return _numberLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    
    return _nameLabel;
}
- (UILabel *)studentNameLabel {
    if (!_studentNameLabel) {
        _studentNameLabel = [UILabel new];
    }
    
    return _studentNameLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
    }
    
    return _dateLabel;
}

- (UILabel *)detailDateLabel {
    if (!_detailDateLabel) {
        _detailDateLabel = [UILabel new];
    }
    
    return _detailDateLabel;
}

- (UILabel *)periodLabel {
    if (!_periodLabel) {
        _periodLabel = [UILabel new];
    }
    
    return _periodLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
    }
    
    return _statusLabel;
}

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [UIButton new];
    }
    
    return _statusButton;
}

- (UIButton *)filesButton {
    if (!_filesButton) {
        _filesButton = [UIButton new];
    }
    
    return _filesButton;
}

- (UIImageView *)questionnaireImageView {
    if (!_questionnaireImageView) {
        _questionnaireImageView = [UIImageView new];
    }
    
    return _questionnaireImageView;
}

@end
