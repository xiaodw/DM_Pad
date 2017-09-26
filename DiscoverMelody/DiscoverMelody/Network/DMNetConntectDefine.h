//
//  DMNetConntectDefine.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#ifndef DMNetConntectDefine_h
#define DMNetConntectDefine_h

//HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, DMHttpRequestType) {
    DMHttpRequestGet = 0,
    DMHttpRequestPost,
    DMHttpRequestDelete,
    DMHttpRequestPut,
};

typedef NS_ENUM(NSInteger, DMHttpResponseCodeType) {
    DMHttpResponseCodeType_Success              = 0, //api成功
    DMHttpResponseCodeType_Error                = 1, //错误
    DMHttpResponseCodeType_NotLogin             = 2, //未登录，需要到登录界面
    DMHttpResponseCodeType_Failed               = 3, //失败弹框，带图标
};


#endif /* DMNetConntectDefine_h */
