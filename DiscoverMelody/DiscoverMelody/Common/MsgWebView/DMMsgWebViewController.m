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
    [self loadWebView];
}

- (void)loadWebView {
    self.mWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview: self.mWebView];

    NSMutableURLRequest *requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.msgUrl]];
    [requestShare setHTTPMethod: @"POST"];
    NSString *tokenApp = [DMAccount getToken];
    if (!STR_IS_NIL(tokenApp)) {
        [requestShare setHTTPBody:[tokenApp dataUsingEncoding: NSUTF8StringEncoding]];
    }
    [self.mWebView loadRequest:requestShare];
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
