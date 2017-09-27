//
//  DMEnums.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/17.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

typedef NS_ENUM(NSInteger, DMCourseListCondition) {
    DMCourseListCondition_All = -1, // 全部课程
    DMCourseListCondition_Finish = 0, // 已上课程
    DMCourseListCondition_WillStart = 2, // 未上课程
};

typedef NS_ENUM(NSInteger, DMSignalingCodeType) {
    DMSignalingCode_Start_Syn     = 1, // 开始同步
    DMSignalingCode_Turn_Page    = 2, // 同步翻页
    DMSignalingCode_End_Syn     = 3, // 同步结束
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
