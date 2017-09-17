//
//  DMAssetTIFF.h
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMAssetTIFF : NSObject

@property (strong, nonatomic, readonly) NSDictionary *tiff;

@property (strong, nonatomic, readonly) NSString *dateTime; // 创建时间
@property (strong, nonatomic, readonly) NSString *make; // 制作厂商
@property (strong, nonatomic, readonly) NSString *model; // 设备模型
@property (assign, nonatomic, readonly) NSInteger orientation; // 方向
@property (assign, nonatomic, readonly) NSInteger resolutionUnit; // 分辨率单位
@property (assign, nonatomic, readonly) CGFloat xResolution; // X分辨率
@property (assign, nonatomic, readonly) CGFloat yResolution; // Y分辨率

- (instancetype)initWithDict:(NSDictionary *)tiff;

@end
