#import "DMPHCollection.h"
#import "DMPHAsset.h"

#import <Photos/Photos.h>

@interface DMPHCollection() <PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) PHAssetCollection *collection;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSString *collectionName;
@property (assign, nonatomic) NSUInteger assetCount;

@end

@implementation DMPHCollection


- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_sync(dispatch_get_main_queue(), ^{

    });
}

- (void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    
    // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
//    dispatch_async(dispatch_queue_create(0, 0), ^{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *assetsResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        self.assetCount = assetsResult.count;
        NSMutableArray *assetArray = [NSMutableArray array];
        for (NSInteger i = 0; i < assetsResult.count; i++) {
            // 获取一个资源（PHAsset）
            DMPHAsset *asset = [[DMPHAsset alloc] initWithAsset:assetsResult[i]];
            [assetArray addObject:asset];
        }
        
        _assets = assetArray;
//    });
}

static NSDictionary *albumsDictionary_;

- (NSString *)collectionName {
    if (_collectionName.length) return _collectionName;
    if (!self.collection) return @"";
    _collectionName = albumsDictionary_[self.collection.localizedTitle];
    return _collectionName;
}

- (instancetype)initWithCollection:(PHAssetCollection *)collection {
    if (self = [super init]) {
        self.collection = collection;
    }

    return self;
}

+ (instancetype)collection:(PHAssetCollection *)collection {
    return [[self alloc] initWithCollection:collection];
}

+ (void)load {
    [super load];
    
    albumsDictionary_ = @{@"Slo-mo": @"慢动作",
                          @"Recently Added": @"最近添加",
                          @"Favorites": @"最爱",
                          @"Recently Deleted": @"最近删除",
                          @"Videos": @"视频",
                          @"All Photos": @"所有照片",
                          @"Selfies": @"自拍",
                          @"Screenshots": @"屏幕快照",
                          @"Camera Roll": @"相机胶卷"};
}



- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
