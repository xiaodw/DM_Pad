//
//  DMGeTuiManager.m
//  DiscoverMelody
//
//  Created by Ares on 2017/10/31.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMGeTuiManager.h"
#import "AppDelegate.h"
#import "DMGeTuiMsg.h"
#import "DMLiveController.h"
#import "DMMsgWebViewController.h"
#import "DMMsgNavViewController.h"
static DMGeTuiManager *bosinstance = nil;
@implementation DMGeTuiManager

#define dmGtAppId           @"4XfInsObYx80NTAJntlsjA"
#define dmGtAppKey          @"uyjoM5KvJB9W2oXTroMxT9"
#define dmGtAppSecret       @"bgL0jYZXnA9Js04JlNXGOA"
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bosinstance = [[super allocWithZone:NULL] init];
    });
    return bosinstance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [DMGeTuiManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [DMGeTuiManager shareInstance];
}

#pragma mark -
#pragma mark - 注册本地和远程通知
- (void)registerLocationAndRemoteNotification {
    [self registLocationNotification];
    [self registerRemoteNotification];
}

#pragma mark -
#pragma mark - 个推
- (void)startGeTuiSDK {
    [GeTuiSdk startSdkWithAppId:dmGtAppId appKey:dmGtAppKey appSecret:dmGtAppSecret delegate:self];
}

- (void)destroyGeTuiSDK {
    [GeTuiSdk destroy];
}

- (void)registerDeviceTokenGT:(NSString *)deviceToken {
    [GeTuiSdk registerDeviceToken:deviceToken];
}
- (void)resumeGT {
    [GeTuiSdk resume];
}
- (BOOL)setTagsGT:(NSArray *)tags {
    return YES;
}

// 绑定用户别名
- (void)bindAliasGT:(NSString *)alias andSequenceNum:(NSString *)aSn {
    [GeTuiSdk bindAlias:alias andSequenceNum:aSn];
}

// 解除用户别名
- (void)unbindAliasGT:(NSString *)alias andSequenceNum:(NSString *)aSn andIsSelf:(BOOL) isSelf {
    [GeTuiSdk unbindAlias:alias andSequenceNum:aSn andIsSelf:isSelf];
}

//发送SDK上行消息
- (NSString *)sendMessageGT:(NSData *)body error:(NSError **)error {
    return [GeTuiSdk sendMessage:body error:error];
}

//是否允许SDK后台运行
- (void)runBackgroundEnableGT:(BOOL) isEnable {
    [GeTuiSdk runBackgroundEnable:isEnable];
}

//是否启用SDK地理围栏功能
- (void)lbsLocationEnableGT:(BOOL)isEnable andUserVerify:(BOOL)isVerify {
    [GeTuiSdk lbsLocationEnable:isEnable andUserVerify:isVerify];
}

//设置关闭推送模式
- (void)setPushModeForOffGT:(BOOL)isValue {
    [GeTuiSdk setPushModeForOff:isValue];
}

//上行第三方自定义回执
- (BOOL)sendFeedbackMessageGT:(NSInteger)actionId andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId {
   return [GeTuiSdk sendFeedbackMessage:actionId andTaskId:taskId andMsgId:msgId];
}

//获取 SDK 系统版本号
- (NSString *)versionGT {
    return [GeTuiSdk version];
}

// 获取ClientID
- (NSString *)clientIdGT {
    return [GeTuiSdk clientId];
}

//获取 SDK 状态
- (SdkStatus)status {
    return [GeTuiSdk status];
}

//设置角标
- (void)setBadgeGT:(NSUInteger)value {
    [GeTuiSdk setBadge:value];
}

//复位角标
- (void)resetBadgeGT {
    [GeTuiSdk resetBadge];
}

// 设置渠道
- (void)setChannelIdGT:(NSString *)aChannelId {
    [GeTuiSdk setChannelId:aChannelId];
}

//处理远程推送消息
- (void)handleRemoteNotificationGT:(NSDictionary *)userInfo {
    [GeTuiSdk handleRemoteNotification:userInfo];
}

//清空通知
- (void)clearAllNotificationForNotificationBar {
    [GeTuiSdk clearAllNotificationForNotificationBar];
}

