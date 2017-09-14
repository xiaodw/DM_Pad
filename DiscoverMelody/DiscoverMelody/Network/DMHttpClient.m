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
        id responseDataModel = [dataModelClass mj_objectWithKeyValues:[responseObj objectForKey:Data_Key]];
        success(responseDataModel);
    
    } failure:^(NSError *error) {
        NSLog(@"网络请求错误信息 = %@", error);
        failure(error);
    }];
}

- (NSMutableDictionary *)fixedParameters:(NSMutableDictionary *)source {
    [source setObject:App_Version forKey:@"ver"];
    [source setObject:App_Type forKey:@"app"];
    [source setObject:STR_IS_NIL([DMAccount getToken]) ? @"": [DMAccount getToken] forKey:@"token"];
    return source;
}

//请求合法性校验
-(BOOL)isRequestValid {
    return YES;
}

@end
