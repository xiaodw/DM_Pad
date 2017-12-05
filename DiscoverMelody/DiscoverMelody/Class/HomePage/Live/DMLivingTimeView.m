#import "DMLivingTimeView.h"
#import "DMButton.h"

@interface DMLivingTimeView ()

@property (strong, nonatomic) UIImageView *shadowImageView; // 底部的阴影
@property (strong, nonatomic) DMButton *timeButton; // 底部时间条: 图标
@property (strong, nonatomic) UILabel *alreadyTimeLabel; // 底部时间条: 过了多少时间
@property (strong, nonatomic) UIImageView *alreadyTimeShadowImageView; // 底部时间条阴影
@property (strong, nonatomic) UILabel *describeTimeLabel; // 底部时间条: 提示

@end

@implementation DMLivingTimeView

- (void)setDescribeTime:(NSString *)describeTime {
    _describeTime = describeTime;
    _describeTimeLabel.text = _describeTime;
}

- (void)setAlreadyTimeColor:(UIColor *)alreadyTimeColor {
    _alreadyTimeColor = alreadyTimeColor;
    _alreadyTimeLabel.textColor = alreadyTimeColor;
}

- (void)setAlreadyTime:(NSString *)alreadyTime {
    _alreadyTime = alreadyTime;
    _alreadyTimeLabel.text = alreadyTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.shadowImageView];
    [self addSubview:self.timeButton];
    [self addSubview:self.alreadyTimeLabel];
    [self addSubview:self.describeTimeLabel];
}

- (void)setupMakeLayoutSubviews {
    [_shadowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_timeButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(23);
        make.size.equalTo(CGSizeMake(19, 19));
    }];
    
    [_alreadyTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeButton.mas_right).offset(10);
        make.centerY.equalTo(_timeButton);
    }];
    
    [_describeTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(120);
        make.centerY.equalTo(_timeButton);
    }];
}

- (DMButton *)timeButton {
    if (!_timeButton) {
        _timeButton = [DMNotHighlightedButton new];
        [_timeButton setImage:[UIImage imageNamed:@"icon_time_white"] forState:UIControlStateNormal];
        [_timeButton setImage:[UIImage imageNamed:@"icon_time_red"] forState:UIControlStateSelected];
    }
    
    return _timeButton;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [UIImageView new];
        _shadowImageView.image = [UIImage imageNamed:@"image_shadowBottomToTop"];
    }
    
    return _shadowImageView;
}

- (UILabel *)alreadyTimeLabel {
    if (!_alreadyTimeLabel) {
        _alreadyTimeLabel = [UILabel new];
        _alreadyTimeLabel.textColor = [UIColor whiteColor];
        _alreadyTimeLabel.font = DMFontPingFang_Light(14);
    }
    
    return _alreadyTimeLabel;
}

- (UILabel *)describeTimeLabel {
    if (!_describeTimeLabel) {
        _describeTimeLabel = [UILabel new];
        _describeTimeLabel.textColor = DMColorBaseMeiRed;
        _describeTimeLabel.font = DMFontPingFang_Light(14);
    }
    
    return _describeTimeLabel;
}

@end
