//
//  DMLiveVideoManager.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMLiveVideoManager.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "DMSecretKeyManager.h"
#import "DMSignalingKey.h"
#import "DMSignalingMsgData.h"

@interface DMLiveVideoManager () <AgoraRtcEngineDelegate>

@property (nonatomic, strong) NSString *channelKey;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, assign) NSInteger uId;
@property (nonatomic, strong) NSString *signalingKey;
@property (nonatomic, strong) NSString *app_ID;

@property (nonatomic, assign) BOOL isTapVideo;

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) UIView *localView;
@property (nonatomic, strong) UIView *remoteView;
@property (nonatomic, strong) AgoraRtcVideoCanvas *localVideoCanvas;
@property (nonatomic, strong) AgoraRtcVideoCanvas *remoteVideoCanvas;

@property (nonatomic, strong) AgoraAPI* inst;

- (void)bindingAccountInfo:(DMClassDataModel *)obj;//绑定声网账号信息
- (void)layoutLocalAndRemoteView:(UIView *)localView remote:(UIView *)remoteView;
//初始化声网
- (void)initializeAgoraEngine;

//初始化信令
- (void)initializeSignaling;

@end

@implementation DMLiveVideoManager

static DMLiveVideoManager* _instance = nil;

- (void)bindingAccountInfo:(DMClassDataModel *)obj {
    if (!OBJ_IS_NIL(obj)) {
        
        self.channelKey = obj.channel_key;
        self.channelName = obj.channel_name;
        self.uId = obj.uid.intValue;
        self.signalingKey = obj.signaling_key;
        self.app_ID = [DMSecretKeyManager shareManager].appId;

//        unsigned expiredTime =  (unsigned)[[NSDate date] timeIntervalSince1970] + 3600;
//        NSString * token =  [DMSignalingKey calcToken:AgoraSAppID certificate:certificate1 account:obj.uid expiredTime:expiredTime];
//        self.signalingKey = token;

        
    } else {
        //开发调试使用
        self.channelKey = @"";
//        self.channelName = @"1110";
//        self.uId = 54321;
//        self.app_ID = AgoraSAppID;//AgoraAppID;
//        
//        NSString *name = [NSString stringWithFormat:@"%ld", self.uId];//@"222222";
//        unsigned expiredTime =  (unsigned)[[NSDate date] timeIntervalSince1970] + 3600;
//        NSString * token =  [DMSignalingKey calcToken:AgoraSAppID certificate:certificate1 account:name expiredTime:expiredTime];
//        
//        self.signalingKey = token;//@"";
        
        
        self.channelName = @"1111";
        self.uId = 0;
        self.signalingKey = @"";
        self.app_ID = AgoraSAppID;
    }
}

-(void)didJoinedOfUid:(BlockDidJoinedOfUid)blockDidJoinedOfUid {
    self.blockDidJoinedOfUid = blockDidJoinedOfUid;
}

-(void)didOfflineOfUid:(BlockDidOfflineOfUid)blockDidOfflineOfUid {
    self.blockDidOfflineOfUid = blockDidOfflineOfUid;
}

-(void)didRejoinChannel:(BlockDidRejoinChannel)blockDidRejoinChannel {
    self.blockDidRejoinChannel = blockDidRejoinChannel;
}

-(void)firstRemoteVideoDecodedOfUid:(BlockFirstRemoteVideoDecodedOfUid)blockFirstRemoteVideoDecodedOfUid {
    self.blockFirstRemoteVideoDecodedOfUid = blockFirstRemoteVideoDecodedOfUid;
}

-(void)rtcEngineConnectionDidLostDidInterrupted:(BlockRtcEngineConnectionDidLostDidInterrupted)blockRtcEngineConnectionDidLostDidInterrupted {
    self.blockRtcEngineConnectionDidLostDidInterrupted = blockRtcEngineConnectionDidLostDidInterrupted;
}

- (void)startLiveVideo:(UIView *)localView
                remote:(UIView *)remoteView
            isTapVideo:(BOOL)isTap
      blockAudioVolume:(BlockAudioVolume)blockAudioVolume
    blockTapVideoEvent:(BlockTapVideoEvent)blockTapVideoEvent
{
    
    self.localView = localView;
    self.remoteView = remoteView;
    self.blockAudioVolume = blockAudioVolume;
    self.blockTapVideoEvent = blockTapVideoEvent;
    self.isTapVideo = isTap;
    
    [self addTapEvent];
    
    //[self bindingAccountInfo:nil];
    [self bindingAccountInfo:[DMSecretKeyManager shareManager].obj];
    [self initializeAgoraEngine];
    [self initializeSignaling];
}

