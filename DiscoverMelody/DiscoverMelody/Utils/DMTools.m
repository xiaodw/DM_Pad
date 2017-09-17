//
//  DMTools.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMTools.h"

@implementation DMTools
    
+ (BOOL)isHaveFont:(NSString *)postScriptName{
    UIFont *font = [UIFont fontWithName:postScriptName size:12.0];
    if (font && ([font.fontName compare:postScriptName] == NSOrderedSame || [font.familyName compare:postScriptName] == NSOrderedSame)) {
        return YES;
    }
    return NO;
}
/*
 * 时间戳 转 时间
 */
+ (NSString *)timeFormatterYMDFromTs:(NSString *)ts format:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];
    NSInteger l = [ts integerValue];
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:l];
    NSString *timeStr = [formatter stringFromDate:nowTime];
    return timeStr;
}
/**
 * 秒 转 分钟
 */
+ (NSString *)secondsConvertMinutes:(NSString *)seconds {
    NSString *minutesNumber = [NSString stringWithFormat:@"%lld", [seconds longLongValue]/60];
    return minutesNumber;
}
/**
 * 根据时长，计算时间段
 */
+ (NSString *)computationsPeriodOfTime:(NSString *)startTime duration:(NSString *)duration {
    
    NSString *endTime = [NSString stringWithFormat:@"%lld",startTime.longLongValue + duration.longLongValue];
    NSString *start = [DMTools timeFormatterYMDFromTs:startTime format:@"HH:mm"];
    NSString *end = [DMTools timeFormatterYMDFromTs:endTime format:@"HH:mm"];
    return [[start stringByAppendingString:@"-"] stringByAppendingString:end];
}
/**
 * 摄像头，麦克风权限授权
 */
+ (void)requestAccessForMediaVideoAndAudio {
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        NSString *mediaType = AVMediaTypeVideo;
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted) {
                // 用户同意获取摄像头
                NSLog(@"%@",@"用户同意获取摄像头");
                
            } else {
                NSLog(@"%@",@"用户不同意获取摄像头");
            }
        }];
    }
    AVAuthorizationStatus authStatusAudio =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatusAudio == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                // 用户同意获取麦克风
            } else {
                // 用户不同意获取麦克风
            }
            
        }];
    }
}

@end
