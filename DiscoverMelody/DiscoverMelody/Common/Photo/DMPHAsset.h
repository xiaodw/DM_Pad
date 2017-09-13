#import <UIKit/UIKit.h>

@class PHAsset;

@interface DMPHAsset : NSObject

- (instancetype)initWithAsset:(PHAsset *)asset;
- (void)thumbnailImageWithSize:(CGSize)size compression:(BOOL)compression resultHandler:(void (^)(UIImage *, NSDictionary *))handler;
- (void)fullResolutionImageWithCompression:(BOOL)compression resultHandler:(void (^)(UIImage *, NSDictionary *))handler;

@end
