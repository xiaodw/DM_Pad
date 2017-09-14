//
//  DMApiModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMApiModel : NSObject

//登录
+ (void)loginSystem:(NSString *)account psd:(NSString *)password block:(void(^)(BOOL result))complectionBlock;

//退出登录
+ (void)logoutSystem:(void(^)(BOOL result))complectionBlock;

//获取首页数据(老师／学生)
+ (void)getHomeCourseData:(NSString *)type block:(void(^)(BOOL result, NSArray *array))complectionBlock;

//课程列表(老师／学生)
+ (void)getHomeCourseData:(NSString *)type //身份类型
                     sort:(NSString *)sort //DESC降序，ASC升序
                     page:(NSInteger)page //页码，默认为1
                condition:(NSString *)condition //选择筛选条件
                    block:(void(^)(BOOL result, NSArray *array))complectionBlock;

@end
