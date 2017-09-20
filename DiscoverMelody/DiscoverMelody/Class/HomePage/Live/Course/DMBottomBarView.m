#import "DMBottomBarView.h"
#import "DMButton.h"

@interface DMBottomBarView ()

@property (strong, nonatomic) UIView *separaterView;

@end

@implementation DMBottomBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.uploadButton];
    [self addSubview:self.syncButton];
    [self addSubview:self.deleteButton];
    [self addSubview:self.separaterView];
}

- (void)setupMakeLayoutSubviews {
    [_uploadButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(55);
        make.top.bottom.equalTo(self);
    }];
    
    [_syncButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.equalTo(_uploadButton);
        make.centerX.equalTo(self);
    }];
    
    [_deleteButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.equalTo(_uploadButton);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [_separaterView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(0.5);
    }];
}

- (void)didTapUpload:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(botoomBarViewDidTapUpload:)]) return;
    [self.delegate botoomBarViewDidTapUpload:self];
}

- (void)didTapSync:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(botoomBarViewDidTapSync:)]) return;
    
    [self.delegate botoomBarViewDidTapSync:self];
}

- (void)didTapDelete:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(botoomBarViewDidTapDelete:)]) return;
    [self.delegate botoomBarViewDidTapDelete:self];
}

- (UIButton *)setupButton{
    DMButton *button = [DMNotHighlightedButton new];
    button.spacing = 3;
    button.titleLabel.font = DMFontPingFang_Regular(12);
    button.titleAlignment = DMTitleButtonTypeBottom;
    [button setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
    [button setTitleColor:DMColorWithHexString(@"#CCCCCC") forState:UIControlStateDisabled];
    
    return button;
}

- (UIButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [self setupButton];
        [_uploadButton setTitle:DMTitleUpload forState:UIControlStateNormal];
        [_uploadButton setImage:[UIImage imageNamed:@"c_upload_normal"] forState:UIControlStateDisabled];
        [_uploadButton setImage:[UIImage imageNamed:@"c_upload_selected"] forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(didTapUpload:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _uploadButton;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [self setupButton];
        _syncButton.enabled = NO;
        [_syncButton setTitle:DMTitleSync forState:UIControlStateNormal];
        [_syncButton addTarget:self action:@selector(didTapSync:) forControlEvents:UIControlEventTouchUpInside];
        [_syncButton setImage:[UIImage imageNamed:@"c_synchronizing_normal"] forState:UIControlStateDisabled];
        [_syncButton setImage:[UIImage imageNamed:@"c_synchronizing_selected"] forState:UIControlStateNormal];

    }
    
    return _syncButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [self setupButton];
        _deleteButton.enabled = NO;
        [_deleteButton setTitle:DMTitleDeleted forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"c_delete_normal"] forState:UIControlStateDisabled];
        [_deleteButton setImage:[UIImage imageNamed:@"c_delete_selected"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didTapDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}

- (UIView *)separaterView {
    if (!_separaterView) {
        _separaterView = [UIView new];
        _separaterView.backgroundColor = DMColorWithRGBA(221, 221, 221, 1);
    }
    
    return _separaterView;
}

@end
