//
//  DMTools.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTools : NSObject
/*
 * 是否包含某个字体
 */
+ (BOOL)isHaveFont:(NSString *)postScriptName;

/**
 * 获取当前时间戳
 */
+ (NSString *)getCurrentTimestamp;
/*
 * 时间戳 转 时间
 */
+ (NSString *)timeFormatterYMDFromTs:(NSString *)ts format:(NSString *)formatStr;
/**
 * 秒 转 分钟
 */
+ (NSString *)secondsConvertMinutes:(NSString *)seconds;
/**
 * 根据时长，计算时间段
 */
+ (NSString *)computationsPeriodOfTime:(NSString *)startTime duration:(NSString *)duration;
/**
 * 摄像头，麦克风权限授权
 */
+ (void)requestAccessForMediaVideoAndAudio;

@end
