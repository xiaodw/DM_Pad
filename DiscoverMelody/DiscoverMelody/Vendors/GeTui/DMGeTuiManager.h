//
//  DMGeTuiManager.h
//  DiscoverMelody
//
//  Created by Ares on 2017/10/31.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface DMGeTuiManager : NSObject <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
+ (instancetype)shareInstance;

- (void)registerLocationAndRemoteNotification;
- (void)startGeTuiSDK;
- (void)destroyGeTuiSDK;
- (void)resumeGT;
- (void)registerDeviceTokenGT:(NSString *)deviceToken;
- (BOOL)setTagsGT:(NSArray *)tags;
// 绑定用户别名
- (void)bindAliasGT:(NSString *)alias andSequenceNum:(NSString *)aSn;
// 解除用户别名
- (void)unbindAliasGT:(NSString *)alias andSequenceNum:(NSString *)aSn andIsSelf:(BOOL) isSelf;
//发送SDK上行消息
- (NSString *)sendMessageGT:(NSData *)body error:(NSError **)error;
//是否允许SDK后台运行
- (void)runBackgroundEnableGT:(BOOL)isEnable;
//是否启用SDK地理围栏功能
- (void)lbsLocationEnableGT:(BOOL)isEnable andUserVerify:(BOOL)isVerify;
//设置关闭推送模式
- (void)setPushModeForOffGT:(BOOL)isValue;
//上行第三方自定义回执
- (BOOL)sendFeedbackMessageGT:(NSInteger)actionId andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId;
//获取 SDK 系统版本号
- (NSString *)versionGT;
// 获取ClientID
- (NSString *)clientIdGT;
//获取 SDK 状态
- (SdkStatus)status;
//设置角标
- (void)setBadgeGT:(NSUInteger)value;
//复位角标
- (void)resetBadgeGT;
// 设置渠道
- (void)setChannelIdGT:(NSString *)aChannelId;
//处理远程推送消息
- (void)handleRemoteNotificationGT:(NSDictionary *)userInfo;
//清空通知
- (void)clearAllNotificationForNotificationBar;
@end
