//
//  BezierPath.m
//  画板
//
//  Created by My mac on 2018/3/8.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMBezierPath.h"

@implementation DMBezierPath

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 设置默认值
        // 设置路径的宽度
        self.lineWidth = 3;
        // 设置路径的颜色
        self.lineColor = [UIColor redColor];
        // 设置连接处的样式
        self.lineJoinStyle = kCGLineJoinRound;
        // 设置头尾的样式
        self.lineCapStyle = kCGLineCapRound;
    }
    return self;
}

@end
