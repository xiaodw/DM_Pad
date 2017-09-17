//
//  DMUploadController.m
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMUploadController.h"
#import "DMAlbum.h"
#import "DMLiveCoursewareCell.h"
#import "UIColor+Extension.h"
#import "DMAlbum.h"
#import "DMAlbumAssetHelp.h"

#define kCoursewareCellID @"Courseware"

#import "DMAlbrmsTableView.h"
#import "DMAssetsCollectionView.h"

@interface DMUploadController () <DMAlbrmsTableViewDelegate, DMAssetsCollectionViewDelegate>

@property (strong, nonatomic) DMAlbrmsTableView *albumsView;
@property (strong, nonatomic) DMAssetsCollectionView *assetsView;
@property (strong, nonatomic) UIButton *button;

@property (strong, nonatomic) DMAlbumAssetHelp *imagePickerHelp;
@property (strong, nonatomic) NSMutableArray *albums;
@property (assign, nonatomic) bool isUploaded;

@end

@implementation DMUploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMakeAddSubviews];
    [self.view addSubview:self.button];
    [self setupMakeLayoutSubviews];
    [self.navigationController setNavigationBarHidden:YES];
    
    _imagePickerHelp = [DMAlbumAssetHelp albumAssetHelpWithType:ALAssetsGroupAll filter:[ALAssetsFilter allPhotos] completionBlock:^(BOOL success, NSMutableArray *albums) {
        self.albums = albums;
        self.albumsView.albums = albums;
        DMAlbum *album = albums.lastObject;
        self.albumsView.albums = albums;
        self.assetsView.assets = album.assets;
        
        for (int i = 0; i < albums.count; i++) {
            DMAlbum *album = albums[i];
            
            NSLog(@"assets: %zd", album.assets.count);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.albumsView];
    [self.view addSubview:self.assetsView];
}

- (void)setupMakeLayoutSubviews {
    [_albumsView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(DMScreenWidth*0.5);
        make.left.top.bottom.equalTo(self.view);
    }];
    
    [_assetsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.width.equalTo(_albumsView);
    }];
}

- (void)albrmsTableView:(DMAlbrmsTableView *)albrmsTableView didTapRightButton:(UIButton *)rightButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapLeftButton:(UIButton *)leftButton {
    NSLog(@"%s", __func__);
    if (_isUploaded) return;
    
    [_assetsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_albumsView);
        make.right.equalTo(_albumsView.mas_left);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapRightButton:(UIButton *)rightButton {
    NSLog(@"%s", __func__);
    
}

- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapUploadButton:(UIButton *)uploadButton {
    NSLog(@"%s", __func__);
}

- (DMAlbrmsTableView *)albumsView {
    if (!_albumsView) {
        _albumsView = [DMAlbrmsTableView new];
        _albumsView.delegate = self;
        _albumsView.backgroundColor = [UIColor randomColor];
    }
    
    return _albumsView;
}

- (DMAssetsCollectionView *)assetsView {
    if (!_assetsView) {
        _assetsView = [DMAssetsCollectionView new];
        _assetsView.delegate = self;
        _assetsView.backgroundColor = [UIColor randomColor];
    }
    
    return _assetsView;
}

- (void)didTapTest {
    DMLogFunc
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        [_button setTitle:@"ghjghjgjg" forState:UIControlStateNormal];
        _button.frame = CGRectMake(600, 100, 100, 100);
        _button.backgroundColor = [UIColor whiteColor];
        [_button addTarget:self action:@selector(didTapTest) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _button;
}

@end
