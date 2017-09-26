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
/**
 * 获取当前时间戳
 */
+ (NSString *)getCurrentTimestamp {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", interval];
    return timeString;
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
 * 计算距离上课时间差,提前为负，迟到为正
 */
+ (NSTimeInterval)computationsClassTimeDifference:(NSString *)startTime accessTime:(NSString *)accessTime; {
    NSTimeInterval interval = accessTime.longLongValue - startTime.longLongValue;
    return interval;
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

/**
 * 自定义SVProgressHUD提示框
 */
+ (void)showMessageToast:(NSString *)msg duration:(NSTimeInterval)duration position:(id)style {
    [APP_DELEGATE.window makeToast:msg duration:duration position:style];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, alpha);
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        
        return img;
        
    }
}

//进行图片压缩
+ (NSData *)compressedImageForUpload:(UIImage *)sourceImage {
    if (sourceImage == nil) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(sourceImage);
    if (imageData == nil) {
        imageData = UIImageJPEGRepresentation(sourceImage, 1);
        if (imageData == nil) {
            return nil;
        }
    }

    return [DMTools compressedImageDataForUpload:imageData];
}

+ (NSData *)compressedImageDataForUpload:(NSData *)sourceData {
    if (sourceData == nil) {
        return nil;
    }
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"currentCompressedImage.jpg"];
    NSData *resultData = sourceData;
    NSString *type = [DMTools typeForImageData:sourceData];
    if ([type isEqualToString:@"image/png"]) {
        UIImage *image = [UIImage imageWithData: sourceData];
        [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath atomically:YES];
        UIImage *imgFromDoc = [[UIImage alloc] initWithContentsOfFile:imageFilePath];
        NSData *imageData = UIImageJPEGRepresentation(imgFromDoc, 1);
        [fileManager removeItemAtPath:imageFilePath error:nil];
        resultData = imageData;
    }
    NSInteger sourceVolume = (unsigned long)resultData.length/1024;
    NSInteger boundariesValue = [[DMConfigManager shareInstance].uploadMaxSize integerValue]/1024;
    NSLog(@"Size of Image(bytes-->KB):%lu",sourceVolume);
    if (sourceVolume > boundariesValue) {
        CGFloat ss = (CGFloat)boundariesValue/sourceVolume;
        if (ss < 1.0) {
            UIImage *imageResult = [UIImage imageWithData: resultData];
            NSData *lastedData = UIImageJPEGRepresentation(imageResult, ((ss < 0.1) ? 0.1: ss));
            [lastedData writeToFile:imageFilePath atomically:YES];
            return lastedData;
        }
    }
    return resultData;
}

+ (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return @"";
}

//计算文字高度
+(CGFloat)getContactHeight:(NSString*)contact font:(UIFont *)font width:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    // 计算文字占据的高度
    CGSize size = [contact boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attrs
                                        context:nil].size;
    
    
    return size.height;
    
}

//计算文字宽度
+(CGFloat)getContactWidth:(NSString*)contact font:(UIFont *)font height:(CGFloat)height {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    // 计算文字占据的高度
    CGSize size = [contact boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attrs
                                        context:nil].size;
    
    
    return size.width;
    
}

//成功提示框
+(void)showSVProgressHudCustom:(NSString *)imageName title:(NSString *)title {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [SVProgressHUD setForegroundColor:DMColorWithRGBA(254, 254, 254, 1)]; //字体颜色
    [SVProgressHUD setBackgroundColor:DMColorWithRGBA(0, 0, 0, 0.6)];//背景颜色
    [SVProgressHUD setCornerRadius:5];
    
    if (!STR_IS_NIL(imageName)) {

        [SVProgressHUD setMinimumSize:CGSizeMake(130, 130)];
        [SVProgressHUD setFont:DMFontPingFang_Regular(16)];
        [SVProgressHUD setImageViewSize:CGSizeMake(62, 62)];
    
    } else {
        
        NSInteger w = [DMTools getContactWidth:title font:DMFontPingFang_Regular(18) height:25];
        NSInteger h = 65;
        if (w <= 72) {
            w = 146;
        } else if (w > 200) {
            w = 276;
            h = 95;
        } else {
            w = w+80;
        }
        [SVProgressHUD setMinimumSize:CGSizeMake(w, h)];
        [SVProgressHUD setFont:DMFontPingFang_Regular(18)];
        [SVProgressHUD setImageViewSize:CGSizeMake(0, 0)];
        [SVProgressHUD setRingRadius:40];
        
    }
    [SVProgressHUD showImage:[UIImage imageNamed:imageName] status:title];
}

@end
