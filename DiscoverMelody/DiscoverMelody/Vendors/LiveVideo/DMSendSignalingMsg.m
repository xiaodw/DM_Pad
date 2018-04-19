//
//  DMSendSignalingMsg.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMSendSignalingMsg.h"
#import "DMSignalingMsgData.h"

@implementation DMSendSignalingMsg

+ (NSString *)getSignalingStruct:(DMSignalingWhiteBoardCodeType)code sourceData:(NSMutableArray *)sourceData index:(NSInteger)index size:(CGSize)size lineWidth:(CGFloat)width lineColor:(NSString *)color synType:(DMSignalingMsgType)type {
    DMSignalingMsgData *msgData = [DMSignalingMsgData new];
    DMSignalingData *data = [DMSignalingData new];
    data.listPoint = sourceData;
    msgData.type = type;
    msgData.code = code;
    msgData.indexID = index;
    msgData.size = NSStringFromCGSize(size);
    msgData.colorHex = color;
    msgData.lineWidth = width;
    msgData.data = data;
    msgData.packetUID = [NSUUID UUID].UUIDString;
    NSString *msg = [self signalingDataToMsg: msgData];
    return msg;
}

+ (NSString *)getSignalingStruct:(DMSignalingCodeType)code sourceData:(NSArray *)sourceData synType:(DMSignalingMsgType)type {
    DMSignalingMsgData *msgData = [DMSignalingMsgData new];
    DMSignalingData *data = [DMSignalingData new];
    data.list = sourceData;
    msgData.type = type;
    msgData.code = code;
    msgData.data = data;
    NSString *msg = [self signalingDataToMsg: msgData];
    return msg;
}

+ (NSString *)signalingDataToMsg:(DMSignalingMsgData *)data {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data.mj_keyValues options:NSJSONWritingPrettyPrinted error:&parseError];
    if (OBJ_IS_NIL(jsonData)) { return @""; }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
