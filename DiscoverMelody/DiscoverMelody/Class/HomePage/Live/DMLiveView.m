#import "DMLiveView.h"
#import "DMMicrophoneView.h"

#define kColor33 DMColorWithRGBA(33, 33, 33, 1)
#define kColor06 DMColorWithRGBA(06, 06, 06, 1)

@interface DMLiveView ()

@property (strong, nonatomic) UIView *view; // 播放的view
@property (strong, nonatomic) UIImageView *shadowImageView; // 右侧的阴影
@property (strong, nonatomic) DMMicrophoneView *microphoneView; // 麦克风
@property (strong, nonatomic) UIImageView *placeholderIconView; // 占位图标

@end

@implementation DMLiveView

- (void)setShowPlaceholder:(BOOL)showPlaceholder {
    _showPlaceholder = showPlaceholder;
    self.placeholderIconView.hidden = !showPlaceholder;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    self.placeholderIconView.image = placeholderImage;
}

- (void)setMode:(DMLiveViewMode)mode {
    _mode = mode;
    
    UIFont *titleFont = DMFontPingFang_Light(16);
    UIColor *backgroundColor = kColor06;
    CGSize size = CGSizeMake(154, 154);
    
    if (mode == DMLiveViewSmall) {
        size = CGSizeMake(65, 65);
    }
    
    if (mode == DMLiveViewFull) {
        titleFont = DMFontPingFang_Light(20);
        backgroundColor = kColor33;
    }
    
    [_placeholderIconView remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(size);
        make.center.equalTo(self);
    }];
    
    self.userInteractionEnabled = mode != DMLiveViewFull;
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

@end

