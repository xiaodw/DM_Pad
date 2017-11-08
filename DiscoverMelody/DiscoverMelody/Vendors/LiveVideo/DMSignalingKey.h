//
//  DMSignalingKey.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSignalingKey : NSObject
+ (NSString *) calcToken:(NSString *)_appID certificate:(NSString *)certificate account:(NSString*)account expiredTime:(unsigned)expiredTime;
+ (NSString*)MD5:(NSString*)s;
@end
