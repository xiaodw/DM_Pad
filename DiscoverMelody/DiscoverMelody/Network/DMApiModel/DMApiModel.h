//
//  DMApiModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DMClassDataModel.h"
#import "DMClassFileDataModel.h"
#import "DMCustomerDataModel.h"
#import "DMVideoReplayData.h"
@interface DMApiModel : NSObject

//登录
+ (void)loginSystem:(NSString *)account psd:(NSString *)password block:(void(^)(BOOL result))complectionBlock;

//退出登录
+ (void)logoutSystem:(void(^)(BOOL result))complectionBlock;

//获取首页数据(老师／学生)
+ (void)getHomeCourseData:(NSString *)type block:(void(^)(BOOL result, NSArray *array))complectionBlock;

//课程列表(老师／学生)
+ (void)getCourseListData:(NSString *)type //身份类型
                     sort:(NSString *)sort //DESC降序，ASC升序
                     page:(NSInteger)page //页码，默认为1
                condition:(NSString *)condition //选择筛选条件
                    block:(void(^)(BOOL result, NSArray *array, BOOL nextPage))complectionBlock;

//获取课件列表
+ (void)getLessonList:(NSString *)lessonId //课节ID
                 block:(void(^)(BOOL result, NSArray *teachers, NSArray *students))complectionBlock;

//进入课堂(学生／老师)
+ (void)joinClaseeRoom:(NSString *)lessonId //课节ID
            accessTime:(NSString *)accessTime //访问时间
                 block:(void(^)(BOOL result, DMClassDataModel *obj))complectionBlock;


//客服接口
+ (void)getCustomerInfo:(void(^)(BOOL result, DMCustomerDataModel *obj))complectionBlock;

//获取点播视频
+ (void)getVideoReplay:(NSString *)lessionId block:(void(^)(BOOL result, DMVideoReplayData *obj))complectionBlock;

@end
