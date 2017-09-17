//
//  DMAssetExif.m
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMAssetExif.h"

@interface DMAssetExif ()

@property (strong, nonatomic) NSDictionary *exif;

@property (assign, nonatomic) NSInteger colorSpace; // 颜色空间
@property (strong, nonatomic) NSArray *componentsConfiguration; // 组件的配置
@property (strong, nonatomic) NSArray *exifVersion; // EXIF版本
@property (strong, nonatomic) NSArray *flashPixVersion; // Flash图片版
@property (assign, nonatomic) NSInteger pixelXDimension; // 像素X尺寸
@property (assign, nonatomic) NSInteger pixelYDimension; // 像素Y尺寸
@property (assign, nonatomic) NSInteger sceneCaptureType; // 场景捕获类型

@end

@implementation DMAssetExif

- (instancetype)initWithDict:(NSDictionary *)exif {
    self = [super init];
    if (self) {
        _exif = exif;
    }
    return self;
}

- (NSInteger)colorSpace {
    return [self.exif[@"ColorSpace"] integerValue];
}

- (NSArray *)componentsConfiguration {
    if (!_componentsConfiguration) {
        _componentsConfiguration = self.exif[@"ComponentsConfiguration"];
    }
    
    return _componentsConfiguration;
}

- (NSArray *)exifVersion {
    if (!_exifVersion) {
        _exifVersion = self.exif[@"ExifVersion"];
    }
    
    return _exifVersion;
}

- (NSArray *)flashPixVersion {
    if (!_flashPixVersion) {
        _flashPixVersion = self.exif[@"FlashPixVersion"];
    }
    
    return _flashPixVersion;
}

- (NSInteger)pixelXDimension {
    return [self.exif[@"PixelXDimension"] integerValue];
}

- (NSInteger)pixelYDimension {
    return [self.exif[@"PixelYDimension"] integerValue];
}

- (NSInteger)sceneCaptureType {
    return [self.exif[@"SceneCaptureType"] integerValue];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
