//
//  DMSignalingMsgData.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSignalingData : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *listPoint;

@end

@interface DMSignalingMsgData : NSObject

@property (nonatomic, assign) DMSignalingMsgType type; // 类型: 1. 课件同步, 2. 白板
/**
 * 类型 1: 1. 同步开始, 2. 操作, 3. 结束同步
 * 类型 2: 1. 画笔路径, 2. 清除, 3. 回退, 4. 前进, 5. 取消
 */
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) DMSignalingData *data; //数据
@property (nonatomic, strong) NSString *size; // 当前画板大小
@property (nonatomic, copy) NSString *colorHex; // 画笔颜色值, 16进制
@property (nonatomic, assign) CGFloat lineWidth; // 画笔宽度
@property (nonatomic, assign) NSInteger indexID; // 当前path索引ID
@property (nonatomic, strong) NSString *packetUID; // 包ID, 防止发送一个包接收到多次

@end
