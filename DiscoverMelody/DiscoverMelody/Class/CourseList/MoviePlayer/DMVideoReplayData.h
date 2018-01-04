//
//  DMVideoReplayData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMVideoReplayData : DMBaseDataModel
@property (nonatomic, strong) NSString *video_url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *start_time;
@end
