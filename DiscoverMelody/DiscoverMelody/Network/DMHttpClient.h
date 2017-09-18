//
//  DMHttpClient.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMNetConntectDefine.h"

@interface DMHttpClient : NSObject

+ (DMHttpClient *)sharedInstance;
/**
 *
 *  @param url              地址
 *  @param parameters       请求类型
 *  @param requestMethod    请求参数
 *  @param dataModelClass   返回的数据模型Class
 *  @param mustToken        Token是否必须
 *  @param success          请求成功处理块
 *  @param failure          请求失败处理块
 */
-(void)initWithUrl:(NSString*)url
      parameters:(NSMutableDictionary*)parameters
          method:(DMHttpRequestType)requestMethod
  dataModelClass:(Class)dataModelClass
     isMustToken:(BOOL)mustToken
         success:(void (^)(id responseObject))success
         failure:(void (^)( NSError *error))failure;

//请求合法性校验
-(BOOL)isRequestValid;
- (void)cancleAllHttpRequestOperations;
@end
