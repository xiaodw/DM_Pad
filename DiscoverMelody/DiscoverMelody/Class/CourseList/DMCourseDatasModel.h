//
//  DMCourseDatasModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMCourseDatasModel : DMBaseDataModel
@property (nonatomic, copy) NSString *lesson_id;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSString *teacher_name;//老师姓名
@property (nonatomic, copy) NSString *student_name;//学生姓名
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *start_time;//课程开始时间 秒
@property (nonatomic, copy) NSString *duration;//课程时长 秒
@property (nonatomic, copy) NSString *live_status;//0-未开始，1-上课中，2-课程结束，3-取消课程
@property (nonatomic, copy) NSString *survey;//0 不可点，1，2 可点
@property (nonatomic, copy) NSString *video_id;//课程回顾的id
@end
