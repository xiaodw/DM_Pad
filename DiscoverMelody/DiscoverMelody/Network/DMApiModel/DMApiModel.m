//
//  DMApiModel.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMApiModel.h"
#import "DMLoginDataModel.h"
#import "DMSecretKeyManager.h"
@implementation DMApiModel

//配置
+ (void)initConfigGet:(void(^)(BOOL result, DMSetConfigData *obj))complectionBlock {
    [[DMHttpClient sharedInstance] synRequestWithUrl:DM_Init_SetConfig_Url dataModelClass:[DMSetConfigData class] isMustToken:NO success:^(id responseObject) {
        DMSetConfigData *model = (DMSetConfigData *)responseObject;
        [[DMConfigManager shareInstance] saveConfigInfo:responseObject];
        complectionBlock(YES, model);
    } failure:^(NSError *error) {
        complectionBlock(NO, nil);
    }];
}

//登录
+ (void)loginSystem:(NSString *)account psd:(NSString *)password block:(void(^)(BOOL result))complectionBlock {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:account, @"account", password, @"password", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_User_Loing_Url parameters:dic method:DMHttpRequestPost dataModelClass:[DMLoginDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            //保存数据
            DMLoginDataModel *model = (DMLoginDataModel *)responseObject;
            [DMAccount saveAccountInfo:model];
            complectionBlock(YES);
        }
    } failure:^(NSError *error) {
        complectionBlock (NO);
    }];
}

//退出登录
+ (void)logoutSystem:(void(^)(BOOL result))complectionBlock {
    [[DMHttpClient sharedInstance] initWithUrl:DM_User_Logout_Url parameters:nil method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:YES success:^(id responseObject) {
        //清除用户数据
        [DMAccount removeUserAllInfo];
        complectionBlock(YES);
    } failure:^(NSError *error) {
        complectionBlock(NO);
    }];
}

//首页数据
+ (void)getHomeCourseData:(NSString *)type block:(void(^)(BOOL result, NSArray *array))complectionBlock {
    
    NSString *url = DM_User_Scourse_Index_Url;
    if (type.intValue == 1) {
        url = DM_User_Tcourse_Index_Url;
    }
    
    [[DMHttpClient sharedInstance] initWithUrl:url parameters:nil method:DMHttpRequestPost dataModelClass:[DMHomeDataModel class] isMustToken:YES success:^(id responseObject) {
        DMHomeDataModel *model = (DMHomeDataModel *)responseObject;
        complectionBlock(YES, model.list);
    } failure:^(NSError *error) {
        complectionBlock(NO, nil);
    }];
    
}

//课程列表(老师／学生)
+ (void)getCourseListData:(NSString *)type //身份类型
                     sort:(NSString *)sort //DESC降序，ASC升序
                     page:(NSInteger)page //页码，默认为1
                condition:(NSString *)condition //选择筛选条件
                    block:(void(^)(BOOL result, NSArray *array, BOOL nextPage))complectionBlock
{

    NSString *url = DM_User_Scourse_List_Url;
    if (type.intValue == 1) {
        url = DM_User_Tcourse_List_Url;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:condition, @"condition", [NSString stringWithFormat:@"%ld",page], @"page", sort, @"sort", nil];
    
    [[DMHttpClient sharedInstance] initWithUrl:url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMHomeDataModel class]
                                   isMustToken:YES
                                       success:^(id responseObject)
    {
        DMHomeDataModel *model = (DMHomeDataModel *)responseObject;
        BOOL isHave = YES;
        if (model.page_next.intValue == 0) {
            isHave = NO;
        }
        complectionBlock(YES, model.list, isHave);
    } failure:^(NSError *error) {
        complectionBlock(NO, nil, NO);
    }];
}

//获取课件列表
+ (void)getLessonList:(NSString *)lessonId //课节ID
                block:(void(^)(BOOL result, NSArray *teachers, NSArray *students))complectionBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lessonId, @"lesson_id", nil];
    
    [[DMHttpClient sharedInstance] initWithUrl:DM_Attachment_FileList_Url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMClassFilesDataModel class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMClassFilesDataModel *model = (DMClassFilesDataModel *)responseObject;
         complectionBlock(YES, model.teacher_list, model.student_list);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil, nil);
     }];
}

//删除课件
+ (void)removeLessonFiles:(NSString *)lessonId//课节ID
                  fileIds:(NSString *)fileIds//课件ids
                    block:(void(^)(BOOL result))complectionBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lessonId, @"lesson_id", fileIds, @"ids",nil];
    
    [[DMHttpClient sharedInstance] initWithUrl:DM_Attachment_fileMove_Url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[NSObject class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         complectionBlock(YES);
     } failure:^(NSError *error) {
         complectionBlock(NO);
     }];
}

//进入课堂(学生／老师)
+ (void)joinClaseeRoom:(NSString *)lessonId //课节ID
            accessTime:(NSString *)accessTime //访问时间
                 block:(void(^)(BOOL result, DMClassDataModel *obj))complectionBlock
{
    NSString *type = [DMAccount getUserIdentity];
    NSString *url = DM_Student_Access_Url;
    if (type.intValue == 1) {
        url = DM_Teacher_Access_Url;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lessonId, @"lesson_id", accessTime, @"access_time", nil];
    
    [[DMHttpClient sharedInstance] initWithUrl:url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMClassDataModel class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMClassDataModel *model = (DMClassDataModel *)responseObject;
         [[DMSecretKeyManager shareManager] updateDMSKeys:model];
         complectionBlock(YES, model);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil);
     }];
}