#pragma mark -
#pragma mark - GeTuiSdkDelegate 回调
//登入成功返回clientId
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
    //绑定别名
    //[GeTuiSdk bindAlias:@"321" andSequenceNum:clientId];
}
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];  //是否需要开启回执，需要业务来定
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);

    // 当app不在前台时，接收到的推送消息offLine值均为YES
    // 判断app是否是点击通知栏消息进行唤醒或开启
    // 如果是点击icon图标使得app进入前台，则不做操作，并且同一条推送通知，此方法只执行一次
    if (!offLine) {//  离线消息已经有苹果的apns推过消息了，避免上线后再次受到消息
        
        DMGeTuiMsg *msgObj = [DMGeTuiMsg mj_objectWithKeyValues:payloadMsg];
        if (msgObj.type == 4) {
            [self checkLoginForUser];
        } else {
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                [self registerNotification:1 andTitle:msgObj.data.title andMess:msgObj.data.body dic:msgObj.mj_keyValues];
            }else{
                [self registerLocalNotificationInOldWay:1 andTitle:msgObj.data.title andMess:msgObj.data.body dic:msgObj.mj_keyValues];
            }
        }
    } else {
//        //app后台时，点击通知栏或者app进入
    }


}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}
- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    
}
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}
+ (void)handelNotificationServiceRequest:(UNNotificationRequest *) request withComplete:(void (^)(void))completeBlock {
    
}
+ (void)handelNotificationServiceRequest:(UNNotificationRequest *)request withAttachmentsComplete:(void (^)(NSArray* attachments, NSArray* errors))completeBlock {
    
}

#pragma mark - iOS 10 中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
    
    [GeTuiSdk clearAllNotificationForNotificationBar];
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo]; //是否需要消息统计，根据业务来定

    [self pageJump:response.notification.request.content.userInfo];

    completionHandler();
}
#endif

- (void)pageJump:(NSDictionary *)userInfo {
    
    DMGeTuiMsg *msgObj = [DMGeTuiMsg mj_objectWithKeyValues:[userInfo objectForKey:@"payload"]];
    if (!OBJ_IS_NIL(msgObj)) {
        switch (msgObj.type) {
            case DMPushMessageType_Web: //文字通知 --> 点击 webview打开网页（可post提交token）
                [self gotoWebVC:msgObj];
                break;
            case DMPushMessageType_Nav: //文字通知 --> 点击打开Native页：1）个人主页；2）某节课的老师/学生课后总结；
                [self gotoNativePage:msgObj];
                break;
            case DMPushMessageType_CheckLogin: //验证登录
                //[self checkLoginForUser];
                break;
            default:
                break;
        }
    }
}

- (void)checkLoginForUser {
    [DMApiModel checkLoginRequest:@"" block:^(BOOL result) { }];
}

- (void)gotoWebVC:(DMGeTuiMsg *)obj {
    
    DMMsgWebViewController *msgWebVC = [[DMMsgWebViewController alloc] init];
    UINavigationController *webNav = [[UINavigationController alloc] initWithRootViewController:msgWebVC];
    msgWebVC.msgUrl = obj.data.url;
    msgWebVC.isHaveToken = (obj.data.is_token == 2 ? YES : NO);
    UIViewController *resVC = [self getCurrentVC];
    if (resVC) {
        DMTransitioningAnimationHelper *animationHelper = [DMTransitioningAnimationHelper new];
        animationHelper.animationType = DMTransitioningAnimationRight;
        animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
        webNav.transitioningDelegate = animationHelper;
        webNav.modalPresentationStyle = UIModalPresentationCustom;
        if ([resVC isKindOfClass:[DMMsgWebViewController class]]) {
            msgWebVC.animationHelper = animationHelper;
        } else {
            self.animationHelper = animationHelper;//注意
        }
        [resVC presentViewController:webNav animated:YES completion:nil];
    }
    
}

- (void)gotoNativePage:(DMGeTuiMsg *)obj {
    
    if (obj.data.native == 1) {
        [self goToHomePage:obj];
    } else if (obj.data.native == 2) {
        [self goToDMQuestionViewController:obj.data.lesson_id];
    } else { }
}

