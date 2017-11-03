//
//  AppDelegate+DMPushNotification.m
//  DiscoverMelody
//
//  Created by Ares on 2017/10/24.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "AppDelegate+DMPushNotification.h"
#import "DMGeTuiManager.h"
@implementation AppDelegate (DMPushNotification)
#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    // [ GTSdk ]：向个推服务器注册deviceToken
    [[DMGeTuiManager shareInstance] registerDeviceTokenGT:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [[DMGeTuiManager shareInstance] handleRemoteNotificationGT:userInfo];//是否需要消息统计，根据业务来定
    // 控制台打印接收APNs信息
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark -
#pragma mark - 在app运行时恢复个推sdk运行
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [[DMGeTuiManager shareInstance] resumeGT];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 在进入前台的时候要将所有app角标清空，同时告诉个推此时角标为0
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self updateExpriedStatue];
    //推送个数大于0
    if (application.applicationIconBadgeNumber>0) {  //badge number 不为0，说明程序有那个圈圈图标
        //这里进行有关处理
        [application setApplicationIconBadgeNumber:0];   //将图标清零。
        [[DMGeTuiManager shareInstance] setBadgeGT:0];
    }
}

@end
