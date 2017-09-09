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

typedef void (^BlockAudioVolume)(NSInteger totalVolume ,NSArray *speakers);
typedef void (^BlockTapVideoEvent)(DMLiveVideoViewType type);

@interface DMLiveVideoManager : NSObject
@property (nonatomic, strong) BlockAudioVolume blockAudioVolume;
@property (nonatomic, strong) BlockTapVideoEvent blockTapVideoEvent;
+ (instancetype)shareInstance;
/** 开始声网视频直播
 *
 *  @param localView        本地视频
 *  @param remoteView       远程视频
 *  @param blockAudioVolume 音量的回调（包含音量值，用户数组）
 */
- (void)startLiveVideo:(UIView *)localView
                remote:(UIView *)remoteView
            isTapVideo:(BOOL)isTap
      blockAudioVolume:(BlockAudioVolume)blockAudioVolume
      blockTapVideoEvent:(BlockTapVideoEvent)blockTapVideoEvent;

@end
