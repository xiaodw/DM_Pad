//
//  DMCustomerDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseDataModel.h"

@interface DMCustomerTeacherInfo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *webchat;
@property (nonatomic, copy) NSString *img_url;
@end

@interface DMCustomerTel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@end

@interface DMCustomerTeacher : NSObject
@property (nonatomic, copy) NSString *customer_region;
@property (nonatomic, strong) NSArray *customer_list;
@property (nonatomic, assign) BOOL auto_open;

//@property (nonatomic, assign) BOOL isFurled;

@end

@interface DMCustomerDataModel : DMBaseDataModel
@property (nonatomic, strong) NSArray *tel;
@property (nonatomic, strong) NSArray *customer;
@end
