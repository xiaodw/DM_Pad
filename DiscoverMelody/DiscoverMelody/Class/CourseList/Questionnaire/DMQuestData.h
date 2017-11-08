//
//  DMQuestData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@class DMQuestSingleData;

@interface DMQuestOptions : NSObject
@property (nonatomic, copy) NSString *option_id;
@property (nonatomic, copy) NSString *option_content;
@end

@interface DMQuestSingleData : NSObject
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type; //0, 问答题，1，选择／判断题 ，2，打分题
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, copy) NSString *answer_content;//

@property (nonatomic, copy) NSString *content;//答案 本地使用,记录答案
@property (nonatomic, assign) NSInteger isSelectedIndex;

@end

@interface DMQuestData : DMBaseDataModel
@property (nonatomic ,strong) NSArray *list;
@property (nonatomic, copy) NSString *survey; //0 未回答，1 已回答 ---学生。  0-未回答，1-已回答未审核，2-审核通过，3-审核不通过 ---老师

@property (nonatomic, copy) NSString *teacher_name;
@property (nonatomic, copy) NSString *student_name;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *course_name;

@end
