#import "DMAssetsCollectionView.h"
#import "UIColor+Extension.h"
#import "DMCourseFileCell.h"
#import "DMNavigationBar.h"
#import "DMAsset.h"
#import "DMAlbum.h"
#import "DMBrowseView.h"
#import "DMBOSClientManager.h"

#define kCoursewareCellID @"Courseware"
#define kPhotoColums 4

@interface DMAssetsCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *backgroundCloseView;
@property (strong, nonatomic) DMNavigationBar *navigationBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *bottomBar;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) DMBrowseView *uploadBrowseView;

@property (strong, nonatomic) NSMutableArray *selectedAssets;;
@property (strong, nonatomic) NSMutableArray *selectedIndexPath;
@property (strong, nonatomic) NSArray *assets;
@property (strong, nonatomic) DMBOSClientManager *bosManager;

@property (strong, nonatomic) NSMutableArray *successAssets;
@property (strong, nonatomic) NSMutableArray *fieldAssets;

@end

@implementation DMAssetsCollectionView

#pragma mark - Set Methods
- (void)setAlbum:(DMAlbum *)album {
    _assets = album.assets;
    
    [self.collectionView reloadData];
    self.navigationBar.titleLabel.text = album.name;
    if (_assets.count == 0) return;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_assets.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

#pragma mark - Lifecycle Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

#pragma mark - AddSubviews
- (void)setupMakeAddSubviews {
    [self addSubview:self.backgroundCloseView];
    [self addSubview:self.uploadBrowseView];
    [self addSubview:self.backgroundView];
    [self addSubview:self.navigationBar];
    [self addSubview:self.collectionView];
    [self addSubview:self.bottomBar];
}

#pragma mark - LayoutSubviews
- (void)setupMakeLayoutSubviews {
    [_backgroundCloseView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
    
    [_navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(DMScreenWidth*0.5);
        make.height.equalTo(64);
    }];
    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(50);
        make.left.right.equalTo(_navigationBar);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBar.mas_bottom);
        make.left.equalTo(15);
        make.right.equalTo(_navigationBar.mas_right).offset(-15);
        make.bottom.equalTo(_bottomBar.mas_top);
    }];
    
    [_uploadBrowseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
}

#pragma mark - uploadPhotos
- (void)uploadPhotos:(NSMutableArray *)surplus {
    WS(weakSelf)
    NSMutableArray *surplusPhotos = [surplus mutableCopy];
    if (surplusPhotos.count == 0) {
         [DMActivityView hideActivity];
        if (self.fieldAssets.count == 0) {
            [self.delegate albrmsCollectionView:weakSelf success:weakSelf.successAssets];
            return;
        }
        
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:DMTitleUploadFail message:DMTitleUploadFailMessage preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleNO otherTitle:DMTitleYes, nil];
        [alert showWithViewController:(UIViewController *)self.delegate IndexBlock:^(NSInteger index) {
            if (index == 1) { // 右侧
                [DMActivityView showActivity:weakSelf];
                [weakSelf uploadPhotos:weakSelf.fieldAssets];
                return;
            }
            [weakSelf.delegate albrmsCollectionView:weakSelf success:weakSelf.successAssets];
        }];
        return;
    }
    
    DMAsset *asset = surplusPhotos.firstObject;
    asset.status = DMAssetStatusUploading;
    [self.uploadBrowseView refrenshAssetStatus:asset];
    [surplusPhotos removeObject:asset];
    NSData *imgData = UIImageJPEGRepresentation(asset.fullResolutionImage, 1.0);
    [self.bosManager startUploadFileToBD:self.lessonID formatType:DMFormatUploadFileType_FileData fileData:imgData filePath:nil fileExt:@".png" angle:(UIImageOrientation)asset.orientation];
    
    self.bosManager.blockUploadFailed = ^(NSError *error) {
        asset.status = DMAssetStatusFail;
        [weakSelf.uploadBrowseView refrenshAssetStatus:asset];
        [weakSelf uploadPhotos:surplusPhotos];
    };
    
    self.bosManager.blockUploadSuccess = ^(BOOL result, DMClassFileDataModel *obj) {
        asset.status = DMAssetStatusSuccess;
        [weakSelf.successAssets addObject:obj];
        [weakSelf.fieldAssets removeObject:asset];
        [weakSelf.uploadBrowseView refrenshAssetStatus:asset];
        [weakSelf uploadPhotos:surplusPhotos];
    };
}

#pragma mark - Functions
- (void)didTapUpload:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:success:)]) return;
    [DMActivityView showActivity:self];
    [self uploadPhotos:self.selectedAssets];
}

- (void)didTapBack:(UIButton *)sender {
    
    [self reinstateSelectedCpirses];
    [self.uploadBrowseView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:didTapLeftButton:)]) return;
        [self.delegate albrmsCollectionView:self didTapLeftButton:sender];
    }];
}

- (void)didTapSelect:(UIButton *)sender {
    if (self.selectedAssets.count) {
        [self.uploadBrowseView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutSubviews];
        } completion:^(BOOL finished) {
            if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:didTapRightButton:)]) return;
            [self.delegate albrmsCollectionView:self didTapRightButton:sender];
        }];
        return;
    }
    
    
    if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:didTapRightButton:)]) return;
    [self.delegate albrmsCollectionView:self didTapRightButton:sender];
}

- (void)didTapBackground {
    if (self.selectedAssets.count) return;
    [self didTapSelect:_navigationBar.rightBarButton];
}

- (void)reinstateSelectedCpirses {
    for (int i = 0; i < self.selectedAssets.count; i++) {
        DMAsset *asset = self.selectedAssets[i];
        asset.selectedIndex = 0;
        asset.isSelected = NO;
    }
    _selectedAssets = nil;
    _selectedIndexPath = nil;
    self.uploadButton.selected = NO;
}

