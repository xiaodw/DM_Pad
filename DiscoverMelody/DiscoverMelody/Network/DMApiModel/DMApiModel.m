//
//  DMApiModel.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMApiModel.h"
#import "DMLoginDataModel.h"

@implementation DMApiModel

//登录
+ (void)loginSystem:(NSString *)account psd:(NSString *)password block:(void(^)(BOOL result))complectionBlock {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:account, @"account", password, @"password", nil];
    [[DMHttpClient sharedInstance] initWithUrl:DM_User_Loing_Url parameters:dic method:DMHttpRequestPost dataModelClass:[DMLoginDataModel class] isMustToken:NO success:^(id responseObject) {
        if (!OBJ_IS_NIL(responseObject)) {
            //保存数据
            DMLoginDataModel *model = (DMLoginDataModel *)responseObject;
            [DMAccount saveAccountInfo:model];
            complectionBlock(YES);
        }
    } failure:^(NSError *error) {
        complectionBlock (NO);
    }];
}

//退出登录
+ (void)logoutSystem:(void(^)(BOOL result))complectionBlock {
    [[DMHttpClient sharedInstance] initWithUrl:DM_User_Logout_Url parameters:nil method:DMHttpRequestPost dataModelClass:[NSObject class] isMustToken:YES success:^(id responseObject) {
        //清除用户数据
        [DMAccount removeUserAllInfo];
        complectionBlock(YES);
    } failure:^(NSError *error) {
        complectionBlock(NO);
    }];
}

//首页数据
+ (void)getHomeCourseData:(NSString *)type block:(void(^)(BOOL result, NSArray *array))complectionBlock {
    
    NSString *url = DM_User_Scourse_Index_Url;
    if (type.intValue == 1) {
        url = DM_User_Tcourse_Index_Url;
    }
    
    [[DMHttpClient sharedInstance] initWithUrl:url parameters:nil method:DMHttpRequestPost dataModelClass:[DMHomeDataModel class] isMustToken:YES success:^(id responseObject) {
        DMHomeDataModel *model = (DMHomeDataModel *)responseObject;
        complectionBlock(YES, model.list);
    } failure:^(NSError *error) {
        complectionBlock(NO, nil);
    }];
    
}

//课程列表(老师／学生)
+ (void)getCourseListData:(NSString *)type //身份类型
                     sort:(NSString *)sort //DESC降序，ASC升序
                     page:(NSString *)page //页码，默认为1
                condition:(NSString *)condition //选择筛选条件
                    block:(void(^)(BOOL result, NSArray *array, BOOL nextPage))complectionBlock
{

    NSString *url = DM_User_Scourse_List_Url;
    if (type.intValue == 1) {
        url = DM_User_Tcourse_List_Url;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:condition, @"condition", page, @"page", sort, @"sort", nil];
    
    [[DMHttpClient sharedInstance] initWithUrl:url
                                    parameters:dic
                                        method:DMHttpRequestPost
                                dataModelClass:[DMHomeDataModel class]
                                   isMustToken:YES
                                       success:^(id responseObject)
    {
        DMHomeDataModel *model = (DMHomeDataModel *)responseObject;
        BOOL isHave = YES;
        if (model.page_next.intValue == 0) {
            isHave = NO;
        }
        complectionBlock(YES, model.list, isHave);
    } failure:^(NSError *error) {
        complectionBlock(NO, nil, NO);
    }];
}

@end






