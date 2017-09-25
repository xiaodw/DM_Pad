#import <Foundation/Foundation.h>

@interface DMAssetExif : NSObject

@property (strong, nonatomic, readonly) NSDictionary *exif;

@property (assign, nonatomic, readonly) NSInteger colorSpace; // 颜色空间
@property (strong, nonatomic, readonly) NSArray *componentsConfiguration; // 组件的配置
@property (strong, nonatomic, readonly) NSArray *exifVersion; // EXIF版本
@property (strong, nonatomic, readonly) NSArray *flashPixVersion; // Flash图片版
@property (assign, nonatomic, readonly) NSInteger pixelXDimension; // 像素X尺寸
@property (assign, nonatomic, readonly) NSInteger pixelYDimension; // 像素Y尺寸
@property (assign, nonatomic, readonly) NSInteger sceneCaptureType; // 场景捕获类型

- (instancetype)initWithDict:(NSDictionary *)exif;

@end
