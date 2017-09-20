//
//  DMQuestData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMQuestSingleData : NSObject
@property (nonatomic, copy) NSString *question_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@end

@interface DMQuestData : DMBaseDataModel
@property (nonatomic ,strong) NSArray *list;
@end
