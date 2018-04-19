//
//  DMEnums.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/17.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

typedef NS_ENUM(NSInteger, DMCourseListCondition) {
    DMCourseListCondition_All       = 1, // 全部课程
    DMCourseListCondition_Finish    = 2, // 已上课程
    DMCourseListCondition_WillStart = 3, // 未上课程
};

typedef NS_ENUM(NSInteger, DMSignalingMsgType) {
    DMSignalingMsgSynCourse            = 1, // 课件同步
    DMSignalingMsgSynWhiteBoard        = 2  // 白板同步
};

// 课件
typedef NS_ENUM(NSInteger, DMSignalingCodeType) {
    DMSignalingCode_Start_Syn       = 1, // 开始同步
    DMSignalingCode_Turn_Page       = 2, // 同步翻页
    DMSignalingCode_End_Syn         = 3, // 同步结束
};

// 白板
typedef NS_ENUM(NSInteger, DMSignalingWhiteBoardCodeType) {
    DMSignalingWhiteBoardCodeBrush       = 1, // 同步笔触点
    DMSignalingWhiteBoardCodeClean       = 2, // 同步清除
    DMSignalingWhiteBoardCodeUndo        = 3, // 同步回退
    DMSignalingWhiteBoardCodeForward     = 4, // 同步前进
    DMSignalingWhiteBoardCodeClose       = 5  // 同步取消
};

//上传图片的
typedef NS_ENUM(NSInteger, DMFormatUploadFileType) {
    DMFormatUploadFileType_FileData = 0, //默认文件数据流
    DMFormatUploadFileType_FilePath = 1, //文件路径
};


//声网用户状态记录
typedef NS_ENUM(NSInteger, DMAgoraUserStatusLog) {
    DMAgoraUserStatusLog_Enter = 0, //进入
    DMAgoraUserStatusLog_Exit,      //退出
    DMAgoraUserStatusLog_Neterr,    //网络关闭
};

//推送消息类型
typedef NS_ENUM(NSInteger, DMPushMessageType) {
    DMPushMessageType_Nor           = 1,         //纯文字消息
    DMPushMessageType_Web           = 2,         //web消息
    DMPushMessageType_Nav           = 3,         //nav消息
    DMPushMessageType_CheckLogin    = 4,         //验证登录
};
