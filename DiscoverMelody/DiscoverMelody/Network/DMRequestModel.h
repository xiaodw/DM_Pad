//
//  DMRequestModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DMNetConntectDefine.h"

@interface DMRequestModel : NSObject

/**
 *  请求开始前预处理Block
 */
typedef void(^PrepareExeBlock)(void);

+ (DMRequestModel *)sharedInstance;

/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param url       地址
 *  @param method     请求类型
 *  @param parameters 请求参数
 *  @param prepare    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExeBlock) prepare
                success:(void (^)(id responseObject))success
                failure:(void (^)( NSError *error))failure;

//判断当前网络状态
- (BOOL)isConnectionAvailable;

@end
