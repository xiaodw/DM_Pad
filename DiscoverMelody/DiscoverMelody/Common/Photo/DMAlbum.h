#import <UIKit/UIKit.h>

@class ALAssetsGroup;

@interface DMAlbum : NSObject

@property (strong, nonatomic, readonly) NSString *name; // 专辑名
@property (assign, nonatomic, readonly) UInt32 type; // 专辑类型
@property (strong, nonatomic, readonly) NSString *persistentID; // 持久性ID
@property (strong, nonatomic, readonly) NSString *url; // 专辑url
@property (strong, nonatomic, readonly) UIImage *defaultAlbumAsset; // 默认Cover Photo
@property (strong, nonatomic, readonly) NSMutableArray *assets;

@property (strong, nonatomic, readonly) ALAssetsGroup *album;
+ (instancetype)album:(ALAssetsGroup *)album;

@end
