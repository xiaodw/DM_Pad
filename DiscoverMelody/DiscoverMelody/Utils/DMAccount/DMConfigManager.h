//
//  DMConfigManager.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/22.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMSetConfigData.h"
@interface DMConfigManager : NSObject

@property (nonatomic, copy) NSString *apiHost;
@property (nonatomic, copy) NSString *logHost;
@property (nonatomic, copy) NSString *uploadMaxSize;
@property (nonatomic, copy) NSString *agoraAppId;
@property (nonatomic, copy) NSString *agoraVideoProfile;

+ (instancetype)shareInstance;
- (void)initConfigInformation;
- (void)saveConfigInfo:(DMSetConfigData *)configObj;

@end