//获取客服
+ (void)getCustomerInfo:(void(^)(BOOL result, DMCustomerDataModel *obj))complectionBlock {

    [[DMHttpClient sharedInstance] initWithUrl:DM_Customer_Url
                                    parameters:nil
                                        method:DMHttpRequestPost
                                dataModelClass:[DMCustomerDataModel class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMCustomerDataModel *model = (DMCustomerDataModel *)responseObject;
         complectionBlock(YES, model);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil);
     }];
}

//获取点播视频
+ (void)getVideoReplay:(NSString *)lessionId block:(void(^)(BOOL result, DMVideoReplayData *obj))complectionBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lessionId, @"lesson_id", nil];
    
    [[DMHttpClient sharedInstance] initWithUrl:DM_Video_Replay_Url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMVideoReplayData class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMVideoReplayData *model = (DMVideoReplayData *)responseObject;
         complectionBlock(YES, model);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil);
     }];
}

//获取问题列表
+ (void)getQuestInfo:(NSString *)lessonID block:(void (^)(BOOL result, DMQuestData *obj))complectionBlock {
    NSString *type = [DMAccount getUserIdentity];
    NSString *url = DM_Student_Question_List_Url;
    if (type.intValue == 1) {
        url = DM_Teacher_Question_List_Url;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lessonID, @"lesson_id", nil];
    [[DMHttpClient sharedInstance] initWithUrl:url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMQuestData class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMQuestData *model = (DMQuestData *)responseObject;
         complectionBlock(YES, model);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil);
     }];
}

//提交问题答案
+ (void)commitQuestAnswer:(NSString *)lessonId answers:(NSArray *)answerArray block:(void(^)(BOOL result))complectionBlock
{
    NSString *type = [DMAccount getUserIdentity];
    NSString *url = DM_Submit_Student_Answer_Url;
    if (type.intValue == 1) {
        url = DM_Submit_Teacher_Answer_Url;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:answerArray, @"answer_json", nil];
    [[DMHttpClient sharedInstance] initWithUrl:url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[NSObject class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         complectionBlock(YES);
     } failure:^(NSError *error) {
         complectionBlock(NO);
     }];
    [DMHttpClient sharedInstance].blockSuccessMsg = ^(NSString *msg) {
        [DMTools showSVProgressHudCustom:@"hud_success_icon" title:(STR_IS_NIL(msg)?DMQuestCommitStatusSuccess:msg)];
    };
}

//获取老师评语
+ (void)getTeacherAppraise:(NSString *)lessonId block:(void(^)(BOOL result, DMQuestData *obj))complectionBlock {

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lessonId, @"lesson_id", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Survey_TeacherSurvey_Url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMQuestData class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMQuestData *model = (DMQuestData *)responseObject;
         complectionBlock(YES, model);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil);
     }];
}

//获取百度云上传的配置信息
+ (void)getUploadConfigInfo:(NSString *)lessonId block:(void(^)(BOOL result, DMCloudConfigData *obj))complectionBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lessonId, @"lesson_id", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Cloud_Config_Url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMCloudConfigData class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMCloudConfigData *model = (DMCloudConfigData *)responseObject;
         complectionBlock(YES, model);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil);
     }];
}
//百度云上传成功后的通知
+ (void)getUploadSuccess:(NSString *)lessonId //课节id
              attachment:(NSString *)attachmentID //课件id
                 fileExt:(NSString *)fileExt //文件后缀，比如 .png
                   angle:(NSString *)angle
                   block:(void(^)(BOOL result, DMClassFileDataModel *obj))complectionBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary
                                dictionaryWithObjectsAndKeys:lessonId, @"lesson_id",attachmentID, @"attachment_id",fileExt, @"fileext", angle, @"angle", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_Cloud_Upload_Success_Url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMClassFileDataModel class]
                                   isMustToken:YES
                                       success:^(id responseObject)
     {
         DMClassFileDataModel *model = (DMClassFileDataModel *)responseObject;
         complectionBlock(YES, model);
     } failure:^(NSError *error) {
         complectionBlock(NO, nil);
     }];
}

//声网用户状态记录
+ (void)agoraUserStatusLog:(NSString *)lessonID
                 targetUID:(NSString *)targetUid
                 uploadUID:(NSString *)uploadUID
                    action:(DMAgoraUserStatusLog)action
                     block:(void(^)(BOOL result))complectionBlock
{

    NSString *actionStr = @"";
    switch (action) {
        case DMAgoraUserStatusLog_Enter:
            actionStr = @"enter";
            break;
        case DMAgoraUserStatusLog_Exit:
            actionStr = @"exit";
            break;
        case DMAgoraUserStatusLog_Neterr:
            actionStr = @"neterr";
            break;
        default:
            break;
    }
    NSMutableDictionary *dic = [NSMutableDictionary
                                dictionaryWithObjectsAndKeys:lessonID, @"lesson_id",targetUid, @"target_uid",uploadUID, @"upload_uid", actionStr, @"action", nil];
    [[DMHttpClient sharedInstance] initWithUrlForLog:DM_AgoraUserStatus_Log_Url parameters:dic method:DMHttpRequestPost success:nil failure:nil];

}

@end
















