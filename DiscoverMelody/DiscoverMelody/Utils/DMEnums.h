//
//  DMEnums.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/17.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

typedef NS_ENUM(NSInteger, DMCourseListCondition) {
    DMCourseListCondition_All = -1, // 全部课程
    DMCourseListCondition_Finish = 0, // 已上课程
    DMCourseListCondition_WillStart = 2, // 未上课程
};
