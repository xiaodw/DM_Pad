#import "DMSycBrowseView.h"
#import "DMCourseFileCell.h"

#define kcourseCellID @"course"
#define kCornerRadius 20

@interface DMSycBrowseView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UILabel *indexLabel;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *whiteBoardButton;

@end

@implementation DMSycBrowseView

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    if (currentIndexPath.row >= self.allCoursewares.count) return;
    NSMutableArray *reloadIndexPath = [NSMutableArray array];
    if (_currentIndexPath) [reloadIndexPath addObject:_currentIndexPath];
    _currentIndexPath = currentIndexPath;
    [reloadIndexPath addObject:_currentIndexPath];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:currentIndexPath];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadItemsAtIndexPaths:reloadIndexPath];
}

- (void)setAllCoursewares:(NSArray *)allCoursewares {
    _allCoursewares = allCoursewares;

    _currentIndexPath = nil;
    _indexLabel.text = [NSString stringWithFormat:@"1/%d", (int)allCoursewares.count];
    [self.collectionView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DMColor33(1);
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.indexLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.whiteBoardButton];
}

- (void)setupMakeLayoutSubviews {
    [_indexLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(20*2);
        make.left.equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [_whiteBoardButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.size.equalTo(_indexLabel);
        make.centerY.equalTo(self);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_indexLabel.mas_right).offset(22);
        make.right.equalTo(_whiteBoardButton.mas_left).offset(-22);
        make.top.bottom.equalTo(self);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allCoursewares.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcourseCellID forIndexPath:indexPath];
    cell.editorMode = NO;
    if (!_currentIndexPath) self.currentIndexPath = indexPath;
    cell.showBorder = _currentIndexPath == indexPath;
    cell.courseModel = self.allCoursewares[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _currentIndexPath.row) return;
    NSArray *reloadIndexPath = @[_currentIndexPath, indexPath];
    _currentIndexPath = indexPath;
    [self.collectionView reloadItemsAtIndexPaths:reloadIndexPath];
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%d", (int)indexPath.row + 1, (int)self.allCoursewares.count];
    
    if (![self.delegate respondsToSelector:@selector(sycBrowseView:didTapIndexPath:)])return;
    [self.delegate sycBrowseView:self didTapIndexPath:indexPath];
}

- (void)didTapWhiteBoard {
    if (![self.delegate respondsToSelector:@selector(sycBrowseViewDidTapWhiteBoard:)])return;
    [self.delegate sycBrowseViewDidTapWhiteBoard:self];
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [UILabel new];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.font = DMFontPingFang_Light(12);
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.layer.cornerRadius = kCornerRadius;
        _indexLabel.layer.borderWidth = 1;
        _indexLabel.layer.borderColor = DMColorWithRGBA(255, 255, 255, 0.07).CGColor;
    }
    
    return _indexLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // collectionView.prefetchingEnabled = NO;
        _collectionView.bounces = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.userInteractionEnabled = YES;
        _collectionView.backgroundColor = DMColor33(1);
        [_collectionView registerClass:[DMCourseFileCell class] forCellWithReuseIdentifier:kcourseCellID];
    }
    
    return _collectionView;
}


- (UIButton *)whiteBoardButton {
    if (!_whiteBoardButton) {
        _whiteBoardButton = [UIButton new];
        _whiteBoardButton.titleLabel.font = DMFontPingFang_Light(13);
        _whiteBoardButton.layer.cornerRadius = kCornerRadius;
        _whiteBoardButton.layer.borderWidth = 1;
        _whiteBoardButton.layer.borderColor = DMColorWithRGBA(83, 83, 83, 1).CGColor;
        _whiteBoardButton.backgroundColor = DMColorWithRGBA(22, 22, 22, 1);
        [_whiteBoardButton setTitle:@"白板" forState: UIControlStateNormal];
        [_whiteBoardButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_whiteBoardButton addTarget:self action:@selector(didTapWhiteBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _whiteBoardButton;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
