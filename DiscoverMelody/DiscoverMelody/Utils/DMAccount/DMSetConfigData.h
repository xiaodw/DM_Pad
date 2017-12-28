//
//  DMSetConfigData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/22.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@class DMSetConfigData;

@interface DMAppUpgradeData : NSObject
@property (nonatomic, copy) NSString *ver;
@property (nonatomic, copy) NSString *update;
@property (nonatomic, copy) NSString *updateMsg;
@property (nonatomic, copy) NSString *updateUrl;
@end

@interface DMSetConfigData : DMBaseDataModel
@property (nonatomic, copy) NSString *apiHost;
@property (nonatomic, copy) NSString *logHost;
@property (nonatomic, copy) NSString *uploadMaxSize;
@property (nonatomic, copy) NSString *agoraAppId;
@property (nonatomic, strong) DMAppUpgradeData *app;
@property (nonatomic, copy) NSString *agoraVideoProfile;
@property (nonatomic, copy) NSString *uploadNum;
@end
