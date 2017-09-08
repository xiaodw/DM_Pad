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

    [[DMRequestModel sharedInstance] requestWithPath:url method:requestMethod parameters:parameters prepareExecute:^{
        
    } success:^(id responseObject) {

        NSLog(@"%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) return;
        id responseDataModel = [dataModelClass mj_objectWithKeyValues:responseObject];
        success(responseDataModel);
    
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//请求合法性校验
-(BOOL)isRequestValid {
    return YES;
}

@end
