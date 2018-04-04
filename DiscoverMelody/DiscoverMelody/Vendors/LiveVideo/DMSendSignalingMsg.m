//
//  DMSendSignalingMsg.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMSendSignalingMsg.h"

@implementation DMSendSignalingMsg

+ (NSString *)getSignalingStruct:(NSInteger)code sourceData:(NSMutableArray *)sourceData sourceIndex:(NSInteger)index uuid:(NSString *)uuid {
    NSString *screenSize = NSStringFromCGSize(DMScreenSize);
    NSMutableDictionary *sourceDic = [NSMutableDictionary dictionary];
    sourceDic[@"code"] = @(code);
    sourceDic[@"sourceData"] = sourceData;
    sourceDic[@"index"] = @(index);
    sourceDic[@"size"] = screenSize;
    sourceDic[@"uuid"] = uuid;
    sourceDic[@"sendUUID"] = [NSUUID UUID].UUIDString;
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sourceDic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (OBJ_IS_NIL(jsonData)) {
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)getSignalingStruct:(DMSignalingCodeType)code sourceData:(NSMutableArray *)sourceData index:(NSInteger)index {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    switch (code) {
        case DMSignalingCode_Start_Syn:
            [resultArray addObjectsFromArray: sourceData];
            break;
        case DMSignalingCode_Turn_Page:
            if (index < sourceData.count) {
                [resultArray addObject:[sourceData objectAtIndex:index]];
            }
            break;
        case DMSignalingCode_End_Syn:
            break;
        default:
            break;
    }
    NSArray *dicArray = [DMClassDataModel mj_keyValuesArrayWithObjectArray:resultArray];
    NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithObjectsAndKeys:dicArray, @"list", nil];
    NSMutableDictionary *sourceDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)code], @"code", dics, @"data", nil];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sourceDic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (OBJ_IS_NIL(jsonData)) {
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
