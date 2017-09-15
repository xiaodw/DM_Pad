//
//  DMUserDefaults.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMUserDefaults.h"

@implementation DMUserDefaults
+(void)setValue:(id)value forKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    if ([value isKindOfClass:[NSArray class]])
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
        value = data;
    }
    [userDef setValue:value forKey:[NSString stringWithFormat:@"%@",key]];
    [userDef synchronize];
}
+(id)getValueWithKey:(NSString*)key{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    id value = [userDef valueForKey:[NSString stringWithFormat:@"%@",key]];
    if(STR_IS_NIL(value) && [value isKindOfClass:[NSString class]]){
        value = @"";
    }
    return value;
}
+(NSMutableArray *)getMutArrayWithKey:(NSString *)key
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSData *value = [userDef valueForKey:[NSString stringWithFormat:@"%@",key]];
    
    if (nil == value) {
        return nil;
    }
    NSMutableArray *valueArray = [NSKeyedUnarchiver unarchiveObjectWithData:value];
    if (valueArray.count <= 0)
    {
        valueArray = [NSMutableArray array];
    }
    return valueArray;
}
@end
