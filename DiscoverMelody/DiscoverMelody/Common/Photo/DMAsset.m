#import "DMAsset.h"
#import "DMAssetInfo.h"

@interface DMAsset ()

@property (strong, nonatomic) ALAsset *asset;

@property (strong, nonatomic) ALAssetRepresentation *representation;
@property (strong, nonatomic) NSString *UTI; // 格式类型
@property (strong, nonatomic) NSString *filename; // 图片名
@property (strong, nonatomic) NSURL *url; // 文件url
@property (strong, nonatomic) UIImage *thumbnail; // 小图片
@property (strong, nonatomic) UIImage *compressionImage; // 压缩原图
@property (strong, nonatomic) UIImage *originImage; // 模糊原图
@property (strong, nonatomic) UIImage *fullResolutionImage; // 原图
@property (assign, nonatomic) long long byteSize; // 图片大小
@property (assign, nonatomic) CGSize dimensions; // 尺寸大小
@property (assign, nonatomic) CGFloat scale; // 图片放大比例
@property (assign, nonatomic) ALAssetOrientation orientation; // 方向
@property (strong, nonatomic) DMAssetInfo *assetInfo; // 基本信息

@end

@implementation DMAsset

- (instancetype)initWithAsset:(ALAsset *)asset {
    self = [super init];
    if (self) {
        _asset = asset;
    }
    return self;
}

- (ALAssetRepresentation *)representation {
    if (!_representation) {
        _representation = self.asset.defaultRepresentation;
    }
    
    return _representation;
}

- (NSString *)UTI {
    if (!_UTI) {
        _UTI = [self.representation UTI];
    }
    
    return _UTI;
}

- (NSString *)filename {
    if (!_filename) {
        _filename = [self.representation filename];
    }
    
    return _filename;
}

- (NSURL *)url {
    if (!_url) {
        _url = [self.representation url];
    }
    
    return _url;
}

- (UIImage *)thumbnail {
    if (!_thumbnail) {
//        _thumbnail = [UIImage imageWithCGImage:[self.asset thumbnail]];
        _thumbnail = [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    }
    
    return _thumbnail;
}

- (UIImage *)compressionImage {
    if (!_compressionImage) {
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[self.representation fullScreenImage]];
        NSData *data = UIImageJPEGRepresentation(fullScreenImage, 0.1);
        _compressionImage = [UIImage imageWithData:data];
    }
    
    return _compressionImage;
}

- (UIImage *)originImage {
    if (!_originImage) {
        _originImage = [UIImage imageWithCGImage:[self.representation fullScreenImage]];
    }
    
    return _originImage;
}

- (UIImage *)fullResolutionImage {
    if (!_fullResolutionImage) {
        _fullResolutionImage = [UIImage imageWithCGImage:[self.representation fullResolutionImage] scale:self.scale orientation:(UIImageOrientation)self.orientation];
    }
    
    return _fullResolutionImage;
}

- (long long)byteSize {
    return [self.representation size];
}

- (CGSize)dimensions {
    return _dimensions;
}

- (ALAssetOrientation)orientation {
    return [self.representation orientation];
}

- (DMAssetInfo *)assetInfo {
    if (!_assetInfo) {
        _assetInfo = [[DMAssetInfo alloc] initWithDict:[self.representation metadata]];
    }
    
    return _assetInfo;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
