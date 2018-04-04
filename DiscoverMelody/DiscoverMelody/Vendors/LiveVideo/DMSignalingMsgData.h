//
//  DMSignalingMsgData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSignalingData : NSObject
@property (nonatomic, strong) NSArray *list;
@end

@interface DMSignalingMsgData : NSObject
@property (nonatomic, assign) NSInteger code;//1 同步开始， 2,操作，3,结束同步
@property (nonatomic, strong) DMSignalingData *data;
@property (strong, nonatomic) NSMutableArray *sourceData;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *sendUUID; //  发送一个包接收到2次, 过滤第二次重复添加point

@end
