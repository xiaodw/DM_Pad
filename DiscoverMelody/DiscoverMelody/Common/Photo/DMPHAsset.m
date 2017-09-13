#import "DMPHAsset.h"

#import <Photos/Photos.h>

#define kLoadedImageKey @"LoadedImageKey"
#define kLoadedInfoKey @"LoadedInfoKey"

@interface DMPHAsset()

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) PHImageRequestOptions *options;
@property (strong, nonatomic) NSMutableDictionary *cacheloadedImageDictionary;

@end

@implementation DMPHAsset

- (PHImageRequestOptions *)options {
    if (!_options) {
        _options =[[PHImageRequestOptions alloc] init];
        _options.synchronous = NO; // 异步, 默认也是异步
        
        //仅显示缩略图，不控制质量显示
        /**
         PHImageRequestOptionsResizeModeNone,
         PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
         PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
         */
        _options.resizeMode = PHImageRequestOptionsResizeModeFast;
        _options.networkAccessAllowed = YES;
        //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    }
    
    return _options;
}

- (void)thumbnailImageWithSize:(CGSize)size compression:(BOOL)compression resultHandler:(void (^)(UIImage *image, NSDictionary *info))handler {
    NSString *string = NSStringFromCGSize(size);
    NSDictionary *loadedDictionary = self.cacheloadedImageDictionary[string];
    if (loadedDictionary){
        UIImage *loadedImage = loadedDictionary[kLoadedImageKey];
        NSDictionary *loadedInfo = loadedDictionary[kLoadedInfoKey];
        return handler(loadedImage, loadedInfo);
    }
    
    CGSize practiceSize = CGSizeMake([UIScreen mainScreen].scale * size.width, [UIScreen mainScreen].scale * size.height);
    
    [[PHImageManager defaultManager] requestImageForAsset:_asset targetSize:practiceSize contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.cacheloadedImageDictionary[string] = @{kLoadedImageKey: result, kLoadedInfoKey: info};
        handler(result, info);
    }];
}

- (void)fullResolutionImageWithCompression:(BOOL)compression resultHandler:(void (^)(UIImage *image, NSDictionary *info))handler {
    [self thumbnailImageWithSize:CGSizeMake(_asset.pixelWidth, _asset.pixelHeight) compression:compression resultHandler:handler];
}

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (NSMutableDictionary *)cacheloadedImageDictionary {
    if (!_cacheloadedImageDictionary) {
        _cacheloadedImageDictionary = [NSMutableDictionary dictionary];
    }
    
    return _cacheloadedImageDictionary;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
