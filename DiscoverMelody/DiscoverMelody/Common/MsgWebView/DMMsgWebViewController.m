//
//  DMMsgWebViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/10/31.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMMsgWebViewController.h"

@interface DMMsgWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *mWebView;
@end

@implementation DMMsgWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:DMFontPingFang_Regular(16)}];
    [self setNavigationbar];
   
    [self loadWebView];
}

- (void)rightOneAction:(id)sender {
    [self dismissWeb];
}

- (void)leftOneAction:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    if (self.mWebView.canGoBack) {
        [self.mWebView goBack];
        return;
    }
    [self dismissWeb];
}

- (void)dismissWeb {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadWebView {
    self.mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, DMScreenHeight-64)];
    self.mWebView.delegate = self;
    [self.view addSubview: self.mWebView];

    if (self.isHaveToken) {
        NSString *tokenApp = [DMAccount getToken];
        if (!STR_IS_NIL(tokenApp)) {
            self.msgUrl = [NSString stringWithFormat:@"%@&token=%@", self.msgUrl, tokenApp];
        }
    }
    NSMutableURLRequest *requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.msgUrl]];
//    NSMutableURLRequest *requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.msgUrl]];
//    if (self.isHaveToken) {
//        [requestShare setHTTPMethod: @"POST"];
//        NSString *tokenApp = [DMAccount getToken];
//        if (!STR_IS_NIL(tokenApp)) {
//            [requestShare setHTTPBody:[tokenApp dataUsingEncoding: NSUTF8StringEncoding]];
//        }
//    }
    [self.mWebView loadRequest:requestShare];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationbar {
    [self setLeftBtn:CGRectMake(0, 0, 44, 44) title:@"" titileColor:nil imageName:@"back_icon" font:nil];
    [self setRigthBtn:CGRectMake(0, 0, 44, 44) title:@"关闭" titileColor:[UIColor whiteColor] imageName:@"" font:DMFontPingFang_Thin(14)];
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
        if (DM_SystemVersion_11) {
            btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
    }
    [btn addTarget:self action:@selector(leftOneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -15;
    //btn.backgroundColor = [UIColor randomColor];
    self.navigationItem.leftBarButtonItems = @[fixedSpace, [[UIBarButtonItem alloc] initWithCustomView:btn]];
    
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
