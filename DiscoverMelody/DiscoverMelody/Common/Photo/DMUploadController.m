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

#import "DMAlbumsTableView.h"
#import "DMAssetsCollectionView.h"

@interface DMUploadController () <DMAlbumsTableViewDelegate, DMAssetsCollectionViewDelegate>

@property (strong, nonatomic) DMAlbumsTableView *albumsView;
@property (strong, nonatomic) DMAssetsCollectionView *assetsView;


@property (strong, nonatomic) DMAlbumAssetHelp *imagePickerHelp;
@property (strong, nonatomic) NSMutableArray *albums;
@property (assign, nonatomic) bool isUploaded;

@property (assign, nonatomic) BOOL isPhotoSuccess;

@end

@implementation DMUploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self.navigationController setNavigationBarHidden:YES];
    _isPhotoSuccess = YES;
    _imagePickerHelp = [DMAlbumAssetHelp albumAssetHelpWithType:ALAssetsGroupAll filter:[ALAssetsFilter allPhotos] completionBlock:^(BOOL success, NSMutableArray *albums, BOOL first) {
        
        if(!success) {
            _isPhotoSuccess = NO;
            
            if (first) {
                [self viewWillAppear:YES];
            }
            return;
        }
        
        self.albums = albums;
        self.albumsView.albums = albums;
        DMAlbum *album = albums.lastObject;
        self.albumsView.albums = albums;
        self.assetsView.assets = album.assets;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isPhotoSuccess) return;
    
    DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"“寻律”要访问您的相册, 是否允许?" message:Capture_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"不允许" otherTitle:@"允许", nil];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index == 1) { // 右侧
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
            return ;
        }
        
        // 左侧
        [self dismissViewControllerAnimated:YES completion:nil];
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
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
    
    [_assetsView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(_albumsView);
        make.width.equalTo(DMScreenWidth);
    }];
}

- (void)albumsTableView:(DMAlbumsTableView *)albumsTableView didTapRightButton:(UIButton *)rightButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)albumsTableView:(DMAlbumsTableView *)albumsTableView didTapSelectedIndexPath:(NSIndexPath *)indexPath {
    DMAlbum *album = self.albums[indexPath.row];
    self.assetsView.assets = album.assets;
    
    [_assetsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_albumsView);
        make.right.equalTo(_albumsView);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
    }];
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

- (DMAlbumsTableView *)albumsView {
    if (!_albumsView) {
        _albumsView = [DMAlbumsTableView new];
        _albumsView.delegate = self;
    }
    
    return _albumsView;
}

- (DMAssetsCollectionView *)assetsView {
    if (!_assetsView) {
        _assetsView = [DMAssetsCollectionView new];
        _assetsView.delegate = self;
    }
    
    return _assetsView;
}

- (void)didTapTest {
    DMLogFunc
}

@end
