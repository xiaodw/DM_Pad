#import "DMLiveButtonControlView.h"

@interface DMLiveButtonControlView ()

@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) UIButton *leaveChannelButton;
@property (strong, nonatomic) UIButton *swichCameraButton;
@property (strong, nonatomic) UIButton *swichLayoutButton;
@property (strong, nonatomic) UIButton *courseFilesButton;

@end

@implementation DMLiveButtonControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)didTapLeave {
    if (![self.delegate respondsToSelector:@selector(liveButtonControlViewDidTapLeave:)]) return;
    [self.delegate liveButtonControlViewDidTapLeave:self];
}

- (void)didTapSwichCamera {
    if (![self.delegate respondsToSelector:@selector(liveButtonControlViewDidTapSwichCamera:)]) return;
    [self.delegate liveButtonControlViewDidTapSwichCamera:self];
}

- (void)didTapSwichLayout {
    if (![self.delegate respondsToSelector:@selector(liveButtonControlViewDidTapSwichLayout:)]) return;
    [self.delegate liveButtonControlViewDidTapSwichLayout:self];
}

- (void)didTapCourseFiles {
    if (![self.delegate respondsToSelector:@selector(liveButtonControlViewDidTapCourseFiles:)]) return;
    [self.delegate liveButtonControlViewDidTapCourseFiles:self];
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.shadowImageView];
    [self addSubview:self.leaveChannelButton];
    [self addSubview:self.swichCameraButton];
    [self addSubview:self.swichLayoutButton];
    [self addSubview:self.courseFilesButton];
}

- (void)setupMakeLayoutSubviews {
    [_shadowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_leaveChannelButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(23);
        make.top.equalTo(30);
        make.size.equalTo(CGSizeMake(60, 60));
    }];
    
    [_swichCameraButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(_leaveChannelButton);
        make.top.equalTo(_leaveChannelButton.mas_bottom).offset(338);
    }];
    
    [_swichLayoutButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(_leaveChannelButton);
        make.top.equalTo(_swichCameraButton.mas_bottom).offset(49);
    }];
    
    [_courseFilesButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(_leaveChannelButton);
        make.top.equalTo(_swichLayoutButton.mas_bottom).offset(49);
    }];
}

- (UIButton *)setupButtonWithImage:(NSString *)name action:(SEL)sel {
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [UIImageView new];
        _shadowImageView.image = [UIImage imageNamed:@"image_shadow"];
    }
    
    return _shadowImageView;
}

- (UIButton *)leaveChannelButton {
    if (!_leaveChannelButton) {
        _leaveChannelButton = [self setupButtonWithImage:@"icon_hangUp" action:@selector(didTapLeave)];
    }
    
    return _leaveChannelButton;
}

- (UIButton *)swichCameraButton {
    if (!_swichCameraButton) {
        _swichCameraButton = [self setupButtonWithImage:@"icon_SWAP" action:@selector(didTapSwichCamera)];
    }
    
    return _swichCameraButton;
}

- (UIButton *)swichLayoutButton {
    if (!_swichLayoutButton) {
        _swichLayoutButton = [self setupButtonWithImage:@"icon_layoutShifter" action:@selector(didTapSwichLayout)];
    }
    
    return _swichLayoutButton;
}

- (UIButton *)courseFilesButton {
    if (!_courseFilesButton) {
        _courseFilesButton = [self setupButtonWithImage:@"icon_files" action:@selector(didTapCourseFiles)];
    }
    
    return _courseFilesButton;
}

@end
