//
//  DMCloudConfigData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/21.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMCloudConfigData : DMBaseDataModel
@property (nonatomic, copy) NSString *access_key;
@property (nonatomic, copy) NSString *secret_key;
@property (nonatomic, copy) NSString *session_token;
@property (nonatomic, copy) NSString *bucketname;
@property (nonatomic, copy) NSString *objectname;
@property (nonatomic, copy) NSString *ID;
@end
