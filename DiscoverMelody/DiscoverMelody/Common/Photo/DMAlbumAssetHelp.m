#import "DMAlbumAssetHelp.h"
#import "DMAlbum.h"

@interface DMAlbumAssetHelp()

@property (assign, nonatomic) BOOL authorizationStatus;
@property (strong, nonatomic) ALAssetsLibrary *defaultAssetsLibrary;

@end

@implementation DMAlbumAssetHelp

- (BOOL)authorizationStatus {
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    return authorizationStatus != ALAuthorizationStatusAuthorized && authorizationStatus != ALAuthorizationStatusNotDetermined;
}

+ (instancetype)albumAssetHelpWithType:(ALAssetsGroupType)type filter:(ALAssetsFilter *)filter completionBlock:(AlbumRestrictedCallback)callBack {
    return [[self alloc] initWithType:type filter:filter completionBlock:callBack];
}

- (instancetype)initWithType:(ALAssetsGroupType)type filter:(ALAssetsFilter *)filter completionBlock:(AlbumRestrictedCallback)callBack {
    self = [super init];
    if (self) {
        [self refreshAlbumAssetWithType:type filter:filter completionBlock:callBack];
    }
    return self;
}

- (void) refreshAlbumAssetWithType:(ALAssetsGroupType)type filter:(ALAssetsFilter *)filter completionBlock:(AlbumRestrictedCallback)callBack {
    if (self.authorizationStatus) {
        if (callBack)  {
            callBack(NO, nil, NO);
        }
        return;
    }
    
    NSMutableArray *albums = [NSMutableArray array];
    [self.defaultAssetsLibrary enumerateGroupsWithTypes:type usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:filter];
            DMAlbum *album = [DMAlbum album:group];
            [albums addObject:album];
            return;
        }
        if (stop) callBack(YES, albums, NO);
    } failureBlock:^(NSError *error) {
        callBack(NO, nil, YES);
    }];
    
}

- (ALAssetsLibrary *)defaultAssetsLibrary {
    if (!_defaultAssetsLibrary) {
        _defaultAssetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _defaultAssetsLibrary;
}

@end
