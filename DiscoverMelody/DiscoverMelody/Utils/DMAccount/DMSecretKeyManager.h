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
+ (DMSecretKeyManager *)shareManager;
- (void)updateDMSKeys:(DMClassDataModel *)obj;
@end
