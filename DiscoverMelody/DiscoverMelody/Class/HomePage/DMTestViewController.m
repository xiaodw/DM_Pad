//
//  DMTestViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMTestViewController.h"
#import "DMLiveVideoManager.h"
#import "DMCoursewareFallsView.h"
@interface DMTestViewController ()

@end

@implementation DMTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
//    
//    UIView *lo = [[UIView alloc] initWithFrame:CGRectMake(100, 100, DMScreenWidth-200, 400)];
//    lo.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:lo];
//    
//    UIView *re = [[UIView alloc] initWithFrame:CGRectMake(100, 600, DMScreenWidth-200, 400)];
//    re.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:re];
//
//    [[DMLiveVideoManager shareInstance] startLiveVideo:lo
//                                                remote:re
//                                            isTapVideo:YES
//                                      blockAudioVolume:^(NSInteger totalVolume, NSArray *speakers) {
//        NSLog(@"回调回来了");
//    } blockTapVideoEvent:^(DMLiveVideoViewType type){
//        NSLog(@"点击回调回来了 = %ld", (long)type);
//    }];
    
    DMCoursewareFallsView *cfView = [[DMCoursewareFallsView alloc]
                                     initWithFrame:self.view.bounds
                                     columns:6
                                     lineSpacing:20
                                     columnSpacing:25
                                     leftMargin:30
                                     rightMargin:30];
    [self.view addSubview:cfView];
    
    cfView.datas = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    [cfView.collectionView reloadData];

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
