//
//  DMHomeViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMHomeViewController.h"
#import "DMRootContainerViewController.h"
#import "DMLiveController.h"
#import "UIViewController+DMRootViewController.h"
#import "DMHomeView.h"
#import "DMHomeDataModel.h"
#import "DMTestViewController.h"
@interface DMHomeViewController () <DMHomeVCDelegate>

@property (nonatomic, strong) DMHomeView *homeView;

@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setNavTitle:@"个人主页"];
    self.title = @"个人主页";
    [self setNavigationBarTransparence];
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self.view addSubview:self.homeView];
    [self getDataFromServer];
}

//获取首页数据
- (void)getDataFromServer {
    [DMHomeDataModel getHomeCourseData:^(BOOL result, NSMutableArray *array) {
        
    }];
}

- (DMHomeView *)homeView {
    if (!_homeView) {
        _homeView = [[DMHomeView alloc] initWithFrame:self.view.bounds delegate:self];
    }
    return _homeView;
}

//本课文件
- (void)clickCourseFiles {
    
    NSLog(@"本课文件");
}
//进入课堂
- (void)clickClassRoom {
    
    NSLog(@"进入课堂");
    DMLiveController *liveVC = [DMLiveController new];
    liveVC.navigationVC = self.navigationController;
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self setNavigationBarTransparence];
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
