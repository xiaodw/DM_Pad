//
//  DMBaseDataModel.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMBaseDataModel : NSObject
//@property (nonatomic, copy) NSString *msg;
//@property (nonatomic, assign) NSInteger code;
//@property (nonatomic, copy) NSString *time;
//@property (nonatomic, strong) NSMutableDictionary *data;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (assign, nonatomic) int age;
@property (assign, nonatomic) double height;
@property (strong, nonatomic) NSNumber *money;
@end
