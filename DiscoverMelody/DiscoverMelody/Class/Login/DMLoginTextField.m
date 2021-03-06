#import "DMLoginTextField.h"

@interface DMLoginTextField(){
    NSString *_text;
}

@property (strong, nonatomic) UIImageView *cornerImageView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation DMLoginTextField

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self.textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)addTarget:(nullable id)target action:(SEL _Nullable )action forControlEvents:(UIControlEvents)controlEvents{
    [self.textField addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    _delegate = delegate;
    _textField.delegate = _delegate;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    _textField.secureTextEntry = secureTextEntry;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textField.text = text;
}

- (NSString *)text {
    return _textField.text;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)becomeFirstResponder {
    [_textField becomeFirstResponder];
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.cornerImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.textField];
}

- (void)setupMakeLayoutSubviews {
    [_cornerImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(17, 20));
    }];
    
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(self);
        make.left.equalTo(60);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
}

- (UIImageView *)cornerImageView {
    if (!_cornerImageView) {
        _cornerImageView = [UIImageView new];
        _cornerImageView.image = [UIImage imageNamed:@"textField_backgound"];
    }
    
    return _cornerImageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    
    return _imageView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.font = DMFontPingFang_Light(16);
        _textField.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6];
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        UIButton *clearButton = [_textField valueForKey:@"_clearButton"];;
        [clearButton setImage:[UIImage imageNamed:@"btn_clear_text"] forState:UIControlStateNormal];
    }
    
    return _textField;
}

@end
