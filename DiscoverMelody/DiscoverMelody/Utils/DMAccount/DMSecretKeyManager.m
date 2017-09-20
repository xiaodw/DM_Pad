//
//  DMSecretKeyManager.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/17.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMSecretKeyManager.h"

@implementation DMSecretKeyManager
+ (DMSecretKeyManager *)shareManager {
    static DMSecretKeyManager *managerInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        managerInstance = [[self alloc] init];
    });
    return managerInstance;
}

- (void)updateDMSKeys:(DMClassDataModel *)obj {
    self.channelKey = obj.channel_key;
    self.channelName = obj.channel_name;
    self.signalingkey = obj.signaling_key;
    self.uid = obj.uid;
    self.appId = AgoraSAppID;//AgoraAppID;
    self.other_uid = obj.other_uid;
    self.obj = obj;
    
}

@end
