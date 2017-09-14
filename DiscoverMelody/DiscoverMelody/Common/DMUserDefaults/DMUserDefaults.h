//
//  DMUserDefaults.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMUserDefaults : NSObject

+(void)setValue:(id)value forKey:(NSString*)key;
+(id)getValueWithKey:(NSString*)key;
+(NSMutableArray *) getMutArrayWithKey:(NSString *)key;

@end
