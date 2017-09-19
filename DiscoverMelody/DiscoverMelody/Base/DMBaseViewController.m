//
//  DMBaseViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseViewController.h"

@interface DMBaseViewController ()
@property (nonatomic, strong) UINavigationItem *navigationBar;

@end

@implementation DMBaseViewController

- (void)updateUserInfo:(NSNotification *)notification {
    [self updateUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:DMFontPingFang_Medium(16)}];
    [self setNavigationbar];
}

- (void)setNavigationbar {
     if (self.navigationController.viewControllers.count > 1) {
         [self setLeftBtn:CGRectMake(0, 0, 44, 44) title:@"" titileColor:nil imageName:@"back_icon" font:nil];
     } else {
         [self setupMenuButton];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:DMNotification_Login_Success_Key object:nil];
     }
}

- (void)setupMenuButton {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 36);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"slider_menu_left"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"slider_menu_left"] forState:UIControlStateHighlighted];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    [backButton addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -5;
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    //headImageView.image = [UIImage imageNamed:@"timg.jpg"];
    headImageView.layer.cornerRadius = 38/2;
    headImageView.layer.masksToBounds = YES;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView = headImageView;
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 38)];
    userLabel.textColor = [UIColor whiteColor];
    userLabel.textAlignment = NSTextAlignmentLeft;
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.font = DMFontPingFang_Light(12);
    self.userLabel = userLabel;
    
    self.navigationItem.leftBarButtonItems = @[fixedSpace, [[UIBarButtonItem alloc] initWithCustomView:backButton], [[UIBarButtonItem alloc] initWithCustomView:headImageView], [[UIBarButtonItem alloc] initWithCustomView:userLabel]];

    [self updateUserInfo];
}

- (void)updateUserInfo {
    
    NSString *headUrl = [DMAccount getUserHeadUrl];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:DMPlaceholderImageDefault];
    NSString *identityString = [self getIdentityType:([DMAccount getUserIdentity].intValue ==0 ? DMStringIDStudent : DMStringIDTeacher)];
    NSString *userString = [NSString stringWithFormat:@"%@%@", [DMAccount getUserName], identityString];
    NSRange idRange = [userString rangeOfString:identityString];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:userString];
    [attributeString setAttributes:@{NSFontAttributeName: DMFontPingFang_UltraLight(12), NSForegroundColorAttributeName: [UIColor whiteColor] } range:idRange];
    self.userLabel.attributedText = attributeString;
}

- (NSString *)getIdentityType:(NSString *)idType {
    return [NSString stringWithFormat:@"·%@", idType];
}

- (void)setNavTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = DMFontPingFang_Medium(16);//[UIFont boldSystemFontOfSize:24.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = title;
    [label sizeToFit];
}

//MARK: - 设置导航栏透明
- (void)setNavigationBarTransparence {
//    [[UINavigationBar appearance] setTranslucent:YES];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    
//    NSArray *list=self.navigationController.navigationBar.subviews;
//    for (id obj in list) {
//        if ([obj isKindOfClass:[UIImageView class]]) {
//            UIImageView *imageView=(UIImageView *)obj;
//            imageView.hidden=YES;
//        }
//    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, 65), 0, [UIScreen mainScreen].scale);
    [[UIColor clearColor] set];
    UIRectFill(CGRectMake(0, 0, CGSizeMake([UIScreen mainScreen].bounds.size.width, 65).width, CGSizeMake([UIScreen mainScreen].bounds.size.width, 65).height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 65)];
    imageView.image= pressedColorImg;

    [self.navigationController.navigationBar sendSubviewToBack:imageView];
    [self.navigationController.navigationBar setBackgroundImage:imageView.image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     [UIFont boldSystemFontOfSize:16], NSFontAttributeName,
                                                                     nil]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

//MARK: - 设置导航栏不透明
- (void)setNavigationBarNoTransparence {

    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, 65), 0, [UIScreen mainScreen].scale);
    [[UIColor blackColor] set];
    UIRectFill(CGRectMake(0, 0, CGSizeMake([UIScreen mainScreen].bounds.size.width, 65).width, CGSizeMake([UIScreen mainScreen].bounds.size.width, 65).height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 65)];
    imageView.image= pressedColorImg;
    
    [self.navigationController.navigationBar sendSubviewToBack:imageView];
    [self.navigationController.navigationBar setBackgroundImage:imageView.image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     [UIFont boldSystemFontOfSize:16], NSFontAttributeName,
                                                                     nil]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}


- (void)setRigthBtn:(CGRect)frame title:(NSString *)title titileColor:(UIColor *)titleColor imageName:(NSString *)imageName font:(UIFont *)font {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (!STR_IS_NIL(title)) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:font];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    if (!STR_IS_NIL(imageName)) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    }
    [btn addTarget:self action:@selector(rightOneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -5;
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[fixedSpace, [[UIBarButtonItem alloc] initWithCustomView:btn]];
    self.rightButton = btn;
}

- (void)setLeftBtn:(CGRect)frame title:(NSString *)title titileColor:(UIColor *)titleColor imageName:(NSString *)imageName font:(UIFont *)font {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (!STR_IS_NIL(title)) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:font];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    if (!STR_IS_NIL(imageName)) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    }
    [btn addTarget:self action:@selector(leftOneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -15;
    
    self.navigationItem.leftBarButtonItems = @[fixedSpace, [[UIBarButtonItem alloc] initWithCustomView:btn]];

}

- (void)leftOneAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightOneAction:(id)sender {

}


- (void)updateRightBtnTitle:(NSString *)title {
    [self.rightButton setTitle:title forState:UIControlStateNormal];
}

- (void)updateRightBtnImage:(NSString *)imageName {
    [self.rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)clickMenuBtn:(id)sender {
    NSLog(@"点击菜单栏按钮");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.dmrVC presentMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
