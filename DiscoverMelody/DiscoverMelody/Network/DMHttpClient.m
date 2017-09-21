//
//  DMHttpClient.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMHttpClient.h"
#import "DMRequestModel.h"
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation DMHttpClient

#define Data_Key @"data"
#define Code_Key @"code"
#define Msg_Key @"msg"
#define Token_Key @"token"
#define Time_Key @"time"

+ (DMHttpClient *)sharedInstance {
    static DMHttpClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)initWithUrl:(NSString*)url
      parameters:(NSMutableDictionary*)parameters
          method:(DMHttpRequestType)requestMethod
  dataModelClass:(Class)dataModelClass
     isMustToken:(BOOL)mustToken
         success:(void (^)(id responseObject))success
         failure:(void (^)( NSError *error))failure {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (OBJ_IS_NIL(parameters)) {
        dic = [self fixedParameters:[NSMutableDictionary dictionary]];
    } else {
        dic = [self fixedParameters:parameters];
    }
    
    [[DMRequestModel sharedInstance] requestWithPath:url method:requestMethod parameters:dic prepareExecute:^{
        
    } success:^(id responseObject) {
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"str = %@",string);
        id responseObj = responseObject;
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            responseObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        NSLog(@"返回的数据 = %@",responseObj);
        
        if (!STR_IS_NIL([responseObj objectForKey:Token_Key])) {
            [self updateTokenToLatest:[responseObj objectForKey:Token_Key]];
        }
        
        if ([[responseObj objectForKey:@"code"] intValue] == 0) {
            //进入课堂接口，单独取出访问时间
            if (dataModelClass == [DMClassDataModel class]) {
                [DMAccount saveUserJoinClassTime:[responseObj objectForKey:Time_Key]];
            }
            
            if (self.blockSuccessMsg) {
                self.blockSuccessMsg([responseObj objectForKey:Msg_Key]);
                self.blockSuccessMsg = nil;
            }
            
            id responseDataModel = [dataModelClass mj_objectWithKeyValues:[responseObj objectForKey:Data_Key]];
            success(responseDataModel);
            
            
        } else {
            [self responseStatusCodeException:[[responseObj objectForKey:Code_Key] intValue]
                                          msg:[responseObj objectForKey:Msg_Key]];
            failure(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"网络请求错误信息 = %@", error);
        [DMTools showMessageToast:DMTitleNetworkError duration:2 position:CSToastPositionCenter];
        failure(error);
    }];
}

-(void)didSuccessMsg:(BlockSuccessMsg)blockSuccessMsg {
    self.blockSuccessMsg = blockSuccessMsg;
}

- (NSMutableDictionary *)fixedParameters:(NSMutableDictionary *)source {
    [source setObject:App_Version forKey:@"ver"];
    [source setObject:App_Type forKey:@"app"];
    [source setObject:STR_IS_NIL([DMAccount getToken]) ? @"": [DMAccount getToken] forKey:@"token"];
    return source;
}

- (void)responseStatusCodeException:(NSInteger)code msg:(NSString *)message {
    switch (code) {
        case DMHttpResponseCodeType_NotLogin: //未登录，需要重新登录
            //to-do 1，取消所有网络请求，2，清除用户所有信息，3，退到登录界面
            [DMCommonModel removeUserAllDataAndOperation];
            [APP_DELEGATE toggleRootView:YES];
            break;
        case DMHttpResponseCodeType_RefusedToEnter:
            //[SVProgressHUD showWithStatus:message];
            [DMTools showMessageToast:message duration:2 position:CSToastPositionCenter];
            break;
        default:
            [DMTools showMessageToast:message duration:2 position:CSToastPositionCenter];
            break;
    }
}

- (void)cancleAllHttpRequestOperations {
    [[DMRequestModel sharedInstance] cancleAllHttpRequestOperations];
}

- (void)updateTokenToLatest:(NSString *)token {
    [DMCommonModel updateFailureToken:token];
}

//请求合法性校验
-(BOOL)isRequestValid {
    return YES;
}

@end
