#import "DMAssetInfo.h"
#import "DMAssetExif.h"
#import "DMAssetTIFF.h"

@interface DMAssetInfo ()

@property (strong, nonatomic) NSDictionary *assetInfo;

@property (strong, nonatomic) NSString *colorModel;
@property (assign, nonatomic) CGFloat dPIWidth;
@property (assign, nonatomic) CGFloat dPIHeight;
@property (assign, nonatomic) NSInteger depth;
@property (assign, nonatomic) CGFloat pixelWidth;
@property (assign, nonatomic) CGFloat pixelHeight;
@property (strong, nonatomic) NSString *profileName;

@property (strong, nonatomic) DMAssetExif *exif; // 扩展信息
@property (strong, nonatomic) DMAssetTIFF *tiff; // 标签图像文件格式

@end

@implementation DMAssetInfo

- (instancetype)initWithDict:(NSDictionary *)assetInfo {
    self = [super init];
    if (self) {
        _assetInfo = assetInfo;
        
    }
    return self;
}

- (NSString *)colorModel {
    if (!_colorModel) {
        _colorModel = self.assetInfo[@"ColorModel"];
    }
    
    return _colorModel;
}

- (CGFloat)dPIWidth {
    return [self.assetInfo[@"DPIWidth"] floatValue];
}

- (CGFloat)dPIHeight {
    return [self.assetInfo[@"DPIHeight"] floatValue];
}

- (NSInteger)depth {
    return [self.assetInfo[@"Depth"] integerValue];
}

- (CGFloat)pixelWidth {
    return [self.assetInfo[@"PixelWidth"] floatValue];
}

- (CGFloat)pixelHeight {
    return [self.assetInfo[@"PixelHeight"] floatValue];
}

- (NSString *)profileName {
    if (!_profileName) {
        _profileName = self.assetInfo[@"ProfileName"];
    }
    
    return _profileName;
}

- (DMAssetExif *)exif {
    if (!_exif) {
        NSDictionary *exifDict = self.assetInfo[@"{Exif}"];
        _exif = [[DMAssetExif alloc] initWithDict: exifDict];
    }
    
    return _exif;
}

- (DMAssetTIFF *)tiff {
    if (!_tiff) {
        NSDictionary *tiffDict = self.assetInfo[@"{TIFF}"];
        _tiff = [[DMAssetTIFF alloc] initWithDict: tiffDict];
    }
    
    return _tiff;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
