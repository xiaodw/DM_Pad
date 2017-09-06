#import "DMLoginController.h"

#import "DMLoginTextField.h"

const CGFloat kLogoTop = 183;
const CGFloat kAccountTop = 437; // kLogoTop + logHeight + acctountToLogoTop

@interface DMLoginController () <UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) DMLoginTextField *accountTextField;
@property (strong, nonatomic) DMLoginTextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UILabel *descriptionLabel;

@end

@implementation DMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    
    [self registerForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    // 使用NSNotificationCenter 键盘显示
    [DMNotificationCenter addObserver:self
                             selector:@selector(keyboardWasShown:)
                                 name:UIKeyboardWillShowNotification object:nil];
    // 使用NSNotificationCenter 键盘隐藏
    [DMNotificationCenter addObserver:self
                             selector:@selector(keyboardWillBeHidden:)
                                 name:UIKeyboardWillHideNotification object:nil];
}

// 实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification {
    [self.logoImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(-kLogoTop);
    }];
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;// 键盘的高度
    
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat loginButtonFrameBottom = [UIScreen mainScreen].bounds.size.height - _loginButton.frame.size.height - _loginButton.frame.origin.y;
    
    if (loginButtonFrameBottom < kbSize.height) {
        CGFloat  offsetTop = kAccountTop - (kbSize.height - loginButtonFrameBottom + 10);
        
        [_accountTextField updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(offsetTop);
        }];
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat accountTextFieldFrameY = _accountTextField.frame.origin.y;
    
    if (accountTextFieldFrameY < kAccountTop) {
        [_accountTextField updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kAccountTop);
        }];
    }
    
    [self.logoImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kLogoTop);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.secureTextEntry) { // 当前是密码框
        if (!_accountTextField.text.length) { // 如果账号是空
            [_accountTextField becomeFirstResponder];
        } else { // 账号不是空
            [self didTapLogin];
        }
    } else { // 账号框
        [_passwordTextField becomeFirstResponder];
    }
    return YES;
}

- (void)didTapLogin {
    NSString *accountString = _accountTextField.text;
    if (accountString.length == 0) {
        NSLog(@"账号怎么可能是空的?");
        return;
    }
    
    NSString *pwdString = _passwordTextField.text;
    if (pwdString.length == 0) {
        NSLog(@"密码空的?");
        return;
    }
    
    [self touchesBegan:[NSSet set] withEvent:nil];
    NSLog(@"发送API{account: %@, pwd: %@}", accountString, pwdString);
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.descriptionLabel];
}

- (void)setupMakeLayoutSubviews {
    [_backgroundImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kLogoTop);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(178, 148));
    }];
    
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kAccountTop);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(265, 35));
    }];
    
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(_accountTextField);
        make.top.equalTo(_accountTextField.mas_bottom).offset(15);
    }];
    
    [_loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(40);
        make.width.centerX.equalTo(_passwordTextField);
        make.height.equalTo(45);
    }];
    
    [_descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginButton);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.image = [UIImage imageNamed:@"image_login_background"];
    }
    
    return _backgroundImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.image = [UIImage imageNamed:@"image_logo"];
    }
    
    return _logoImageView;
}

- (DMLoginTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [DMLoginTextField new];
        _accountTextField.image = [UIImage imageNamed:@"icon_email"];
        _accountTextField.delegate = self;
    }
    
    return _accountTextField;
}

- (DMLoginTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [DMLoginTextField new];
        _passwordTextField.image = [UIImage imageNamed:@"icon_pwd"];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
    }
    
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.backgroundColor = [UIColor colorWithHexString:@"#F6087A"];
        _loginButton.layer.cornerRadius = 8;
        _loginButton.clipsToBounds = YES;
        _loginButton.titleLabel.font = DMFontPingFang_Light(20);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(didTapLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = DMFontPingFang_UltraLight(12);
        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" ];
        
        NSString *urlString = @"www.DiscoverMelody.com";
        NSString *textString = [NSString stringWithFormat:@"此APP目前只提供给已购课的用户体验.未购课的用户请访问 %@ 了解更多信息", urlString];
        NSRange urlRange = [textString rangeOfString:urlString];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
        [attributeString setAttributes:@{NSFontAttributeName: DMFontPingFang_Light(12), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#F6087A"] } range:urlRange];
        _descriptionLabel.attributedText = attributeString;
    }
    
    return _descriptionLabel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
