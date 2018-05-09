//
//  DMServerApiConfig.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMConfigManager.h"

#ifndef DMServerApiConfig_h
#define DMServerApiConfig_h

#define App_Version [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]


/*******************************************打包需要配置的信息***************************************************/

/**     发布打包步骤
 *  1，检查修改服务器环境配置
 *  2，检查修改语言环境配置
 *  3，检查修改对应的APP_NAME_Type
 *  4，检查修改LaunchScreen对应的版本
 *  5，检查修改发布版本号
 *  6，检查对应的bundleID。
 *  7，检查相关证书
 *  8，检查InfoPlist.strings对应的名称
 *  9，检查InfoPlist中权限的中英文名称：
 中文：为了您可以正常视频上课，请开启摄像头权限
     为了您可以正常视频上课，请开启麦克风权限
     “寻律”需要访问您的相册
 英文：
 【It is for the success of a DM course. Your camera will be used during the video course】
 【It is for the success of a DM course. Your microphone will be used during the video course】
 【Discover Melody would like to access your photos】
 */

//#define App_Type @"cn_s" // @"cn_s"  @"cn_t" @"us_s"  @"us_t"

//服务器环境配置:  1开发，2测试，0正式， 默认为0
#define SERVER_ENVIRONMENT   0

//语言环境: 0 中文， 1 英文
#define LANGUAGE_ENVIRONMENT 0

//0 学生中文， 1 学生英文， 2 老师英文    -1, 开发测试使用
#define APP_NAME_TYPE  0

#if APP_NAME_TYPE == 0 //中文
    #define App_Type @"cn_s"
#elif APP_NAME_TYPE == 1 //英文
    #define App_Type @"us_s"
#elif APP_NAME_TYPE == 2 //英文
    #define App_Type @"us_t"
#elif APP_NAME_TYPE == -1
    #define App_Type @"cn_s"
#endif

/**************************************************************************************************************/


//：api.cn.discovermelody-app.com
//学生/老师英文：api.us.discovermelody-app.com

#if SERVER_ENVIRONMENT == 0 //正式

    #if LANGUAGE_ENVIRONMENT == 0 //中文
        #define DM_Local_Url @"http://api.cn.discovermelody-app.com/"//服务器访问地址
    #elif LANGUAGE_ENVIRONMENT == 1

        #if APP_NAME_TYPE == 1 //英文学生
            #define DM_Local_Url @"http://api.uss.discovermelody-app.com/"
        #elif APP_NAME_TYPE == 2 //英文老师
            #define DM_Local_Url @"http://api.us.discovermelody-app.com/"//
        #endif

    #endif

    //#define DM_Local_Url                    @"http://api.cn.discovermelody-app.com/"//服务器访问地址 //@"http://test.api.cn.discovermelody.com/"
    #define DMLog_Local_Url                 @"http://log.cn.discovermelody.com/"//统计服务器访问地址
    #define DMAgoraAppID_Local_Config       @"2f4301adc17b415c98eba18b7f1066d4"//声网appID
    #define DMAgoraVideoProfile_Config      @"55"// 声网视频属性枚举值
    #define DMImage_Size_Config             2*1024*1024 // 图片大小界限，2兆
    #define DMUpload_Max_Count_Config       20 //上传图片张数限制

#elif SERVER_ENVIRONMENT == 1 //开发

    #define DM_Local_Url                    @"http://test.api.cn.discovermelody-app.com/" //服务器访问地址
    #define DMLog_Local_Url                 @"http://log.cn.discovermelody.com/"//统计服务器访问地址
    #define DMAgoraAppID_Local_Config       @"2f4301adc17b415c98eba18b7f1066d4"//声网appID
    #define DMAgoraVideoProfile_Config      @"55"// 声网视频属性枚举值
    #define DMImage_Size_Config             2*1024*1024 // 图片大小界限，2兆
    #define DMUpload_Max_Count_Config       20 //上传图片张数限制