- (void)goToHomePage:(DMGeTuiMsg *)obj  {
    UIViewController *rootVC = APP_DELEGATE.window.rootViewController;
    if ([rootVC isKindOfClass:[DMRootViewController class]]) {
        DMRootViewController *nav = (DMRootViewController *)rootVC;
        NSLog(@"dd =======--- >>>> %@",nav.contentViewController.childViewControllers);
        if (nav.contentViewController) {
            if (nav.contentViewController.childViewControllers.count > 0) {
                UIViewController *v = [nav.contentViewController.childViewControllers lastObject];
                UIViewController *v1 = [nav.contentViewController.childViewControllers firstObject];
                if (v.presentedViewController != nil) {
                    [v dismissViewControllerAnimated:NO completion:nil];
                } else {
                    if ([v isKindOfClass:[DMLiveController class]]) {
                        DMLiveController *vv = (DMLiveController *)v;
                        [vv quitLiveVideoClickSure];
                    } else {
                        [v.navigationController popToViewController:v1 animated:NO];
                    }
                }

                if (APP_DELEGATE.dmrVC.selectedIndex != 0) {
                    [APP_DELEGATE.dmrVC togglePage:0];
                }
 
                [(DMMenuViewController *)APP_DELEGATE.dmrVC.menuViewController refreshTable];
            }
        }
    }
}

- (void)goToDMQuestionViewController:(NSString *)lID {
    DMMsgNavViewController *qtVC = [[DMMsgNavViewController alloc] init];
    qtVC.lessonID = lID;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qtVC];

    UIViewController *resVC = [self getCurrentVC];
    if (resVC) {
        DMTransitioningAnimationHelper *animationHelper = [DMTransitioningAnimationHelper new];
        animationHelper.animationType = DMTransitioningAnimationRight;
        animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
        nav.transitioningDelegate = animationHelper;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        if ([resVC isKindOfClass:[DMMsgNavViewController class]]) {
            qtVC.animationHelper = animationHelper;
        } else {
            self.animationHelper = animationHelper;//注意
        }
        [resVC presentViewController:nav animated:YES completion:nil];
    }
    
//
//    DMRootViewController *nav = (DMRootViewController *)APP_DELEGATE.window.rootViewController;
//    DMCourseListController *listVC = (DMCourseListController *)[nav.contentViewController.childViewControllers firstObject];
//    DMCourseDatasModel *model = [[DMCourseDatasModel alloc] init];
//    model.lesson_id = lID;
//    [listVC gotoDMQuestion:model];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *resultVC = nil;
    UIViewController *rootVC = APP_DELEGATE.window.rootViewController;
    if ([rootVC isKindOfClass:[DMRootViewController class]]) {
        DMRootViewController *nav = (DMRootViewController *)rootVC;
        NSLog(@"dd =======--- >>>> %@",nav.contentViewController.childViewControllers);
        UIViewController *v = [nav.contentViewController.childViewControllers lastObject];
        resultVC = [self getSubVC:v];
        if ([resultVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)resultVC;
            UIViewController *v = [nav.viewControllers lastObject];
            resultVC = v;
        }
    }
    return resultVC;
}

- (UIViewController *)getSubVC:(UIViewController *)vc {
    UIViewController *resVC = vc;
    if (vc.presentedViewController != nil) {
        resVC = [self getSubVC:vc.presentedViewController];
    }
    return resVC;
}


#pragma mark注册本地通知
-(void)registLocationNotification {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  
                                  // Enable or disable features based on authorization.
                              }];
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0&&[[UIDevice currentDevice].systemVersion floatValue] < 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    }
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        //        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
        //                                                                       UIRemoteNotificationTypeSound |
        //                                                                       UIRemoteNotificationTypeBadge);
        //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}



- (void)handlePushMessage:(NSDictionary *)dict notification:(UILocalNotification *)localNotification {
    //开始处理从通知栏点击进来的推送消息
    
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        if (localNotification) {
            //删除相应信息栏
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
        //应用的数字角标减1
        [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}


#pragma mark -
#pragma mark - 本地推送

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//使用 UNNotification 本地通知
-(void)registerNotification:(NSInteger )alerTime andTitle:(NSString*)title andMess:(NSString*)mes dic:(NSDictionary *)dicUserInfo {
    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:mes
                                                         arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo=@{@"payload":dicUserInfo};
    //content.userInfo= dicUserInfo;
    content.badge = 0;
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:alerTime repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber+1];
    //[GeTuiSdk setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
}
#endif

- (void)registerLocalNotificationInOldWay:(NSInteger)alertTime andTitle:(NSString*)title andMess:(NSString*)mes dic:(NSDictionary *)dicUserInfo {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔-不重复
    notification.repeatInterval = kCFCalendarUnitEra;
    
    // 通知内容
    notification.alertTitle = title;
    notification.alertBody = mes;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:dicUserInfo forKey:@"payload"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        //notification.repeatInterval = NSDayCalendarUnit;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[UIApplication sharedApplication].applicationIconBadgeNumber+1];
//    [GeTuiSdk setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
}

@end












