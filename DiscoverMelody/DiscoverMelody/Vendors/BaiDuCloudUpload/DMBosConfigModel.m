//
//  DMBosConfigModel.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/22.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBosConfigModel.h"

@implementation DMBosConfigModel
+ (DMBosConfigModel *)shareManager {
    static DMBosConfigModel *managerInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        managerInstance = [[self alloc] init];
    });
    return managerInstance;
}
@end
