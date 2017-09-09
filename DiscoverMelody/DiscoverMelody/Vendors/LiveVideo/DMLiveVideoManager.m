//
//  DMLiveVideoManager.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMLiveVideoManager.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface DMLiveVideoManager () <AgoraRtcEngineDelegate>

@property (nonatomic, strong) NSString *channelKey;
@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, assign) NSInteger uId;
@property (nonatomic, strong) NSString *signalingKey;

@property (nonatomic, assign) BOOL isTapVideo;

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) UIView *localView;
@property (nonatomic, strong) UIView *remoteView;
@property (nonatomic, strong) AgoraRtcVideoCanvas *localVideoCanvas;
@property (nonatomic, strong) AgoraRtcVideoCanvas *remoteVideoCanvas;

- (void)bindingAccountInfo:(id)obj;//绑定声网账号信息
- (void)layoutLocalAndRemoteView:(UIView *)localView remote:(UIView *)remoteView;
//初始化声网
- (void)initializeAgoraEngine;

@end

@implementation DMLiveVideoManager

static DMLiveVideoManager* _instance = nil;

- (void)bindingAccountInfo:(id)obj {
    self.channelKey = @"";
    self.channelName = @"111";
    self.uId = 0;
    self.signalingKey = @"";
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
    
    [self bindingAccountInfo:nil];
    [self initializeAgoraEngine];
}


- (void)quitLiveVideo:(BlockQuitLiveVideoEvent)blockQuitLiveVideoEvent {
    self.blockQuitLiveVideoEvent = blockQuitLiveVideoEvent;
    [self.agoraKit setupLocalVideo:nil];
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) { }];
    [self.agoraKit stopPreview];
    
    //此方法释放 Agora SDK 使用的所有资源，用户将无法再使用和回调该 SDK 内的其它方法
    //且是同步调用，资源释放后返回
    [AgoraRtcEngineKit destroy];
    self.blockQuitLiveVideoEvent(YES);
}

//前后摄像头切换
- (void)switchCamera {
    [self.agoraKit switchCamera];
}

//声音控制
- (void)switchSound:(BOOL)isEnable block:(void(^)(BOOL success))block {
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

- (void)initializeAgoraEngine {
    
    self.localVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    self.remoteVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    //初始化声网
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraAppID delegate:self];
    //设置频道模式，默认通信
    [self.agoraKit setChannelProfile:AgoraRtc_ChannelProfile_Communication];
    //打开视频模式
    [self.agoraKit enableVideo];
    //设置本地视频属性
    [self.agoraKit setVideoProfile:AgoraRtc_VideoProfile_360P swapWidthAndHeight: false];
    //设置本地视频显示属性
    [self setupLocalVideoDisplay];
    //启用音量提示
    [self.agoraKit enableAudioVolumeIndication:2000 smooth:3];
    //开始预览
    [self.agoraKit startPreview];
    //加入频道
    [self joinChannel];
}

- (void)setupLocalVideoDisplay {
    _localVideoCanvas.uid = 1;
    _localVideoCanvas.view = self.localView;
    _localVideoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:_localVideoCanvas];
}

- (void)tapLocal {
    NSLog(@"点击本地视频");
    self.blockTapVideoEvent(DMLiveVideoViewType_Local);
}

- (void)tapRemote {
    NSLog(@"点击远程视频");
    self.blockTapVideoEvent(DMLiveVideoViewType_Remote);
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
    [self.agoraKit joinChannelByKey:nil
                        channelName:self.channelName
                               info:nil
                                uid:self.uId
                        joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed)
    {
        //开始外放
        [self.agoraKit setEnableSpeakerphone:NO];
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
    [self setupRemoteVideoDisplay:uid];
}

//Channel Key过期回调(rtcEngineRequestChannelKey)
- (void)rtcEngineRequestChannelKey:(AgoraRtcEngineKit *)engine {
    NSLog(@"Channel Key过期");
}

//用户加入回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"有用户加入用户id（%lu）", (unsigned long)uid);
}

//用户离线
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    NSLog(@"有用户离线用户id（%lu）", (unsigned long)uid);
}

//用户重新加入频道
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didRejoinChannel:(NSString*)channel withUid:(NSUInteger)uid
          elapsed:(NSInteger) elapsed
{
    NSLog(@"有用户重新加入--->> 频道（%@），用户id（%lu）", channel, (unsigned long)uid);
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
//    NSLog(@"音量回调");
    self.blockAudioVolume(totalVolume, speakers);
}

//统计数据
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportRtcStats:(AgoraRtcStats*)stats {

}

//本地视频统计 - 2秒触发一次
- (void)rtcEngine:(AgoraRtcEngineKit *)engine localVideoStats:(AgoraRtcLocalVideoStats*)stats {

}

//远程视频统计 - 2秒触发一次
- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStats:(AgoraRtcRemoteVideoStats*)stats {

}

//网络连接中断 - SDK会一直自动重连，除非主动离开频道
- (void)rtcEngineConnectionDidInterrupted:(AgoraRtcEngineKit *)engine {
    NSLog(@"网络中断连接");
}

//网络连接丢失 -》在一定时间内（默认 10 秒）如果没有重连成功，触发 rtcEngineConnectionDidLost 回调。
//除非 APP 主动调用 leaveChannel，SDK 仍然会自动重连。
- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    NSLog(@"网络连接丢失");
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
