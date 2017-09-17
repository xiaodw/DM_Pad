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

#import "DMClassDataModel.h"
#import "DMClassFilesViewController.h"

@interface DMHomeViewController () <DMHomeVCDelegate>

@property (nonatomic, strong) DMHomeView *homeView;


@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setNavTitle:@"个人主页"];
    self.title = @"个人主页";
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self.view addSubview:self.homeView];
    
    [self getDataFromServer];
}

//获取首页数据
- (void)getDataFromServer {
    WS(weakSelf);
    
    NSString *type = [DMAccount getUserIdentity];
    
    [DMApiModel getHomeCourseData:type block:^(BOOL result, NSArray *array) {
        if (result) {
            if (!OBJ_IS_NIL(array) && array.count > 0) {
                [weakSelf.homeView disPlayNoCourseView:NO isError:NO];
                weakSelf.homeView.datas = array;
                [weakSelf.homeView reloadHomeTableView];
            } else {
                //显示空白页面
                [weakSelf.homeView disPlayNoCourseView:YES isError:NO];
            }
            
        } else {
            //获取失败
            [weakSelf.homeView disPlayNoCourseView:YES isError:YES];
        }
    }];
}

- (DMHomeView *)homeView {
    if (!_homeView) {
        _homeView = [[DMHomeView alloc] initWithFrame:self.view.bounds delegate:self];
    }
    return _homeView;
}

- (void)clickReload {
    [self getDataFromServer];
}

//本课文件
- (void)clickCourseFiles {
    
    NSLog(@"本课文件");
    DMClassFilesViewController *cf = [[DMClassFilesViewController alloc] init];
    [self.navigationController pushViewController:cf animated:YES];
}
//进入课堂
- (void)clickClassRoom {
    WS(weakSelf)
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //无权限-摄像头
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"" message:Capture_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" otherTitle:@"去设置", nil];
        [alert showWithViewController:self IndexBlock:^(NSInteger index) {
            NSLog(@"%ld",index);
            if (index == 1) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        return;
    }
    AVAuthorizationStatus authStatusAudio =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
     if (authStatusAudio == AVAuthorizationStatusRestricted || authStatusAudio ==AVAuthorizationStatusDenied) {
        //无权限-麦克风
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"" message:Audio_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" otherTitle:@"去设置", nil];
        [alert showWithViewController:self IndexBlock:^(NSInteger index) {
            NSLog(@"%ld",index);
            if (index == 1) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        return;
    }
    [weakSelf goToClassRoom];
}

- (void)goToClassRoom {
    NSLog(@"进入课堂");
    DMLiveController *liveVC = [DMLiveController new];
    liveVC.navigationVC = self.navigationController;
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)joinClassRoom {
    [DMApiModel joinClaseeRoom:@"1" accessTime:@"" block:^(BOOL result, DMClassDataModel *obj) {
        
    }];
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
