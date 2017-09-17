//
//  DMClassDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMClassDataModel : DMBaseDataModel
@property (nonatomic, copy) NSString *channel_key;
@property (nonatomic, copy) NSString *channel_name;
@property (nonatomic, copy) NSString *signaling_key;
@property (nonatomic, copy) NSString *uid;
@end
