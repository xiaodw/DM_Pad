//
//  DMAnswerData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"
@interface DMAnswerSingleData : NSObject
@property (nonatomic, copy) NSString *lesson_id;
@property (nonatomic, copy) NSString *answer_id;
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *content;
@end
@interface DMAnswerData : DMBaseDataModel

@end
