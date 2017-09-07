//
//  DMHomeDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHomeDataModel : NSObject
//获取首页数据
+ (void)getHomeCourseData:(void(^)(BOOL result, NSMutableArray *array))complectionBlock;

@end
