//
//  DMAccount.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMAccount.h"

@implementation DMAccount

#define U_NAME @"name"
#define U_TYPE @"user_type"
#define U_AVATAR @"avatar"
#define U_TOKEN @"token"

#define U_C_TIME @"ctime"

//读取账号信息
+ (id)getAccountInfo {

    return nil;
}

//读取token信息
+ (NSString *)getToken {

    return [DMUserDefaults getValueWithKey:U_TOKEN];
}

//读取用户姓名
+ (NSString *)getUserName {
    return [DMUserDefaults getValueWithKey:U_NAME];
}

//读取用户身份
+ (NSString *)getUserIdentity {
    return [DMUserDefaults getValueWithKey:U_TYPE];
}

//读取用户头像
+ (NSString *)getUserHeadUrl {
    return [DMUserDefaults getValueWithKey:U_AVATAR];
}

//保存账号信息
+ (void)saveAccountInfo:(DMLoginDataModel *)obj {
    if (OBJ_IS_NIL(obj)) {
        return;
    }
    [DMAccount saveToken:obj.token];
    [DMAccount saveUserName:obj.name];
    [DMAccount saveUserHeadUrl:obj.avatar];
    [DMAccount saveUserIdentity:obj.user_type];
}

//保存token信息
+ (void)saveToken:(NSString *)token {
    [DMUserDefaults setValue:token forKey:U_TOKEN];
}

//保存用户姓名
+ (void)saveUserName:(NSString *)name {
    [DMUserDefaults setValue:name forKey:U_NAME];
}

//保存用户身份
+ (void)saveUserIdentity:(NSString *)identity {
    [DMUserDefaults setValue:identity forKey:U_TYPE];
}

//保存用户头像
+ (void)saveUserHeadUrl:(NSString *)headUrl {
    [DMUserDefaults setValue:headUrl forKey:U_AVATAR];
}

//清除用户所有信息
+ (void)removeUserAllInfo {
    [DMAccount saveToken:@""];
    [DMAccount saveUserName:@""];
    [DMAccount saveUserHeadUrl:@""];
    [DMAccount saveUserIdentity:@""];
    [DMAccount saveUserJoinClassTime:@""];
}

+ (void)saveUserJoinClassTime:(NSString *)time {
    [DMUserDefaults setValue:time forKey:U_C_TIME];
}
+ (NSString *)getUserJoinClassTime {
    return [DMUserDefaults getValueWithKey:U_C_TIME];
}
@end
