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
#import "DMLiveController.h"

@interface DMUploadController () <DMAlbumsTableViewDelegate, DMAssetsCollectionViewDelegate>

@property (strong, nonatomic) UIView *albumBackgroundView;
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
        self.assetsView.album = albums.lastObject;;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isPhotoSuccess) return;
    
    DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:Photo_Msg message:Capture_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleDonAllow otherTitle:DMTitleAllow, nil];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index == 1) { // 右侧
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
            return ;
        }
        
        // 左侧
        [self.liveVC.presentVCs removeObject:self];
        self.liveVC = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.albumBackgroundView];
    [self.view addSubview:self.assetsView];
}

- (void)setupMakeLayoutSubviews {
    [_assetsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.left.bottom.equalTo(self.view);
    }];
    
    [_albumBackgroundView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
}

- (void)albumsTableView:(DMAlbumsTableView *)albumsTableView didTapRightButton:(UIButton *)rightButton {
    [self.liveVC.presentVCs removeObject:self];
    self.liveVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)albumsTableView:(DMAlbumsTableView *)albumsTableView didTapSelectedIndexPath:(NSIndexPath *)indexPath {
    DMAlbum *album = self.albums[indexPath.row];
    self.assetsView.album = album;
    
    [_albumsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.equalTo(_albumBackgroundView);
        make.left.equalTo(DMScreenWidth*0.5*0.3);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [_albumBackgroundView layoutSubviews];
    }];
    
    [_assetsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.left.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapLeftButton:(UIButton *)leftButton {
    NSLog(@"%s", __func__);
    if (_isUploaded) return;
    
    [_albumsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.equalTo(_albumBackgroundView);
        make.left.equalTo(_albumBackgroundView);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [_albumBackgroundView layoutSubviews];
    }];
    
    [_assetsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_albumBackgroundView);
        make.right.equalTo(_albumBackgroundView.mas_left);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapRightButton:(UIButton *)rightButton {
    [self.liveVC.presentVCs removeObject:self];
    self.liveVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (UIView *)albumBackgroundView {
    if (!_albumBackgroundView) {
        _albumBackgroundView = [UIView new];
        _albumBackgroundView.backgroundColor = [UIColor clearColor];
        [_albumBackgroundView addSubview:self.albumsView];
        _albumBackgroundView.clipsToBounds = YES;
        
        [_albumsView makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.bottom.equalTo(_albumBackgroundView);
            make.left.equalTo(DMScreenWidth*0.5*0.3);
        }];
    }
    
    return _albumBackgroundView;
}

- (void)didTapTest {
    DMLogFunc
}

@end
