//
//  DMBaseViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseViewController.h"

@interface DMBaseViewController ()
@property (nonatomic, strong) UINavigationItem * navigationBarTitle;
@end

@implementation DMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationbar];        
}

- (void)setNavigationbar {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 64)];
    navigationBar.tintColor = [UIColor redColor];
    //创建UINavigationItem
    _navigationBarTitle = [[UINavigationItem alloc] init];
//    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview:navigationBar];
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(clickMenuBtn:)];
    //设置barbutton
    _navigationBarTitle.leftBarButtonItem = item;
    [navigationBar setItems:[NSArray arrayWithObject:_navigationBarTitle]];
    
}

- (void)setNavTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    _navigationBarTitle.titleView = label;
    label.text = title;
    [label sizeToFit];
}

- (void)clickMenuBtn:(id)sender {
    NSLog(@"点击菜单栏按钮");
//    [self.dmRootViewController.view endEditing:YES];
//    [self.dmRootViewController presentMenuViewController];
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