- (void)reSetSelectedCpirsesIndex {
    for (int i = 0; i < self.selectedAssets.count; i++) {
        DMAsset *asset = self.selectedAssets[i];
        asset.selectedIndex = i+1;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCoursewareCellID forIndexPath:indexPath];
    
    cell.editorMode = YES;
    cell.asset = self.assets[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (DMScreenWidth*0.5 - 15*(kPhotoColums+1)) / kPhotoColums;
    CGFloat height = width;

    return CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseFileCell *cell = (DMCourseFileCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectedAssets containsObject:cell.asset]) {
        [self.selectedAssets removeObject:cell.asset];
        [self.selectedIndexPath removeObject:indexPath];
        cell.asset.selectedIndex = 0;
        cell.asset.isSelected = NO;
        [self reSetSelectedCpirsesIndex];
    } else {
        if(self.selectedAssets.count == kMaxUploadPhotoCount) {
            DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:nil message:[NSString stringWithFormat:DMTitleUploadCount, kMaxUploadPhotoCount] preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleOK otherTitle: nil];
            [alert showWithViewController:(UIViewController *)self.delegate IndexBlock:^(NSInteger index){}];
         return;
        }
        
        [self.selectedAssets addObject:cell.asset];
        [self.selectedIndexPath addObject:indexPath];
        cell.asset.selectedIndex = self.selectedAssets.count;
        cell.asset.isSelected = YES;
    }
    
    cell.asset = cell.asset;
    [self.collectionView reloadData];
    
    NSInteger selectedCount = self.selectedAssets.count;
    self.uploadButton.enabled = selectedCount;
    self.uploadButton.backgroundColor = selectedCount ? DMColorBaseMeiRed : DMColorWithRGBA(221, 221, 221, 1);
    
    NSString *title = selectedCount > 0 ? [NSString stringWithFormat:DMTitlePhotoUploadCount, selectedCount] : DMTitlePhotoUpload;
    [self.uploadButton setTitle:title forState:UIControlStateNormal];
    
    if (selectedCount == 0) {
        [self.uploadBrowseView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutSubviews];
        } completion:^(BOOL finished) {
            self.uploadBrowseView.courses = self.selectedAssets;
        }];
        return;
    }
    
    self.uploadBrowseView.courses = self.selectedAssets;
    if (selectedCount == 1) {
        [self.uploadBrowseView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navigationBar.mas_right);
            make.top.bottom.equalTo(self);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
         
        [UIView animateWithDuration:0.15 animations:^{
            [self layoutSubviews];
        }];
    }
}

#pragma mark - Lazy
- (DMNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [DMNavigationBar new];
        
        [_navigationBar.leftBarButton setTitle:DMTitlePhoto forState:UIControlStateNormal];
        [_navigationBar.leftBarButton addTarget:self action:@selector(didTapBack:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar.rightBarButton setTitle:DMTitleCancel forState:UIControlStateNormal];
        [_navigationBar.rightBarButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_navigationBar.rightBarButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _navigationBar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf6f6f6);
// _collectionView.prefetchingEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[DMCourseFileCell class] forCellWithReuseIdentifier:kCoursewareCellID];
    }
    return _collectionView;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor whiteColor];
        
        _bottomBar.layer.shadowColor = [UIColor blackColor].CGColor; // shadowColor阴影颜色
        _bottomBar.layer.shadowOffset = CGSizeMake(-3,-7); // shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
        _bottomBar.layer.shadowOpacity = 0.03; // 阴影透明度，默认0
        _bottomBar.layer.shadowRadius = 7; // 阴影半径，默认3
        
        [_bottomBar addSubview:self.uploadButton];
        [_uploadButton makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bottomBar);
            make.size.equalTo(CGSizeMake(60, 30));
        }];
    }
    
    return _bottomBar;
}

- (UIButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [UIButton new];
        _uploadButton.layer.cornerRadius = 5;
        _uploadButton.enabled = NO;
        _uploadButton.titleLabel.font = DMFontPingFang_Regular(14);
        _uploadButton.backgroundColor = DMColorWithRGBA(221, 221, 221, 1);
        [_uploadButton setTitleColor:DMColorWithHexString(@"#999999") forState:UIControlStateDisabled];
        [_uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_uploadButton setTitle:DMTitlePhotoUpload forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(didTapUpload:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _uploadButton;
}

- (DMBrowseView *)uploadBrowseView {
    if (!_uploadBrowseView) {
        _uploadBrowseView = [DMBrowseView new];
        _uploadBrowseView.browseType = DMBrowseViewTypeUpload;
    }
    
    return _uploadBrowseView;
}

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    
    return _selectedAssets;
}

- (NSMutableArray *)selectedIndexPath {
    if (!_selectedIndexPath) {
        _selectedIndexPath = [NSMutableArray array];
    }
    
    return _selectedIndexPath;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    }
    
    return _backgroundView;
}

- (UIView *)backgroundCloseView {
    if (!_backgroundCloseView) {
        _backgroundCloseView = [UIView new];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)];
        [_backgroundCloseView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _backgroundCloseView;
}

- (DMBOSClientManager *)bosManager {
    if (!_bosManager) {
        _bosManager = [DMBOSClientManager shareInstance];
    }
    
    return _bosManager;
}

- (NSMutableArray *)fieldAssets {
    if (!_fieldAssets) {
        _fieldAssets = [NSMutableArray array];
        [_fieldAssets addObjectsFromArray:self.selectedAssets];
    }
    
    return _fieldAssets;
}

- (NSMutableArray *)successAssets {
    if (!_successAssets) {
        _successAssets = [NSMutableArray array];
    }
    
    return _successAssets;
}

@end
