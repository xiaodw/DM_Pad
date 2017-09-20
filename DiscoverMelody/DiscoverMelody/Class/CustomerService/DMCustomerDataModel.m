//
//  DMCustomerDataModel.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCustomerDataModel.h"

@implementation DMCustomerTeacherInfo

@end

@implementation DMCustomerTel

@end

@implementation DMCustomerTeacher
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"customer_list" : @"DMCustomerTeacherInfo"
             };
}
@end

@implementation DMCustomerDataModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"tel" : @"DMCustomerTel",
             @"customer" : @"DMCustomerTeacher"
             };
}
@end
