#import <Foundation/Foundation.h>

@class PHAssetCollection;

@interface DMPHCollection : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *assets;
@property (strong, nonatomic, readonly) NSString *collectionName;
@property (assign, nonatomic, readonly) NSUInteger assetCount;

- (instancetype)initWithCollection:(PHAssetCollection *)collection;
+ (instancetype)collection:(PHAssetCollection *)collection;

@end
