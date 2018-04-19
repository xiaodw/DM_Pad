//
//  DMSendSignalingMsg.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSendSignalingMsg : NSObject

// 同步课件
+ (NSString *)getSignalingStruct:(DMSignalingCodeType)code sourceData:(NSArray *)sourceData synType:(DMSignalingMsgType)type;

// 同步白板
+ (NSString *)getSignalingStruct:(DMSignalingCodeType)code sourceData:(NSArray *)sourceData index:(NSInteger)index size:(CGSize)size lineWidth:(CGFloat)width lineColor:(NSString *)color pathUID:(NSString *)pathUID synType:(DMSignalingMsgType)type;

@end
