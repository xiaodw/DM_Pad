//
//  DMAlbum.m
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMAlbum.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "DMAsset.h"

@interface DMAlbum()

@property (strong, nonatomic) ALAssetsGroup *album;
@property (strong, nonatomic) NSString *name; // 专辑名
@property (assign, nonatomic) UInt32 type; // 专辑类型
@property (strong, nonatomic) NSString *persistentID; // 持久性ID
@property (strong, nonatomic) NSString *url; // 专辑url
@property (strong, nonatomic) UIImage *defaultAlbumAsset; // 默认Cover Photo
@property (strong, nonatomic) NSMutableArray *assets;

@end

@implementation DMAlbum

+ (instancetype)album:(ALAssetsGroup *)album {
    return [[self alloc] initWithAlbum:album];
}

- (instancetype)initWithAlbum:(ALAssetsGroup *)album {
    if (self = [super init]) {
        _album = album;
        WS(weakSelf)
        [album enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) return;
            DMAsset *asset = [[DMAsset alloc] initWithAsset:result];
            [weakSelf.assets addObject:asset];
        }];
    }
    return self;
}

- (UInt32)type {
    NSString *type = [NSString stringWithFormat:@"%@", [self.album valueForProperty:ALAssetsGroupPropertyType]];
    return [type intValue];
}

- (NSString *)name {
    if (!_name.length) {
        _name = [self.album valueForProperty:ALAssetsGroupPropertyName];
    }
    return _name;
}

- (NSString *)persistentID {
    if (!_persistentID.length) {
        _persistentID = [self.album valueForProperty:ALAssetsGroupPropertyPersistentID];
    }
    
    return _persistentID;
}

- (NSString *)url {
    if (!_url) {
        _url = [self.album valueForProperty:ALAssetsGroupPropertyURL];
    }
    
    return _url;
}

- (UIImage *)defaultAlbumAsset {
    if (!_defaultAlbumAsset) {
        DMAsset *asset = self.assets.lastObject;
        _defaultAlbumAsset = asset.thumbnail;
    }
    
    return _defaultAlbumAsset;
}

- (NSMutableArray *)assets {
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    
    return _assets;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
