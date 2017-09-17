//
//  DMAssetTIFF.m
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMAssetTIFF.h"

@interface DMAssetTIFF ()

@property (strong, nonatomic) NSDictionary *tiff;

@property (strong, nonatomic) NSString *dateTime; // 创建时间
@property (strong, nonatomic) NSString *make; // 制作厂商
@property (strong, nonatomic) NSString *model; // 设备模型
@property (assign, nonatomic) NSInteger orientation; // 方向
@property (assign, nonatomic) NSInteger resolutionUnit; // 分辨率单位
@property (assign, nonatomic) CGFloat xResolution; // X分辨率
@property (assign, nonatomic) CGFloat yResolution; // Y分辨率

@end

@implementation DMAssetTIFF

- (instancetype)initWithDict:(NSDictionary *)tiff {
    self = [super init];
    if (self) {
        _tiff = tiff;
    }
    return self;
}

- (NSString *)dateTime {
    if (!_dateTime) {
        _dateTime = self.tiff[@"DateTime"];
    }
    
    return _dateTime;
}

- (NSString *)make {
    if (!_make) {
        _make = self.tiff[@"Make"];
    }
    
    return _make;
}

- (NSString *)model {
    if (!_model) {
        _model = self.tiff[@"Model"];
    }
    
    return _model;
}

- (NSInteger)orientation {
    return  [self.tiff[@"Orientation"] integerValue];
}

- (NSInteger)resolutionUnit {
    return [self.tiff[@"ResolutionUnit"] integerValue];
}

- (CGFloat)xResolution {
    return [self.tiff[@"XResolution"] floatValue];
}


- (CGFloat)yResolution {
    return [self.tiff[@"YResolution"] floatValue];
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
