#import "DMUploadController.h"
#import "DMLiveController.h"
#import "DMLiveCoursewareCell.h"
#import "DMAlbumAssetHelp.h"
#import "DMAlbumsTableView.h"
#import "DMAssetsCollectionView.h"
#import "DMAlbum.h"

#define kCoursewareCellID @"Courseware"

@interface DMUploadController () <DMAlbumsTableViewDelegate, DMAssetsCollectionViewDelegate>

@property (strong, nonatomic) UIView *albumBackgroundView; // 背景
@property (strong, nonatomic) UIView *backgroundView; // 背景
@property (strong, nonatomic) DMAlbumsTableView *albumsView; // 所有的专辑
@property (strong, nonatomic) DMAssetsCollectionView *assetsView; // 某个专辑对应的所有资源图片
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) DMAlbumAssetHelp *imagePickerHelp; // 一个获取图片的类
@property (strong, nonatomic) NSMutableArray *albums; // 当前系统所有的专辑
@property (assign, nonatomic) BOOL isPhotoSuccess; // 是否成功获取相册

@end

@implementation DMUploadController

#pragma mark - Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self.navigationController setNavigationBarHidden:YES];
    _isPhotoSuccess = YES;
    WS(weakSelf)
    _imagePickerHelp = [DMAlbumAssetHelp albumAssetHelpWithType:ALAssetsGroupAll filter:[ALAssetsFilter allPhotos] completionBlock:^(BOOL success, NSMutableArray *albums, BOOL first) {
        if(!success) {
            weakSelf.isPhotoSuccess = NO;
            if (!first) return;
            [weakSelf.liveVC.presentVCs removeObject:weakSelf];
            weakSelf.liveVC = nil;
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        weakSelf.albums = albums;
        weakSelf.albumsView.albums = albums;
        weakSelf.assetsView.album = albums.lastObject;;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (_isPhotoSuccess) return;
    WS(weakSelf)
    DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"" message:Photo_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleCancel otherTitle:DMTitleGoSetting, nil];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index == 1) { // 右侧
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
        
        // 左侧
        [weakSelf.liveVC.presentVCs removeObject:weakSelf];
        weakSelf.liveVC = nil;
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Function
- (void)didTapBackground {
    [self.liveVC.presentVCs removeObject:self];
    self.liveVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DMAlbumsTableViewDelegate
/** tableView: 点击返回退出 */
- (void)albumsTableView:(DMAlbumsTableView *)albumsTableView didTapRightButton:(UIButton *)rightButton {
    [self.liveVC.presentVCs removeObject:self];
    self.liveVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** tableView: 点击某一个cell */
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

#pragma mark - DMAssetsCollectionViewDelegate
/** collectionView: 点击left */
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapLeftButton:(UIButton *)leftButton {
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

/** collectionView: 点击right退出 */
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapRightButton:(UIButton *)rightButton {
    [self didTapBackground];
}

/** collectionView: 上传之后成功回调 */
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView success:(NSArray *)courses{
    [self.liveVC.presentVCs removeObject:self];
    self.liveVC = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate uploadController:self successAsset:courses];
    }];
}

#pragma mark - AddSubviews
- (void)setupMakeAddSubviews {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.shadowImageView];
    [self.view addSubview:self.albumBackgroundView];
    [self.view addSubview:self.assetsView];
}

#pragma mark - LayoutSubviews
- (void)setupMakeLayoutSubviews {
    [_backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_albumBackgroundView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
    [_assetsView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.equalTo(self.view);
        make.right.equalTo(_albumBackgroundView.mas_left);
    }];
    
    [_shadowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.width.equalTo(50);
        make.left.equalTo(_albumBackgroundView.mas_right);
    }];
}

#pragma mark - Lazy

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _backgroundView;
}

- (DMAlbumsTableView *)albumsView {
    if (!_albumsView) {
        _albumsView = [DMAlbumsTableView new];
        _albumsView.delegate = self;
    }
    
    return _albumsView;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [UIImageView new];
        _shadowImageView.image = [UIImage imageNamed:@"image_shadow"];
    }
    
    return _shadowImageView;
}

- (DMAssetsCollectionView *)assetsView {
    if (!_assetsView) {
        _assetsView = [DMAssetsCollectionView new];
        _assetsView.delegate = self;
        _assetsView.lessonID = self.lessonID;
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
            make.left.equalTo(_albumBackgroundView);
        }];
    }
    
    return _albumBackgroundView;
}

- (void)dealloc { DMLogFunc }

@end
