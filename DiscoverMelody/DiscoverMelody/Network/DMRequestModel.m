//
//  DMRequestModel.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMRequestModel.h"

@interface DMRequestModel()
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation DMRequestModel

+ (DMRequestModel *_Nullable)sharedInstance {
    static DMRequestModel *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        //请求参数序列化类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //响应结果序列化类型
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //请求超时时间
        self.manager.requestSerializer.timeoutInterval = 10;
    }
    return self;
}


/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param url        地址
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
                failure:(void (^)( NSError *error))failure {
    //请求的URL
    NSLog(@"Request path:%@",url);
    
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionAvailable]) {
        //预处理（显示加载信息啥的）
        if (prepare) {
            prepare();
        }
        
        switch (method) {
            case DMHttpRequestGet: {
                [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
                
            }
                break;
            case DMHttpRequestPost: {
                
                [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
                
            }
                break;
            case DMHttpRequestDelete: {
                
                [self.manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
                
            }
                break;
            case DMHttpRequestPut: {
                
                [self.manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
                
            }
                break;
            default:
                break;
        }
        
    } else {
        //网络错误咯
        [self showExceptionDialog];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DM_NOTI_NETWORK_ERROR" object:nil];
    }
}

//判断当前网络状态
- (BOOL)isConnectionAvailable {
    return YES;
}

//弹出网络错误提示框
- (void)showExceptionDialog {
    //[DMTools showMessageToast:DMTitleNetworkException duration:2 position:CSToastPositionCenter];
    [DMTools showSVProgressHudCustom:@"" title:DMTitleNetworkError];
}

- (void)cancleAllHttpRequestOperations {
    //取消所有的网络请求
    [self.manager.operationQueue cancelAllOperations];
}

@end