//前后摄像头切换
- (void)switchCamera {
    [self.agoraKit switchCamera];
}

//声音控制
- (void)switchSound:(BOOL)isEnable block:(void(^)(BOOL success))block {
    [self.agoraKit muteLocalAudioStream:YES];
    int code = [self.agoraKit setEnableSpeakerphone:isEnable];
    if (block) {
        block((code == 0) ? YES : NO);
    }
}

- (void)addTapEvent {
    
    if (self.isTapVideo) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocal)];
        [ self.localView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRemote)];
        [ self.remoteView addGestureRecognizer:tap1];
    }
}

- (void)tapLocal {
    NSLog(@"点击本地视频");
    if (self.blockTapVideoEvent) {
        self.blockTapVideoEvent(DMLiveVideoViewType_Local);
    }
}

- (void)tapRemote {
    NSLog(@"点击远程视频");
    if (self.blockTapVideoEvent) {
        self.blockTapVideoEvent(DMLiveVideoViewType_Remote);
    }
}

- (void)quitLiveVideo:(BlockQuitLiveVideoEvent)blockQuitLiveVideoEvent {
    self.blockQuitLiveVideoEvent = blockQuitLiveVideoEvent;
    [self.agoraKit setupLocalVideo:nil];
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) { }];
    [self.agoraKit stopPreview];
    
    //此方法释放 Agora SDK 使用的所有资源，用户将无法再使用和回调该 SDK 内的其它方法
    //且是同步调用，资源释放后返回
    [AgoraRtcEngineKit destroy];
    if (self.blockQuitLiveVideoEvent) {
        self.blockQuitLiveVideoEvent(YES);
    }
}

- (void)initializeAgoraEngine {
    
    self.localVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    self.remoteVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    //初始化声网
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.app_ID delegate:self];
    //开始sdk日志
    [self enableAgoraLog];
    //设置频道模式，默认通信
    [self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
    //打开视频模式
    [self.agoraKit enableVideo];
    //设置本地视频属性
    [self.agoraKit setVideoProfile:[[DMConfigManager shareInstance].agoraVideoProfile intValue] swapWidthAndHeight: false];
    //设置本地视频显示属性
    [self setupLocalVideoDisplay];
    
    //设置音质（音频参数和应用场景 ）
    [self.agoraKit setAudioProfile:[DMSecretKeyManager shareManager].audio_profile scenario:[DMSecretKeyManager shareManager].audio_scenario];
    
    //启用音量提示
    [self.agoraKit enableAudioVolumeIndication:200 smooth:3];
    
    //开始预览
    [self.agoraKit startPreview];
    //加入频道
    [self joinChannel];
}

- (void)enableAgoraLog {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *aLogFilePath = [path stringByAppendingPathComponent:@"agorakitLog.txt"];
    [self.agoraKit setLogFile:aLogFilePath];
}

- (void)setupLocalVideoDisplay {
    _localVideoCanvas.uid = self.uId;
    _localVideoCanvas.view = self.localView;
    _localVideoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:_localVideoCanvas];
}

- (void)setupRemoteVideoDisplay:(NSUInteger)uid {
    _remoteVideoCanvas.uid = uid;
    _remoteVideoCanvas.view = self.remoteView;
    _remoteVideoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupRemoteVideo:_remoteVideoCanvas];
}

- (void)layoutLocalAndRemoteView:(UIView *)localView remote:(UIView *)remoteView {
    
    self.localView = localView;
    self.remoteView = remoteView;
    
    _localVideoCanvas.view = self.localView;
    [self.agoraKit setupLocalVideo:_localVideoCanvas];
    
    _remoteVideoCanvas.view = self.remoteView;
    [self.agoraKit setupRemoteVideo:_remoteVideoCanvas];
    
}

