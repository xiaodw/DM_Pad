//
//  DMLiveVideoManager.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>


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

/////////信令////////

//发送同步消息（点对点）
//- (void)sendSynchronousMessage;


@end










