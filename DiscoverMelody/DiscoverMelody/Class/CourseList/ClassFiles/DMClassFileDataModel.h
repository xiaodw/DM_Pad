//
//  DMClassFileDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@class DMClassFilesDataModel;
@interface DMClassFileDataModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *img_thumb;

@property (assign, nonatomic) NSInteger isSelected;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@interface DMClassFilesDataModel : DMBaseDataModel
@property (nonatomic, strong) NSArray *teacher_list;
@property (nonatomic, strong) NSArray *student_list;
@end
