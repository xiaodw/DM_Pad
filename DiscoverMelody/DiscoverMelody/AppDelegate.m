
 //
//  AppDelegate.m
//  DiscoverMelody
//
//  Created by Ares on 2017/8/29.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "AppDelegate.h"
#import "DMRootViewController.h"
#import "DMLoginController.h"
#import "DMLiveController.h"
#import "DMConfigManager.h"
#import "AppDelegate+DMPushNotification.h"
#import "DMGeTuiManager.h"
@interface AppDelegate ()

@end
/*
                    _ooOoo_
                   o8888888o
                   88" . "88
                   (| -_- |)
                   O\  =  /O
                ____/`---'\____
              .'  \\|     |//  `.
             /  \\|||  :  |||//  \
            /  _||||| -:- |||||-  \
            |   | \\\  -  /// |   |
            | \_|  ''\---/''  |   |
            \  .-\__  `-`  ___/-. /
          ___`. .'  /--.--\  `. . __
       ."" '<  `.___\_<|>_/___.'  >'"".
      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
      \  \ `-.   \_ __\ /__ _/   .-` /  /
 ======`-.____`-.___\_____/___.-`____.-'======
                    `=---='
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
               佛祖保佑       永无BUG
 */
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [[DMGeTuiManager shareInstance] registerLocationAndRemoteNotification];
    [[DMGeTuiManager shareInstance] startGeTuiSDK];
    sleep(1.5);
    [[DMConfigManager shareInstance] initConfigInformation];//初始化
    [self updateConfigInfo];
    return YES;
}

- (void)updateConfigInfo {
    WS(weakSelf);
    [DMApiModel initConfigGet:^(BOOL result, DMSetConfigData *obj) {
        [weakSelf goToApp];
        if (!OBJ_IS_NIL(obj)) {
            [weakSelf upgradeMustForApp:obj.app];
        }
    }];
}

- (void)goToApp {
    [SVProgressHUD dismissWithDelay:2.0f];
    if (STR_IS_NIL([DMAccount getToken])) {
        [self toggleRootView:YES];
    } else {
        [self toggleRootView:NO];
    }
}

- (void)toggleRootView:(BOOL)isLogin {
    [self.window.rootViewController removeFromParentViewController];
    if (isLogin) {
        DMLoginController *loginVC = [[DMLoginController alloc] init];
        self.window.rootViewController = loginVC;
    } else {
        [DMTools requestAccessForMediaVideoAndAudio];
        self.dmrVC = [[DMRootViewController alloc] init];
        self.window.rootViewController = self.dmrVC;
    }
    [self.window makeKeyAndVisible];
    
}

- (void)upgradeMustForApp:(DMAppUpgradeData *)obj {
    if (!OBJ_IS_NIL(obj)) {
        if ([obj.update intValue] == 0) {
            return;
        }
        DMAlertMananger *alert = [DMAlertMananger shareManager];
        if (obj.update.intValue == 1) {
            [alert creatAlertWithTitle:@""
                               message:obj.updateMsg
                        preferredStyle:UIAlertControllerStyleAlert
                           cancelTitle:DMTitleCancel
                            otherTitle:DMTitleUpgrade, nil];
        } else if (obj.update.intValue ==2) {
            [alert creatAlertWithTitle:@""
                               message:obj.updateMsg
                        preferredStyle:UIAlertControllerStyleAlert
                           cancelTitle:DMTitleMustUpgrade
                            otherTitle: nil];
        }
        
        [alert showWithViewController:self.window.rootViewController IndexBlock:^(NSInteger index) {
            if (obj.update.intValue == 1) {
                if (index == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.updateUrl]];
                }
            } else {
                if (index == 0) {
                    [self.window.rootViewController presentViewController:alert.alertCol animated:YES completion:nil];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.updateUrl]];
                }
            }
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"前台");
    if (!STR_IS_NIL([DMAccount getToken])) {
        [DMApiModel checkLoginRequest:@"1" block:^(BOOL result) { }];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
