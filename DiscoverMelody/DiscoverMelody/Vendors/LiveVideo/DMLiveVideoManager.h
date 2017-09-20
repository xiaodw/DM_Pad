//
//  DMLiveVideoManager.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "agorasdk.h"

typedef NS_ENUM(NSInteger, DMLiveVideoViewType) {
    DMLiveVideoViewType_Local = 0,
    DMLiveVideoViewType_Remote,
};

typedef void (^BlockAudioVolume)(NSInteger totalVolume ,NSArray *speakers); //音量
typedef void (^BlockTapVideoEvent)(DMLiveVideoViewType type);//屏幕点击事件
typedef void (^BlockQuitLiveVideoEvent)(BOOL success);//退出直播事件

typedef void (^BlockDidJoinedOfUid)(NSUInteger uid);//有用户加入
typedef void (^BlockDidOfflineOfUid)(NSUInteger uid);//有用户离开
typedef void (^BlockDidRejoinChannel)(NSUInteger uid, NSString *channel);//用户重新加入

typedef void (^BlockFirstRemoteVideoDecodedOfUid)(NSUInteger uid, CGSize size);//远程首帧回调

//信令接收消息
typedef void (^BlockOnMessageInstantReceive)(NSString* account, NSString* msg);//接收消息
typedef void (^BlockSignalingOnLoginSuccess)(uint32_t uid);//信令登录成功
typedef void (^BlockSignalingOnLoginFailed)(AgoraEcode ecode);//信令登录失败
typedef void (^BlockSignalingOnLogout)(AgoraEcode ecode);//信令与服务器失去连接

@interface DMLiveVideoManager : NSObject
@property (nonatomic, strong) BlockAudioVolume blockAudioVolume;
@property (nonatomic, strong) BlockTapVideoEvent blockTapVideoEvent;
@property (nonatomic, strong) BlockQuitLiveVideoEvent blockQuitLiveVideoEvent;

@property (nonatomic, strong) BlockDidJoinedOfUid blockDidJoinedOfUid;
@property (nonatomic, strong) BlockDidOfflineOfUid blockDidOfflineOfUid;
@property (nonatomic, strong) BlockDidRejoinChannel blockDidRejoinChannel;

@property (nonatomic, strong) BlockFirstRemoteVideoDecodedOfUid blockFirstRemoteVideoDecodedOfUid;

+ (instancetype)shareInstance;
/** 开始声网视频直播
 *
 *  @param localView            本地视频
 *  @param remoteView           远程视频
 *  @param isTap                是否需要添加点击事件
 *  @param blockAudioVolume     音量的回调（包含音量值，用户数组）
 *  @param blockTapVideoEvent   窗口点击事件回调
 */
- (void)startLiveVideo:(UIView *)localView
                remote:(UIView *)remoteView
            isTapVideo:(BOOL)isTap
      blockAudioVolume:(BlockAudioVolume)blockAudioVolume
      blockTapVideoEvent:(BlockTapVideoEvent)blockTapVideoEvent;

//退出上课视频
- (void)quitLiveVideo:(BlockQuitLiveVideoEvent)blockQuitLiveVideoEvent;

//前后摄像头切换
- (void)switchCamera;

//声音控制
- (void)switchSound:(BOOL)isEnable block:(void(^)(BOOL success))block;

-(void)didJoinedOfUid:(BlockDidJoinedOfUid)blockDidJoinedOfUid;
-(void)didOfflineOfUid:(BlockDidOfflineOfUid)blockDidOfflineOfUid;
-(void)didRejoinChannel:(BlockDidRejoinChannel)blockDidRejoinChannel;
-(void)firstRemoteVideoDecodedOfUid:(BlockFirstRemoteVideoDecodedOfUid)blockFirstRemoteVideoDecodedOfUid;


/////////信令////////

@property (nonatomic, strong)BlockOnMessageInstantReceive blockOnMessageInstantReceive;
@property (nonatomic, strong)BlockSignalingOnLoginSuccess blockSignalingOnLoginSuccess;
@property (nonatomic, strong)BlockSignalingOnLoginFailed blockSignalingOnLoginFailed;
@property (nonatomic, strong)BlockSignalingOnLogout blockSignalingOnLogout;

-(void)onSignalingMessageReceive:(BlockOnMessageInstantReceive)blockOnMessageInstantReceive;
//
/** 发送同步消息（点对点）
 *
 *  @param name          用户登录厂商 app 的账号(对方的ID)
 *  @param msg           消息正文。每条消息最大为 8K 可见字符
 *  @param msgID         可见字符，可填空。用于回调的消息标示
 *  @param success       消息发送成功
 *  @param faile         消息发送失败
 */
- (void)sendMessageSynEvent:(NSString *)name
                        msg:(NSString*)msg
                      msgID:(NSString*)msgID
                    success:(void(^)(NSString *messageID))success
                      faile:(void(^)(NSString *messageID, AgoraEcode ecode))faile;


@end