- (void)joinChannel {
    [self.agoraKit joinChannelByKey:self.channelKey
                        channelName:self.channelName
                               info:nil
                                uid:self.uId
                        joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed)
    {
        NSLog(@"自己加入用户id（%lu）", (unsigned long)uid);
        //开始外放
        [self.agoraKit setEnableSpeakerphone:YES];
        
        [self.agoraKit adjustPlaybackSignalVolume:[DMSecretKeyManager shareManager].play_volume];
        [self.agoraKit adjustRecordingSignalVolume:[DMSecretKeyManager shareManager].record_volume];
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];

}

- (void)setIdleTimerActive:(BOOL)active {
    //[UIApplication sharedApplication].idleTimerDisabled = !active;
}

#pragma mark -
#pragma mark - AgoraRtcEngineDelegate
//本地首帧视频显示回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {
    NSLog(@"本地首帧");
}

//远端首帧视频显示回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size
          elapsed:(NSInteger)elapsed
{
    NSLog(@"远程首帧");
    if (self.blockFirstRemoteVideoDecodedOfUid) {
        self.blockFirstRemoteVideoDecodedOfUid(uid, size);
    }
    [self setupRemoteVideoDisplay:uid];
}

//Channel Key过期回调(rtcEngineRequestChannelKey)
- (void)rtcEngineRequestChannelKey:(AgoraRtcEngineKit *)engine {
    NSLog(@"Channel Key过期");
}

//用户加入回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"有用户加入用户id（%lu）", (unsigned long)uid);
    if (self.blockDidJoinedOfUid) {
       self.blockDidJoinedOfUid(uid);
    }
    
}

//用户离线
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    NSLog(@"有用户离线用户id（%lu）", (unsigned long)uid);
    if (self.blockDidOfflineOfUid) {
        self.blockDidOfflineOfUid(uid);
    }
    
}

//用户重新加入频道
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString*)channel withUid:(NSUInteger)uid
          elapsed:(NSInteger) elapsed
{
    NSLog(@"有用户重新加入--->> 频道（%@），用户id（%lu）", channel, (unsigned long)uid);
    if (self.blockDidRejoinChannel) {
        self.blockDidRejoinChannel(uid, channel);
    }
    
}

//用户停止/重新发送视频回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
   NSLog(@"用户停止视频/重发----》 %d", muted);
}

//用户启用/关闭视频
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid{
    NSLog(@"用户启动或者关闭视频-----》 %d", enabled);
}

//离开频道的回调 貌似是骗人的，不起作用
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didLeaveChannelWithStats:(AgoraRtcStats *)stats {
//    self.blockQuitLiveVideoEvent(YES);
}

//摄像头的启用
- (void)rtcEngineCameraDidReady:(AgoraRtcEngineKit *)engine {
    NSLog(@"启动摄像头");
}

//视频功能停止
- (void)rtcEngineVideoDidStop:(AgoraRtcEngineKit *)engine {
    NSLog(@"停止视频功能");
}

//音量提示回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray*)speakers
      totalVolume:(NSInteger)totalVolume
{
//    NSLog(@"音量回调---- > %@", speakers);
    if (self.blockAudioVolume) {
        self.blockAudioVolume(totalVolume, speakers);
    }
}


- (void)rtcEngine:(AgoraRtcEngineKit *)engine videoSizeChangedOfUid:(NSUInteger)uid size:(CGSize)size rotation:(NSInteger)rotation {
    NSLog(@"摄像头旋转角度 = %ld", (long)rotation);
}

//统计数据
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportRtcStats:(AgoraRtcStats*)stats {
//NSLog(@"统计数据");
}

//本地视频统计 - 2秒触发一次
- (void)rtcEngine:(AgoraRtcEngineKit *)engine localVideoStats:(AgoraRtcLocalVideoStats*)stats {
//NSLog(@"本地视频统计 - 2秒触发一次");
}

//远程视频统计 - 2秒触发一次
- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStats:(AgoraRtcRemoteVideoStats*)stats {
//NSLog(@"远程视频统计 - 2秒触发一次");
}

//网络连接中断 - SDK会一直自动重连，除非主动离开频道
- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    NSLog(@"网络中断连接");
    if (self.blockRtcEngineConnectionDidLostDidInterrupted) {
        self.blockRtcEngineConnectionDidLostDidInterrupted();
    }
    //[self agoraUserStatusLog:self.lessonID targetUID:[DMAccount getUserID] uploadUID:[DMAccount getUserID] action:DMAgoraUserStatusLog_Neterr];
}

