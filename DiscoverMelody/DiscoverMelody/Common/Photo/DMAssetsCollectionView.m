#import "DMAssetsCollectionView.h"
#import "UIColor+Extension.h"
#import "DMCourseFileCell.h"
#import "DMNavigationBar.h"
#import "DMAsset.h"
#import "DMAlbum.h"
#import "DMBrowseView.h"

#define kCoursewareCellID @"Courseware"

@interface DMAssetsCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) DMNavigationBar *navigationBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *bottomBar;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) DMBrowseView *uploadBrowseView;

@property (strong, nonatomic) NSMutableArray *selectedAssets;;
@property (strong, nonatomic) NSMutableArray *selectedIndexPath;
@property (strong, nonatomic) NSArray *assets;

@end

@implementation DMAssetsCollectionView

- (void)setAlbum:(DMAlbum *)album {
    _assets = album.assets;
    
    [self.collectionView reloadData];
    self.navigationBar.titleLabel.text = album.name;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.uploadBrowseView];
    [self addSubview:self.backgroundView];
    [self addSubview:self.navigationBar];
    [self addSubview:self.bottomBar];
    [self addSubview:self.collectionView];
}

- (void)setupMakeLayoutSubviews {
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
        make.top.equalTo(_navigationBar.mas_bottom).offset(15);
        make.left.equalTo(15);
        make.right.equalTo(_navigationBar.mas_right).offset(-15);
        make.bottom.equalTo(_bottomBar.mas_top);
    }];
    [_uploadBrowseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
}

- (void)didTapUpload:(UIButton *)sender {
#warning 发送API 然后通知控制器就可以了
    if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:didTapUploadButton:)]) return;
    
    [self.delegate albrmsCollectionView:self didTapUploadButton:sender];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCoursewareCellID forIndexPath:indexPath];
    
    cell.editorMode = YES;
    cell.asset = self.assets[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (DMScreenWidth*0.5 - 15*4) / 3;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

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
    self.uploadButton.layer.borderColor = selectedCount ?  DMColorBaseMeiRed.CGColor : DMColorWithRGBA(221, 221, 221, 1) .CGColor;
    
    NSString *title = selectedCount > 0 ? [NSString stringWithFormat:@"传送(%zd)", selectedCount] : @"传送";
    [self.uploadButton setTitle:title forState:UIControlStateNormal];
    
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
        return;
    }
    
    if (selectedCount == 0) {
        [self.uploadBrowseView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutSubviews];
        }];
    }
}

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
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _collectionView.prefetchingEnabled = NO;
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
        _uploadButton.layer.borderWidth = 1;
        _uploadButton.layer.cornerRadius = 5;
        _uploadButton.layer.borderColor = DMColorWithRGBA(221, 221, 221, 1) .CGColor;
        _uploadButton.enabled = NO;
        _uploadButton.titleLabel.font = DMFontPingFang_Regular(14);
        [_uploadButton setTitleColor:DMColorWithRGBA(204, 204, 204, 204) forState:UIControlStateDisabled];
        [_uploadButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        
        [_uploadButton setTitle:DMTitlePhotoUpload forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(didTapUpload:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _uploadButton;
}

- (DMBrowseView *)uploadBrowseView {
    if (!_uploadBrowseView) {
        _uploadBrowseView = [DMBrowseView new];
        _uploadBrowseView.backgroundColor = [UIColor clearColor];
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

@end
