#import "DMLiveView.h"
#import "DMMicrophoneView.h"

@interface DMLiveView ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) DMMicrophoneView *microphoneView;
@property (strong, nonatomic) UIImageView *microphoneShadow;
@property (strong, nonatomic) UIImageView *placeholderIconView;
@property (strong, nonatomic) UILabel *placeholderTitleLabel;
@end

@implementation DMLiveView

- (void)setMode:(DMLiveViewMode)mode {
    _mode = mode;
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
    
}

- (void)setupMakeLayoutSubviews {
    
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
    }
    
    return _backgroundView;
}

- (DMMicrophoneView *)microphoneView {
    if (!_microphoneView) {
        _microphoneView = [DMMicrophoneView new];
    }
    
    return _microphoneView;
}

- (UIImageView *)microphoneShadow {
    if (!_microphoneShadow) {
        _microphoneShadow = [UIImageView new];
    }
    
    return _microphoneShadow;
}

@end
