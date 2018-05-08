#import "DMWhiteBoardControl.h"
#import "DMButton.h"

#define kCornerRadius 40
#define kCornerColorRadius 35

@interface DMWhiteBoardControl()

@property (strong, nonatomic) UIButton *cleanButton;
@property (strong, nonatomic) UIButton *undoButton;
@property (strong, nonatomic) UIButton *forwardButton;
@property (strong, nonatomic) UIButton *brushButton;
@property (strong, nonatomic) UIButton *colorButton;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation DMWhiteBoardControl

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.brushButton.backgroundColor = lineColor;
    self.colorButton.backgroundColor = lineColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DMColor33(1);
        
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
        [self setupNotification];
    }
    return self;
}

- (void)changeUndoStatus:(NSNotification *)notification {
    self.undoButton.enabled = ![notification.object boolValue];
    self.forwardButton.enabled = YES;
}

- (void)changeForwardStatus:(NSNotification *)notification {
    self.undoButton.enabled = YES;
    self.cleanButton.enabled = YES;
    self.forwardButton.enabled = ![notification.object boolValue];
}

- (void)resetStatus:(NSNotification *)notification {
    self.undoButton.enabled = NO;
    self.forwardButton.enabled = NO;
    self.cleanButton.enabled = NO;
}

- (void)setupNotification {
    [DMNotificationCenter addObserver:self selector:@selector(changeUndoStatus:) name:DMNotificationWhiteBoardUndoStatusKey object:nil];
    
    [DMNotificationCenter addObserver:self selector:@selector(changeForwardStatus:) name:DMNotificationWhiteBoardForwardStatusKey object:nil];
    
    [DMNotificationCenter addObserver:self selector:@selector(resetStatus:) name:DMNotificationWhiteBoardCleanStatusKey object:nil];
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.cleanButton];
    [self addSubview:self.undoButton];
    [self addSubview:self.forwardButton];
    [self addSubview:self.brushButton];
    [self addSubview:self.colorButton];
    [self addSubview:self.closeButton];
}

- (void)setupMakeLayoutSubviews {
    CGSize size = CGSizeMake(kCornerRadius, kCornerRadius);
    [_cleanButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.size.equalTo(size);
        make.centerY.equalTo(self);
    }];
    
    [_undoButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cleanButton.mas_right).offset(40);
        make.centerY.equalTo(_cleanButton);
        make.size.equalTo(size);
    }];
    
    [_forwardButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_undoButton.mas_right).offset(40);
        make.centerY.equalTo(_cleanButton);
        make.size.equalTo(size);
    }];
    
    [_closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(_cleanButton);
        make.size.equalTo(size);
    }];
    
    [_colorButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_closeButton.mas_left).offset(-40);
        make.centerY.equalTo(_cleanButton);
        make.size.equalTo(CGSizeMake(kCornerColorRadius-3, kCornerColorRadius-3));
    }];
    
    [_brushButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_colorButton.mas_left).offset(-40);
        make.centerY.equalTo(_cleanButton);
        make.size.equalTo(CGSizeMake(31, 31));
    }];
}

- (UIButton *)setupButton {
    UIButton *button = [DMNotHighlightedButton new];
    return button;
}

- (void)didTapClean {
    [self resetStatus: nil];
    if (![self.delegate respondsToSelector:@selector(whiteBoardControlDidTapClean:)]) return;
    [self.delegate whiteBoardControlDidTapClean:self];
}

- (void)didTapUndo {
    if (![self.delegate respondsToSelector:@selector(whiteBoardControlDidTapUndo:)]) return;
    [self.delegate whiteBoardControlDidTapUndo:self];
}

- (void)didTapForward {
    if (![self.delegate respondsToSelector:@selector(whiteBoardControlDidTapForward:)]) return;
    [self.delegate whiteBoardControlDidTapForward:self];
}

- (void)didTapBrush:(UIButton *)button {
    if (![self.delegate respondsToSelector:@selector(whiteBoardControl:didTapBrushButton:)]) return;
    [self.delegate whiteBoardControl:self didTapBrushButton:button];
}

- (void)didTapColors:(UIButton *)button {
    if (![self.delegate respondsToSelector:@selector(whiteBoardControl:didTapColorsButton:)]) return;
    [self.delegate whiteBoardControl:self didTapColorsButton:button];
}

- (void)didTapClose {
    if (![self.delegate respondsToSelector:@selector(whiteBoardControlDidTapClose:)]) return;
    [self.delegate whiteBoardControlDidTapClose:self];
}

- (UIButton *)cleanButton {
    if (!_cleanButton) {
        _cleanButton = [self setupButton];
        _cleanButton.enabled = NO;
        _cleanButton.titleLabel.font = DMFontPingFang_Light(11);
        [_cleanButton setTitle:DMTitleClean forState:UIControlStateNormal];
        [_cleanButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_cleanButton setTitleColor:DMColorWithRGBA(66, 66, 66, 1) forState:UIControlStateDisabled];
        [_cleanButton addTarget:self action:@selector(didTapClean) forControlEvents:UIControlEventTouchUpInside];
        _cleanButton.layer.cornerRadius = kCornerRadius * 0.5;
        _cleanButton.layer.borderWidth = 1;
        _cleanButton.layer.borderColor = DMColorWithRGBA(83, 83, 83, 1).CGColor;
    }
    
    return _cleanButton;
}


- (UIButton *)undoButton {
    if (!_undoButton) {
        _undoButton = [self setupButton];
        _undoButton.enabled = NO;
        [_undoButton setImage:[UIImage imageNamed:@"icon_undo_normal"] forState:UIControlStateNormal];
        [_undoButton setImage:[UIImage imageNamed:@"icon_undo_disabled"] forState:UIControlStateDisabled];
        [_undoButton addTarget:self action:@selector(didTapUndo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _undoButton;
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [self setupButton];
        _forwardButton.enabled = NO;
        [_forwardButton setImage:[UIImage imageNamed:@"icon_forward_normal"] forState:UIControlStateNormal];
        [_forwardButton setImage:[UIImage imageNamed:@"icon_forward_disabled"] forState:UIControlStateDisabled];
        [_forwardButton addTarget:self action:@selector(didTapForward) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _forwardButton;
}
- (UIButton *)brushButton {
    if (!_brushButton) {
        _brushButton = [self setupButton];
        _brushButton.backgroundColor = [UIColor redColor];
        [_brushButton setImage:[UIImage imageNamed:@"icon_brush"] forState:UIControlStateNormal];
        [_brushButton addTarget:self action:@selector(didTapBrush:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _brushButton;
}

- (UIButton *)colorButton {
    if (!_colorButton) {
        _colorButton = [self setupButton];
        _colorButton.backgroundColor = [UIColor redColor];
        [_colorButton setImage:[UIImage imageNamed:@"image_borderColor_43"] forState:UIControlStateNormal];
        [_colorButton addTarget:self action:@selector(didTapColors:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _colorButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [self setupButton];
        _closeButton.backgroundColor = DMColorWithRGBA(22, 22, 22, 1);
        _closeButton.titleLabel.font = DMFontPingFang_Light(11);
        _closeButton.layer.cornerRadius = kCornerRadius * 0.5;
        _closeButton.layer.borderWidth = 1;
        _closeButton.layer.borderColor = DMColorWithRGBA(83, 83, 83, 1).CGColor;
        [_closeButton setTitle:DMTitleClose forState:UIControlStateNormal];
        [_closeButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didTapClose) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (void)dealloc {
    DMLogFunc
    [DMNotificationCenter removeObserver:self];
}

@end
