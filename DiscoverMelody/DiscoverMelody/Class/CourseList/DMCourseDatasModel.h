//
//  DMCourseDatasModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMCourseDatasModel : DMBaseDataModel
@property (nonatomic, copy) NSString *course_id;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSString *teacher_name;//0学生，1老师
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *start_time;//课程开始时间 秒
@property (nonatomic, copy) NSString *duration;//课程时长 秒
@property (nonatomic, copy) NSString *live_status;//0-未开始，1-上课中，2-上完课，3-取消课程，4结束
@property (nonatomic, copy) NSString *survey;//0-未上课未点评，1-已上课未点评，2-已上课点评过
@end
