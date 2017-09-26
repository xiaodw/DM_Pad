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

#import "DMClassDataModel.h"
//#import "DMClassFilesViewController.h"
#import "DMCourseFilesController.h"
#import "DMTransitioningAnimationHelper.h"

#import "DMBOSClientManager.h"
@interface DMHomeViewController () <DMHomeVCDelegate>

@property (nonatomic, strong) DMHomeView *homeView;
@property (nonatomic, strong) DMCourseDatasModel *courseObj;
@property (strong, nonatomic) DMTransitioningAnimationHelper *animationHelper;
@property (nonatomic, strong) DMCloudConfigData *dataCloud;

@property (nonatomic, strong) DMClassDataModel *classJoinData;

@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setNavTitle:@"个人主页"];
    self.title = DMTitleHome;
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self.view addSubview:self.homeView];
    
    [self getDataFromServer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateHomeData:)
                                                 name:DMNotification_HomePage_Key
                                               object:nil];
}

- (void)updateHomeData:(NSNotification *)notification {
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
                DMCourseDatasModel *data = [array firstObject];
                weakSelf.courseObj = data;
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

- (void)clickReload:(id)sender {
    [self getDataFromServer];
}

- (void)selectedCourse:(DMCourseDatasModel *)courseObj {
    self.courseObj = courseObj;
}
//本课文件
- (void)clickCourseFiles:(id)sender {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [SVProgressHUD setForegroundColor:DMColorWithRGBA(254, 254, 254, 1)]; //字体颜色
    [SVProgressHUD setBackgroundColor:DMColorWithRGBA(0, 0, 0, 0.6)];//背景颜色
    [SVProgressHUD setCornerRadius:5];
    
    [SVProgressHUD setMinimumSize:CGSizeMake(130, 130)];
    [SVProgressHUD setFont:DMFontPingFang_Regular(16)];
    [SVProgressHUD setImageViewSize:CGSizeMake(20, 20)];
    [SVProgressHUD setFadeInAnimationDuration:0.2];
    [SVProgressHUD showImage:[UIImage imageNamed:@"question_radio_sel"] status:@""];
    return;

    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;//防止恶意极限快速点击
    DMCourseFilesController *courseFilesVC = [DMCourseFilesController new];
    courseFilesVC.columns = 6;
    courseFilesVC.leftMargin = 15;
    courseFilesVC.rightMargin = 15;
    courseFilesVC.columnSpacing = 15;
    courseFilesVC.isFullScreen = YES;
    DMTransitioningAnimationHelper *animationHelper = [DMTransitioningAnimationHelper new];
    self.animationHelper = animationHelper;
    animationHelper.animationType = DMTransitioningAnimationRight;
    animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
    courseFilesVC.transitioningDelegate = animationHelper;
    courseFilesVC.modalPresentationStyle = UIModalPresentationCustom;
    courseFilesVC.lessonID = self.courseObj.lesson_id;
    [self presentViewController:courseFilesVC animated:YES completion:nil];
    
    btn.userInteractionEnabled = YES;//防止恶意极限快速点击
}
//进入课堂
- (void)clickClassRoom:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;//防止恶意极限快速点击
    
    WS(weakSelf)
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //无权限-摄像头
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"" message:Capture_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleCancel otherTitle:DMTitleGoSetting, nil];
        [alert showWithViewController:self IndexBlock:^(NSInteger index) {
            NSLog(@"%ld",index);
            if (index == 1) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        btn.userInteractionEnabled = YES;
        return;
    }
    AVAuthorizationStatus authStatusAudio =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
     if (authStatusAudio == AVAuthorizationStatusRestricted || authStatusAudio ==AVAuthorizationStatusDenied) {
        //无权限-麦克风
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"" message:Audio_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleCancel otherTitle:DMTitleGoSetting, nil];
        [alert showWithViewController:self IndexBlock:^(NSInteger index) {
            NSLog(@"%ld",index);
            if (index == 1) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        btn.userInteractionEnabled = YES;
        return;
    }
    [weakSelf goToClassRoom:btn];
}

- (void)goToClassRoom:(UIButton *)btn {
    NSLog(@"进入课堂");
    WS(weakSelf);
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [DMApiModel joinClaseeRoom:self.courseObj.lesson_id accessTime:[DMTools getCurrentTimestamp] block:^(BOOL result, DMClassDataModel *obj) {
        btn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if (result) {
            weakSelf.classJoinData = obj;
            [weakSelf joinClassRoom];
        }
    }];
}

- (void)joinClassRoom {
//    DMLiveController *liveVC = [DMLiveController new];
//    liveVC.navigationVC = self.navigationController;
//    liveVC.lessonID = self.courseObj.lesson_id;
//    liveVC.totalTime = [self.classJoinData.duration intValue];
//    liveVC.alreadyTime = [DMTools computationsClassTimeDifference:self.classJoinData.start_time
//                                                       accessTime:[DMAccount getUserJoinClassTime]];
//    liveVC.warningTime = self.classJoinData.countdown.longLongValue;
//    liveVC.delayTime = self.classJoinData.forceclose.longLongValue;
//    [self.navigationController pushViewController:liveVC animated:YES];
    
    DMLiveController *liveVC = [DMLiveController new];
    liveVC.navigationVC = self.navigationController;
    liveVC.lessonID = self.courseObj.lesson_id;
    liveVC.totalTime = 1 * 60;
    liveVC.alreadyTime = 60;
    liveVC.warningTime = 30;
    liveVC.delayTime = 1*60;
    
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
