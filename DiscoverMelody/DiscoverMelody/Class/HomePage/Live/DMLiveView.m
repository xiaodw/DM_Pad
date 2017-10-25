#import "DMLiveView.h"
#import "DMMicrophoneView.h"

#define kColor33 DMColorWithRGBA(33, 33, 33, 1)
#define kColor06 DMColorWithRGBA(06, 06, 06, 1)

@interface DMLiveView ()

@property (strong, nonatomic) UIView *view; // 播放的view
@property (strong, nonatomic) UIImageView *shadowImageView; // 右侧的阴影
@property (strong, nonatomic) DMMicrophoneView *microphoneView; // 麦克风
@property (strong, nonatomic) UIImageView *placeholderIconView; // 占位图标
@property (strong, nonatomic) UILabel *placeholderTitleLabel; // 占位文字

@end

@implementation DMLiveView

- (void)setShowPlaceholder:(BOOL)showPlaceholder {
    _showPlaceholder = showPlaceholder;
    self.placeholderIconView.hidden = !showPlaceholder;
    self.placeholderTitleLabel.hidden = self.placeholderIconView.hidden;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    self.placeholderIconView.image = placeholderImage;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.placeholderTitleLabel.text = placeholderText;
}

- (void)setMode:(DMLiveViewMode)mode {
    _mode = mode;
    
    UIFont *titleFont = DMFontPingFang_Light(20);
    UIColor *backgroundColor = kColor33;
    
    if (mode == DMLiveViewSmall) {
        [_placeholderIconView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(52);
            make.size.equalTo(CGSizeMake(45, 45));
            make.centerX.equalTo(self);
        }];
        
        [_placeholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_placeholderIconView.mas_bottom).offset(15);
            make.left.equalTo(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        titleFont = DMFontPingFang_Light(16);
        backgroundColor = kColor06;
        
    } else if (mode == DMLiveViewFull) {
        [_placeholderIconView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(290);
            make.size.equalTo(CGSizeMake(154, 154));
            make.centerX.equalTo(self);
        }];
        
        [_placeholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_placeholderIconView.mas_bottom).offset(45);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
    } else if (mode == DMLiveViewBalanceTB) {
        CGFloat remotePHVTop = (DMScreenHeight - DMScaleWidth(385)) * 0.5 + 95;
        [_placeholderIconView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remotePHVTop);
            make.size.equalTo(CGSizeMake(154, 154));
            make.centerX.equalTo(self);
        }];
        
        [_placeholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_placeholderIconView.mas_bottom).offset(39);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        titleFont = DMFontPingFang_Light(16);
        backgroundColor = kColor06;
        
    } else if (mode == DMLiveViewBalanceLR) {
        [_placeholderIconView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(100);
            make.size.equalTo(CGSizeMake(154, 154));
            make.centerX.equalTo(self);
        }];
        
        [_placeholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_placeholderIconView.mas_bottom).offset(28);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        titleFont = DMFontPingFang_Light(16);
        backgroundColor = kColor06;
        
    }
    self.userInteractionEnabled = mode != DMLiveViewFull;
    _placeholderTitleLabel.font = titleFont;
    self.backgroundColor = backgroundColor;
    _view.backgroundColor = self.backgroundColor;
}

- (void)setVoiceValue:(CGFloat)voiceValue {
    _voiceValue = voiceValue;
    self.microphoneView.voiceValue = voiceValue;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.view];
    [self addSubview:self.placeholderIconView];
    [self addSubview:self.placeholderTitleLabel];
    [self addSubview:self.shadowImageView];
    [self addSubview:self.microphoneView];
}

- (void)setupMakeLayoutSubviews {
    [_view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_shadowImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.equalTo(CGSizeMake(35, 25));
    }];
    
    [_microphoneView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(17, 25));
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
}

- (UIView *)view {
    if (!_view) {
        _view = [UIView new];
        _view.userInteractionEnabled = YES;
    }
    
    return _view;
}

- (DMMicrophoneView *)microphoneView {
    if (!_microphoneView) {
        _microphoneView = [DMMicrophoneView new];
    }
    
    return _microphoneView;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [UIImageView new];
        _shadowImageView.image = [UIImage imageNamed:@"image_shadowRigthToLeft"];
    }
    
    return _shadowImageView;
}

- (UIImageView *)placeholderIconView {
    if (!_placeholderIconView) {
        _placeholderIconView = [UIImageView new];
    }
    
    return _placeholderIconView;
}

- (UILabel *)placeholderTitleLabel {
    if (!_placeholderTitleLabel) {
        _placeholderTitleLabel = [UILabel new];
        _placeholderTitleLabel.numberOfLines = 0;
        _placeholderTitleLabel.textColor = DMColor102;
        _placeholderTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _placeholderTitleLabel;
}

@end