#elif SERVER_ENVIRONMENT == 2 //测试

    #define DM_Local_Url                    @"http://test.api.cn.discovermelody-app.com/" //服务器访问地址
    #define DMLog_Local_Url                 @"http://log.cn.discovermelody.com/"//统计服务器访问地址
    #define DMAgoraAppID_Local_Config       @"f8101ce899cc4da8807b3eb81bed86e3"//声网appID
    #define DMAgoraVideoProfile_Config      @"55"// 声网视频属性枚举值
    #define DMImage_Size_Config             2*1024*1024 // 图片大小界限，2兆
    #define DMUpload_Max_Count_Config       20 //上传图片张数限制

#endif


#define DMLog_Url   [DMConfigManager shareInstance].logHost
#define DM_Url      DM_Local_Url //[DMConfigManager shareInstance].apiHost

//配置
#define DM_Init_SetConfig_Url           [DM_Url stringByAppendingFormat:@"Init/getConfig"]

//登录
#define DM_User_Loing_Url               [DM_Url stringByAppendingFormat:@"User/login"]
//退出登录
#define DM_User_Logout_Url              [DM_Url stringByAppendingFormat:@"User/logout"]
//检测登录
#define DM_User_Check_Login_Url         [DM_Url stringByAppendingFormat:@"UserCenter/checkLogin"]
//老师课程列表
#define DM_User_Tcourse_List_Url        [DM_Url stringByAppendingFormat:@"Lesson/tcourseList"]
//个人课程列表
#define DM_User_Scourse_List_Url        [DM_Url stringByAppendingFormat:@"Lesson/scourseList"]

//个人主页学生
#define DM_User_Scourse_Index_Url       [DM_Url stringByAppendingFormat:@"Lesson/scourseIndex"]
//个人主页老师
#define DM_User_Tcourse_Index_Url       [DM_Url stringByAppendingFormat:@"Lesson/tcourseIndex"]

//学生进入课堂
#define DM_Student_Access_Url           [DM_Url stringByAppendingFormat:@"Lesson/studentAccess"]
//老师进入课堂
#define DM_Teacher_Access_Url           [DM_Url stringByAppendingFormat:@"Lesson/teacherAccess"]

//获取课件列表
#define DM_Attachment_FileList_Url      [DM_Url stringByAppendingFormat:@"Attachment/getList"]
//课件上传
#define DM_User_Attachment_Upload_Url   [DM_Url stringByAppendingFormat:@"Attachment/upload"]
//删除课件
#define DM_Attachment_fileMove_Url      [DM_Url stringByAppendingFormat:@"Attachment/move"]

//客服
#define DM_Customer_Url                 [DM_Url stringByAppendingFormat:@"Customer/index"]

//点播视频
#define DM_Video_Replay_Url             [DM_Url stringByAppendingFormat:@"Lesson/replay"]

//获取问题列表学生
#define DM_Student_Question_List_Url    [DM_Url stringByAppendingFormat:@"Survey/squestionList"]
//获取问题列表老师
#define DM_Teacher_Question_List_Url    [DM_Url stringByAppendingFormat:@"Survey/tquestionList"]
//提交答案学生
#define DM_Submit_Student_Answer_Url    [DM_Url stringByAppendingFormat:@"Survey/submitStudent"]
//提交答案老师
#define DM_Submit_Teacher_Answer_Url    [DM_Url stringByAppendingFormat:@"Survey/submitTeacher"]
//获取老师评语
#define DM_Survey_TeacherSurvey_Url     [DM_Url stringByAppendingFormat:@"Survey/teacherSurvey"]

//获取百度云配置信息
#define DM_Cloud_Config_Url             [DM_Url stringByAppendingFormat:@"Attachment/getUploadConf"]
//百度云上传成功后的通知
#define DM_Cloud_Upload_Success_Url     [DM_Url stringByAppendingFormat:@"Attachment/uploadSuccess"]

//声网用户状态
#define DM_AgoraUserStatus_Log_Url      [DM_Url stringByAppendingFormat:@"Log/agoraLog"]


#endif /* DMServerApiConfig_h */




