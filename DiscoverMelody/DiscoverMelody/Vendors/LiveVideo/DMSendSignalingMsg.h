//
//  DMSendSignalingMsg.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSendSignalingMsg : NSObject

+ (NSString *)getSignalingStruct:(DMSignalingCodeType)code sourceData:(NSMutableArray *)sourceData;

+ (NSString *)getSignalingStruct:(DMSignalingCodeType)code sourceData:(NSMutableArray *)sourceData index:(NSInteger)index;
@end
