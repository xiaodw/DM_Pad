//
//  DMAssetInfo.h
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMAssetTIFF, DMAssetExif;

@interface DMAssetInfo : NSObject

@property (strong, nonatomic, readonly) NSDictionary *assetInfo;

@property (strong, nonatomic, readonly) NSString *colorModel; // 颜色模式(RGB)
@property (assign, nonatomic, readonly) CGFloat dPIWidth; // 每英寸所打印的点数
@property (assign, nonatomic, readonly) CGFloat dPIHeight;
@property (assign, nonatomic, readonly) NSInteger depth; // 深度值
@property (assign, nonatomic, readonly) CGFloat pixelWidth;  // 像素宽度
@property (assign, nonatomic, readonly) CGFloat pixelHeight; // 像素高度
@property (strong, nonatomic, readonly) NSString *profileName; // 配置文件名

@property (strong, nonatomic, readonly) DMAssetExif *exif; // 扩展信息
@property (strong, nonatomic, readonly) DMAssetTIFF *tiff; // 标签图像文件格式

- (instancetype)initWithDict:(NSDictionary *)assetInfo;

@end
