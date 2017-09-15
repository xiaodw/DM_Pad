//
//  DMLoginDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMLoginDataModel : DMBaseDataModel
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *user_type;//0学生，1老师
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *token;
@end
