#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class DMAssetInfo;

typedef NS_ENUM(NSUInteger, DMAssetStatus) {
    DMAssetStatusNormal,
    DMAssetStatusSuccess,
    DMAssetStatusFail,
    DMAssetStatusUploading
};


@interface DMAsset : NSObject

@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) DMAssetStatus status;

@property (strong, nonatomic, readonly) ALAsset *asset;

@property (strong, nonatomic, readonly) ALAssetRepresentation *representation;
@property (strong, nonatomic, readonly) NSString *UTI; // 格式类型
@property (strong, nonatomic, readonly) NSString *filename; // 图片名
@property (strong, nonatomic, readonly) NSURL *url; // 文件url
@property (strong, nonatomic, readonly) UIImage *thumbnail; // 小图片
@property (strong, nonatomic, readonly) UIImage *compressionImage; // 压缩原图
@property (strong, nonatomic, readonly) UIImage *originImage; // 模糊原图
@property (strong, nonatomic, readonly) UIImage *fullResolutionImage; // 原图
@property (assign, nonatomic, readonly) long long byteSize; // 图片大小
@property (assign, nonatomic, readonly) CGSize dimensions; // 尺寸大小
@property (assign, nonatomic, readonly) CGFloat scale; // 图片放大比例
@property (assign, nonatomic, readonly) ALAssetOrientation orientation; // 方向
@property (strong, nonatomic, readonly) DMAssetInfo *assetInfo; // 基本信息

- (instancetype)initWithAsset:(ALAsset *)asset;

@end
