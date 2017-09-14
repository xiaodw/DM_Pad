//
//  DMHomeDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMHomeDataModel : DMBaseDataModel
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *page_next;
@end
