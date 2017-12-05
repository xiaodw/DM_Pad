//
//  DMCommonModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/18.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCommonModel : NSObject
//更新失效的Token
+ (void)updateFailureToken:(NSString*)latestToken;
//清空用户所有数据以及取消网络请求
+ (void)removeUserAllDataAndOperation;
@end
