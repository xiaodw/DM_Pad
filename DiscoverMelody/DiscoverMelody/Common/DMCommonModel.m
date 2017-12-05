//
//  DMCommonModel.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/18.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCommonModel.h"

@implementation DMCommonModel
//更新失效的Token
+ (void)updateFailureToken:(NSString*)latestToken {
    [DMAccount saveToken:latestToken];
}

+ (void)removeUserAllDataAndOperation {
    [[DMHttpClient sharedInstance] cancleAllHttpRequestOperations];
    [DMAccount removeUserAllInfo];
}
@end
