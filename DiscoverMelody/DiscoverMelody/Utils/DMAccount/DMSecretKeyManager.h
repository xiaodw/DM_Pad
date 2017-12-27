//
//  DMSecretKeyManager.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/17.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSecretKeyManager : NSObject
@property (nonatomic, copy) NSString *channelKey;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *signalingkey;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, strong) DMClassDataModel *obj;
@property (nonatomic, copy) NSString *other_uid;

@property (nonatomic, assign) NSInteger play_volume;//播放音量
@property (nonatomic, assign) NSInteger record_volume;//录音音量
@property (nonatomic, assign) NSInteger audio_scenario;//音效模式
@property (nonatomic, assign) NSInteger audio_profile;//采样频率

+ (DMSecretKeyManager *)shareManager;
- (void)updateDMSKeys:(DMClassDataModel *)obj;

@end
