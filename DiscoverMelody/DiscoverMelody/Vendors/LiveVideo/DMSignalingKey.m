//
//  DMSignalingKey.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMSignalingKey.h"
#import <CommonCrypto/CommonDigest.h>
@implementation DMSignalingKey


+ (NSString *) calcToken:(NSString *)_appID certificate:(NSString *)certificate account:(NSString*)account expiredTime:(unsigned)expiredTime {
    // Token = 1:appID:expiredTime:sign
    // Token = 1:appID:expiredTime:md5(account + vendorID + certificate + expiredTime)
    //    expiredTime = 1544544000;
    //    account = @"20000685";
    
    NSString * sign = [DMSignalingKey MD5:[NSString stringWithFormat:@"%@%@%@%d", account, _appID, certificate, expiredTime]];
    return [NSString stringWithFormat:@"1:%@:%d:%@", _appID, expiredTime, sign];
}

+ (NSString*)MD5:(NSString*)s
{
    // Create pointer to the string as UTF8
    const char *ptr = [s UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
