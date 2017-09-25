#import "DMLoginController.h"
#import "DMLoginTextField.h"

#import <IQKeyboardManager.h>

const CGFloat kTextFieldHeight = 44;
const CGFloat kTextfieldViewHeight = kTextFieldHeight * 2 + 16;
const CGFloat kLogoHeight = 148;
const CGFloat kLogoTop = 183;
const CGFloat kAccountTop = 437; // kLogoTop + logHeight + acctountToLogoTop

@interface DMLoginController () <UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *backgroundImageView; // 背景图片
@property (strong, nonatomic) UIImageView *logoImageView; // 登录logo图片
@property (strong, nonatomic) UIView *textfieldView; // 文本框s
@property (strong, nonatomic) DMLoginTextField *accountTextField; // 文本框: 账号
@property (strong, nonatomic) DMLoginTextField *passwordTextField; // 文本框: 密码
@property (strong, nonatomic) UIButton *loginButton; // 登录按钮
@property (strong, nonatomic) UILabel *descriptionLabel; // 下边描述部分

@end

@implementation DMLoginController

#pragma mark - Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

#pragma mark - Notification
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
        make.top.equalTo(self.view.mas_top).offset(-kLogoHeight);
    }];
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;// 键盘的高度
    
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat loginButtonFrameBottom = DMScreenHeight - _loginButton.dm_height - _loginButton.dm_y;
    
    if (loginButtonFrameBottom < kbSize.height) {
        CGFloat  offsetTop = kAccountTop - (kbSize.height - loginButtonFrameBottom + 25);
        
        [_textfieldView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(offsetTop);
        }];
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutSubviews];
    }];
}

// 实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat accountTextFieldFrameY = _accountTextField.dm_y;
    
    if (accountTextFieldFrameY < kAccountTop) {
        [_textfieldView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kAccountTop);
        }];
    }
    
    [self.logoImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kLogoTop);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutSubviews];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.secureTextEntry) { // 当前是密码框
        if (!_accountTextField.text.length) { // 如果账号是空
            [_accountTextField becomeFirstResponder];
        } else { // 账号不是空
            [self didTapLogin];
        }
    } else { // 账号框
        if (_passwordTextField.text.length) {
            [self didTapLogin];
        } else {
            [_passwordTextField becomeFirstResponder];
        }
    }
    return YES;
}

- (void)didTapLogin {
    NSString *accountString = _accountTextField.text;
    NSString *pwdString = _passwordTextField.text;
    [self touchesBegan:[NSSet set] withEvent:nil];
    
    //请求登录
    [DMApiModel loginSystem:accountString psd:pwdString block:^(BOOL result) {
        if (result) {
            //登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNotification_Login_Success_Key object:nil userInfo:nil];
            [APP_DELEGATE toggleRootView:NO];
        } else {
            //登录失败
        }
    }];
}

#pragma mark - AddSubviews
- (void)setupMakeAddSubviews {
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.textfieldView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.descriptionLabel];
}

#pragma mark - LayoutSubviews
- (void)setupMakeLayoutSubviews {
    [_backgroundImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kLogoTop);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(178, kLogoHeight));
    }];
    
    [_textfieldView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kAccountTop);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(265, kTextfieldViewHeight));
    }];
    
    [_loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textfieldView.mas_bottom).offset(40);
        make.width.centerX.equalTo(_textfieldView);
        make.height.equalTo(45);
    }];
    
    [_descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginButton);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
}

#pragma mark - Lazy
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
        _accountTextField.image = [UIImage imageNamed:@"icon_account"];
        _accountTextField.placeholder = @"请输入用户名";
        _accountTextField.delegate = self;
        _accountTextField.placeholderColor = [DMColorWithHexString(@"#FFFFFF") colorWithAlphaComponent:0.2];
    }
    
    return _accountTextField;
}

- (DMLoginTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [DMLoginTextField new];
        _passwordTextField.image = [UIImage imageNamed:@"icon_pwd"];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholderColor = [DMColorWithHexString(@"#FFFFFF") colorWithAlphaComponent:0.2];
        _passwordTextField.delegate = self;
    }
    
    return _passwordTextField;
}

- (UIView *)textfieldView {
    if (!_textfieldView) {
        _textfieldView = [UIView new];
        _textfieldView.backgroundColor = [UIColor clearColor];
        
        [_textfieldView addSubview:self.accountTextField];
        [_textfieldView addSubview:self.passwordTextField];
        
        [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_textfieldView);
            make.height.equalTo(kTextFieldHeight);
        }];
        
        [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_textfieldView);
            make.height.equalTo(_accountTextField);
        }];
    }
    
    return _textfieldView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.layer.cornerRadius = 8;
        _loginButton.clipsToBounds = YES;
        _loginButton.backgroundColor = DMColorBaseMeiRed;
        _loginButton.titleLabel.font = DMFontPingFang_Regular(20);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:DMColorWithHexString(@"#999999") forState:UIControlStateDisabled];
        [_loginButton setTitle:DMTitleLogin forState:UIControlStateNormal];
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
        NSString *textString = [NSString stringWithFormat:DMTextLoginDescribe, urlString];
        NSRange urlRange = [textString rangeOfString:urlString];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
        [attributeString setAttributes:@{NSFontAttributeName: DMFontPingFang_Light(12), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#F6087A"] } range:urlRange];
        _descriptionLabel.attributedText = attributeString;
    }
    
    return _descriptionLabel;
}

#pragma mark - Other
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [DMNotificationCenter removeObserver:self];
}

@end
