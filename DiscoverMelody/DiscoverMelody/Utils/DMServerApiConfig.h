//
//  DMServerApiConfig.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#ifndef DMServerApiConfig_h
#define DMServerApiConfig_h


//ENVIRONMENT  0开发，1测试，2正式， 默认为0
#define ENVIRONMENT   [[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]] objectForKey:@"DMSeverCodeKey"] intValue]

#define DM_Url    (ENVIRONMENT == 0) ? \
@"http://test.api.cn.discovermelody.com/" : ((ENVIRONMENT == 1) ? \
@"http://test.api.cn.discovermelody.com/" : ( (ENVIRONMENT == 2) ? \
@"http://api.cn.discovermelody.com/" : \
@"http://api.cn.discovermelody.com/"))

#define App_Version [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]
#define App_Type @"iPad"

//登录
#define DM_User_Loing_Url               [DM_Url stringByAppendingFormat:@"user/login"]

//退出登录
#define DM_User_Logout_Url              [DM_Url stringByAppendingFormat:@"user/logout"]

//老师课程列表
#define DM_User_Tcourse_List_Url         [DM_Url stringByAppendingFormat:@"lesson/tcourseList"]

//个人课程列表
#define DM_User_Scourse_List_Url         [DM_Url stringByAppendingFormat:@"lesson/scourseList"]

//个人主页学生
#define DM_User_Scourse_Index_Url         [DM_Url stringByAppendingFormat:@"lesson/scourseIndex"]

//个人主页老师
#define DM_User_Tcourse_Index_Url         [DM_Url stringByAppendingFormat:@"lesson/tcourseIndex"]

//本课课件列表
#define DM_User_Attachment_List_Url     [DM_Url stringByAppendingFormat:@"attachment/list"]

//课件上传
#define DM_User_Attachment_Upload_Url   [DM_Url stringByAppendingFormat:@"attachment/upload"]

//删除课件
#define DM_User_Attachment_Del_Url      [DM_Url stringByAppendingFormat:@"attachment/del"]


#endif /* DMServerApiConfig_h */
