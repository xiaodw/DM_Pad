//
//  AppDelegate+DMPushNotification.h
//  DiscoverMelody
//
//  Created by Ares on 2017/10/24.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "AppDelegate.h"
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate (DMPushNotification) <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
- (void)initGTServer;
@end
