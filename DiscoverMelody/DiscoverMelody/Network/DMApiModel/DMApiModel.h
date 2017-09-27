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
#import "DMQuestData.h"
#import "DMAnswerData.h"
#import "DMCloudConfigData.h"
#import "DMSetConfigData.h"
#import "DMEnums.h"
@interface DMApiModel : NSObject

//配置
+ (void)initConfigGet:(void(^)(BOOL result, DMSetConfigData *obj))complectionBlock;

//登录
+ (void)loginSystem:(NSString *)account psd:(NSString *)password block:(void(^)(BOOL result))complectionBlock;

//退出登录
+ (void)logoutSystem:(void(^)(BOOL result))complectionBlock;

//获取首页数据(老师／学生)
+ (void)getHomeCourseData:(NSString *)type block:(void(^)(BOOL result, NSArray *array))complectionBlock;

//课程列表(老师／学生)
+ (void)getCourseListData:(NSString *)type //身份类型
                     page:(NSInteger)page //页码，默认为1
                condition:(NSString *)condition //选择筛选条件
                    block:(void(^)(BOOL result, NSArray *array, BOOL nextPage))complectionBlock;

//获取课件列表
+ (void)getLessonList:(NSString *)lessonId //课节ID
                 block:(void(^)(BOOL result, NSArray *teachers, NSArray *students))complectionBlock;

//删除课件
+ (void)removeLessonFiles:(NSString *)lessonId//课节ID
                  fileIds:(NSString *)fileIds//课件ids
                    block:(void(^)(BOOL result))complectionBlock;

//进入课堂(学生／老师)
+ (void)joinClaseeRoom:(NSString *)lessonId //课节ID
            accessTime:(NSString *)accessTime //访问时间
                 block:(void(^)(BOOL result, DMClassDataModel *obj))complectionBlock;


//客服接口
+ (void)getCustomerInfo:(void(^)(BOOL result, DMCustomerDataModel *obj))complectionBlock;

//获取点播视频
+ (void)getVideoReplay:(NSString *)lessionId block:(void(^)(BOOL result, DMVideoReplayData *obj))complectionBlock;

//问卷问题（学生／老师）
+ (void)getQuestInfo:(NSString *)lessonID block:(void(^)(BOOL result, DMQuestData *obj))complectionBlock;
//提交问题答案
+ (void)commitQuestAnswer:(NSString *)lessonId answers:(NSArray *)answerArray block:(void(^)(BOOL result))complectionBlock;
//获取老师评语
+ (void)getTeacherAppraise:(NSString *)lessonId block:(void(^)(BOOL result, DMQuestData *obj))complectionBlock;

//获取百度云上传的配置信息
+ (void)getUploadConfigInfo:(NSString *)lessonId block:(void(^)(BOOL result, DMCloudConfigData *obj))complectionBlock;
//百度云上传成功后的通知
+ (void)getUploadSuccess:(NSString *)lessonId //课节id
              attachment:(NSString *)attachmentID //课件id
                 fileExt:(NSString *)fileExt //文件后缀，比如 .png
                   angle:(NSString *)angle
                   block:(void(^)(BOOL result, DMClassFileDataModel *obj))complectionBlock;

//声网用户状态记录
+ (void)agoraUserStatusLog:(NSString *)lessonID
                 targetUID:(NSString *)targetUid //动作用户的id
                 uploadUID:(NSString *)uploadUID //上报用户的id
                    action:(DMAgoraUserStatusLog)action
                     block:(void(^)(BOOL result))complectionBlock;

@end













