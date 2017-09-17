#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

typedef void (^AlbumRestrictedCallback)(BOOL success, NSMutableArray *albums); //cell的点击回调

@interface DMAlbumAssetHelp : NSObject

- (instancetype)initWithType:(ALAssetsGroupType)type filter:(ALAssetsFilter *)filter completionBlock:(AlbumRestrictedCallback)callBack;
+ (instancetype)albumAssetHelpWithType:(ALAssetsGroupType)type filter:(ALAssetsFilter *)filter completionBlock:(AlbumRestrictedCallback)callBack;
- (void) refreshAlbumAssetWithType:(ALAssetsGroupType)type filter:(ALAssetsFilter *)filter completionBlock:(AlbumRestrictedCallback)callBack;

@end
