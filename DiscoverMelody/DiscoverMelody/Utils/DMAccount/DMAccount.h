//
//  DMAccount.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMLoginDataModel.h"
@interface DMAccount : NSObject

//读取最后一次登录成功的账号
+ (NSString *)getLatestLoginAccount;

//读取账号信息
+ (id)getAccountInfo;

//读取token信息
+ (NSString *)getToken;

//读取用户姓名
+ (NSString *)getUserName;

//读取用户身份
+ (NSString *)getUserIdentity;

//读取用户头像
+ (NSString *)getUserHeadUrl;

//读取uid
+ (NSString *)getUserID;

//保存最新的登录账号
+ (void)saveLatestLoginAccount:(NSString *)account;

//保存账号信息
+ (void)saveAccountInfo:(DMLoginDataModel *)obj;

//保存token信息
+ (void)saveToken:(NSString *)token;

//保存用户姓名
+ (void)saveUserName:(NSString *)name;

//保存用户身份
+ (void)saveUserIdentity:(NSString *)identity;

//保存用户头像
+ (void)saveUserHeadUrl:(NSString *)headUrl;

//保存用户uid
+ (void)saveUserID:(NSString *)uID;

//清除用户所有信息
+ (void)removeUserAllInfo;

//用户进入课堂的访问时间
+ (void)saveUserJoinClassTime:(NSString *)time;
+ (NSString *)getUserJoinClassTime;

@end
