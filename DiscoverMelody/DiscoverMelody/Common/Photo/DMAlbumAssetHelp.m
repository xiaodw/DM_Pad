//
//  DMAlbumAssetHelp.m
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

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
            callBack(NO, nil);
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
        if (stop) callBack(YES, albums);
    } failureBlock:^(NSError *error) {
        callBack(NO, nil);
    }];
    
}

- (ALAssetsLibrary *)defaultAssetsLibrary {
    if (!_defaultAssetsLibrary) {
        _defaultAssetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _defaultAssetsLibrary;
}

@end