//网络连接丢失 -》在一定时间内（默认 10 秒）如果没有重连成功，触发 rtcEngineConnectionDidLost 回调。
//除非 APP 主动调用 leaveChannel，SDK 仍然会自动重连。
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    NSLog(@"网络连接丢失");
    if (self.blockRtcEngineConnectionDidLostDidInterrupted) {
        self.blockRtcEngineConnectionDidLostDidInterrupted();
    }
}

#pragma mark -
#pragma mark - 信令SDK

- (void)initializeSignaling {
    self.inst = [AgoraAPI getInstanceWithoutMedia:self.app_ID];

    WS(weakSelf)
    [self.inst login2:self.app_ID
              account:[NSString stringWithFormat:@"%ld", (long)self.uId]
                token:self.signalingKey
                  uid:0
             deviceID:@""
      retry_time_in_s:30
          retry_count:5
     ];
    //收到消息
    _inst.onMessageInstantReceive = ^(NSString *account, uint32_t uid, NSString *msg) {
        NSLog(@"接收到来自 %@，的超级好消息 %@", account , msg);
        if (STR_IS_NIL(msg)) { return;}
        
        DMSignalingMsgData *responseDataModel = [DMSignalingMsgData mj_objectWithKeyValues:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(responseDataModel.type == DMSignalingMsgSynCourse) {
                if (weakSelf.blockOnMessageInstantReceive) {
                    weakSelf.blockOnMessageInstantReceive(account, responseDataModel);
                }
                return;
            }
            
            if(responseDataModel.type == DMSignalingMsgSynWhiteBoard) {
                if (weakSelf.blockOnMessageInstantReceiveWhiteBoard) {
                    weakSelf.blockOnMessageInstantReceiveWhiteBoard(account, responseDataModel);
                }
                return;
            }
        });
    };
    
    //登录成功
    _inst.onLoginSuccess = ^(uint32_t uid, int fd) {
        if (weakSelf.blockSignalingOnLoginSuccess) {
            weakSelf.blockSignalingOnLoginSuccess(uid);
        }
    };
    //登录失败
    _inst.onLoginFailed = ^(AgoraEcode ecode) {
        if (weakSelf.blockSignalingOnLoginFailed) {
            weakSelf.blockSignalingOnLoginFailed(ecode);
        }
    };
    //登录之后，失去和服务器的连接
    _inst.onLogout = ^(AgoraEcode ecode) {
        if (weakSelf.blockSignalingOnLogout) {
            weakSelf.blockSignalingOnLogout(ecode);
        }
    };
}

-(void)onSignalingLoginSuccess:(BlockSignalingOnLoginSuccess)blockSignalingOnLoginSuccess {
    self.blockSignalingOnLoginSuccess = blockSignalingOnLoginSuccess;
}

-(void)onSignalingLoginFailed:(BlockSignalingOnLoginFailed)blockSignalingOnLoginFailed {
    self.blockSignalingOnLoginFailed = blockSignalingOnLoginFailed;
}

-(void)onSignalingLogout:(BlockSignalingOnLogout)blockSignalingOnLogout {
    self.blockSignalingOnLogout = blockSignalingOnLogout;
}

-(void)onSignalingMessageReceive:(BlockOnMessageInstantReceive)blockOnMessageInstantReceive {
    self.blockOnMessageInstantReceive = blockOnMessageInstantReceive;
}

- (void)sendMessageSynEvent:(NSString *)name
                        msg:(NSString*)msg
                      msgID:(NSString*)msgID
                    success:(void(^)(NSString *messageID))success
                      faile:(void(^)(NSString *messageID, AgoraEcode ecode))faile {
    
    
    NSString *account = STR_IS_NIL(name) ? [DMSecretKeyManager shareManager].other_uid : name;
    NSLog(@"发送信令消息的 account = %@", account);
    [_inst messageInstantSend:account uid:0 msg:msg msgID:msgID];
    
    //发送成功
    _inst.onMessageSendSuccess = ^(NSString *messageID) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(messageID);
        });
         NSLog(@"发送信令消息成功了");
    };
    //失败
    _inst.onMessageSendError = ^(NSString *messageID, AgoraEcode ecode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            faile(messageID, ecode);
        });
        NSLog(@"发送信令消息的失败了");
    };
}

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [DMLiveVideoManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [DMLiveVideoManager shareInstance];
}

@end
