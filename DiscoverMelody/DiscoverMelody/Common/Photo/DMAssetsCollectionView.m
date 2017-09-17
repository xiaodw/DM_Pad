#import "DMAssetsCollectionView.h"
#import "UIColor+Extension.h"
#import "DMCourseFileCell.h"
#import "DMNavigationBar.h"

#define kCoursewareCellID @"Courseware"

@interface DMAssetsCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) DMNavigationBar *navigationBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *bottomBar;
@property (strong, nonatomic) UIButton *uploadButton;

@property (strong, nonatomic) NSMutableArray *selectedAssets;

@end

@implementation DMAssetsCollectionView

- (void)setAssets:(NSArray *)assets {
    _assets = assets;
    
    [self.collectionView reloadData];
}

//    self.uploadButton.enabled = selectedCount;
//    self.uploadButton.layer.borderColor = selectedCount ?  [UIColor redColor].CGColor : [UIColor grayColor].CGColor;
//    
//    NSString *title = selectedCount > 0 ? [NSString stringWithFormat:@"传送(%zd)", selectedCount] : @"传送";
//    [self.uploadButton setTitle:title forState:UIControlStateNormal];


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.navigationBar];
    [self addSubview:self.bottomBar];
    [self addSubview:self.collectionView];
}

- (void)setupMakeLayoutSubviews {
    [_navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(64);
    }];
    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(50);
        make.left.right.equalTo(_navigationBar);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBar.mas_bottom);
        make.left.right.equalTo(_navigationBar);
        make.bottom.equalTo(_bottomBar.mas_top);
    }];
}

- (void)didTapUpload:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:didTapUploadButton:)]) return;
    
    [self.delegate albrmsCollectionView:self didTapUploadButton:sender];
}

- (void)didTapBack:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:didTapLeftButton:)]) return;
    [self.delegate albrmsCollectionView:self didTapLeftButton:sender];
}

- (void)didTapSelect:(UIButton *)sender {
    if (![self.delegate respondsToSelector:@selector(albrmsCollectionView:didTapRightButton:)]) return;
    
    [self.delegate albrmsCollectionView:self didTapRightButton:sender];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCoursewareCellID forIndexPath:indexPath];
    
    cell.asset = self.assets[indexPath.row];
    cell.backgroundColor = [UIColor randomColor];
    NSLog(@"indexPath.row: %zd", indexPath.row);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (DMScreenWidth*0.5 - 15*4) / 3;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (DMNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [DMNavigationBar new];
        
        [_navigationBar.leftBarButton addTarget:self action:@selector(didTapBack:) forControlEvents:UIControlEventTouchUpInside];
        
        _navigationBar.titleLabel.text = @"所有照片";
        
        [_navigationBar.rightBarButton setTitle:@"取消" forState:UIControlStateNormal];
        [_navigationBar.rightBarButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.prefetchingEnabled = NO;
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
        _uploadButton.enabled = NO;
        [_uploadButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_uploadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [_uploadButton setTitle:@"传送" forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(didTapUpload:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _uploadButton;
}

@end
