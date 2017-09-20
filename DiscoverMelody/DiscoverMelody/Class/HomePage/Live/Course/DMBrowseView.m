#import "DMBrowseView.h"
#import "DMBrowseCourseController.h"
#import "DMCourseFileCell.h"
#import "DMBrowseCourseCell.h"
#import "DMButton.h"
#import "DMAsset.h"

#define kBrowseCourseCellID @"BrowseCourse" // 大ID
#define kcourseCellID @"Course2" // 小ID

@interface DMBrowseView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) DMButton *syncButton;
@property (strong, nonatomic) UIView *colBackgroundView;
@property (strong, nonatomic) UICollectionView *browsecollectionView; // 大图
@property (strong, nonatomic) UICollectionView *collectionView; // 小图
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation DMBrowseView

- (void)setBrowseType:(DMBrowseViewType)browseType {
    _browseType = browseType;
    
    if (self.browseType == DMBrowseViewTypeUpload) {
        _syncButton.hidden = YES;
        [_syncButton remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(0.01);
        }];
    }
}

- (void)setCourses:(NSArray *)courses {
    _courses = courses;
    [self.browsecollectionView reloadData];
    [self.collectionView reloadData];
    
    if (courses.count == 0) return;
    self.currentIndexPath = [NSIndexPath indexPathForRow:courses.count-1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self.browsecollectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.browsecollectionView];
    [self addSubview:self.colBackgroundView];
    [self addSubview:self.collectionView];
    [self addSubview:self.syncButton];
}

- (void)setupMakeLayoutSubviews {
    [_syncButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(50);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(_syncButton.mas_top).offset(-15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(80);
    }];
    
    [_browsecollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.bottom.equalTo(_syncButton.mas_top).offset(-15);
        make.left.equalTo(40);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    
    [_colBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView.mas_top).offset(-15);
        make.bottom.equalTo(_syncButton.mas_top);
        make.left.right.equalTo(_collectionView);
    }];
}

- (void)didTapSync {
    if (![self.delegate respondsToSelector:@selector(browseViewDidTapSync:)]) return;
    
    [self.delegate browseViewDidTapSync:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.courses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 大
    if (collectionView == self.browsecollectionView) {
        DMBrowseCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrowseCourseCellID forIndexPath:indexPath];
        if (self.browseType == DMBrowseViewTypeUpload) {
            cell.asset = self.courses[indexPath.row];
        }
        else if (self.browseType == DMBrowseViewTypeSync) {
            cell.courseModel = self.courses[indexPath.row];
        }
        return cell;
    }
    
    // 小
    DMCourseFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcourseCellID forIndexPath:indexPath];
    cell.editorMode = YES;
    if (self.browseType == DMBrowseViewTypeUpload) {
        cell.asset = self.courses[indexPath.row];
    }
    else if (self.browseType == DMBrowseViewTypeSync) {
        cell.courseModel = self.courses[indexPath.row];
    }
    
    if (!_currentIndexPath) _currentIndexPath = indexPath;
    cell.showBorder = _currentIndexPath == indexPath;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.browsecollectionView) {
        return;
    }
    
    [self.browsecollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    _currentIndexPath = indexPath;
    [self.collectionView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) return;
    
    NSInteger index = (scrollView.contentOffset.x / self.browsecollectionView.dm_width + 0.5); // 约等于
    self.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (DMButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [DMNotHighlightedButton new];
        _syncButton.titleAlignment = DMTitleButtonTypeLeft;
        _syncButton.spacing = 8;
        _syncButton.backgroundColor = [UIColor whiteColor];
        _syncButton.titleLabel.font = DMFontPingFang_Regular(16);
        _syncButton.layer.borderColor = DMColorWithRGBA(239, 239, 239, 1).CGColor;
        _syncButton.layer.borderWidth = 0.5;
        [_syncButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_syncButton setTitle:DMTitleImmediatelySync forState:UIControlStateNormal];
        [_syncButton setImage:[UIImage imageNamed:@"btn_arrow_right_red"] forState:UIControlStateNormal];
        [_syncButton addTarget:self action:@selector(didTapSync) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _syncButton;
}

- (UICollectionView *)setupCollectionView:(UICollectionViewFlowLayout *)layout {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.prefetchingEnabled = NO;
    collectionView.bounces = NO;
    collectionView.scrollsToTop = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    return collectionView;
}

- (UICollectionView *)browsecollectionView {
    if (!_browsecollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat width = DMScreenWidth * 0.5 - 80;
        CGFloat height = DMScreenHeight - 64 - 50;
        
        layout.itemSize = CGSizeMake(width, height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _browsecollectionView = [self setupCollectionView:layout];
        _browsecollectionView.pagingEnabled = YES;
        [_browsecollectionView registerClass:[DMBrowseCourseCell class] forCellWithReuseIdentifier:kBrowseCourseCellID];
    }
    
    return _browsecollectionView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(80, 80);
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 15;
        _collectionView = [self setupCollectionView:layout];
        [_collectionView registerClass:[DMCourseFileCell class] forCellWithReuseIdentifier:kcourseCellID];
    }
    
    return _collectionView;
}

- (UIView *)colBackgroundView {
    if (!_colBackgroundView) {
        _colBackgroundView = [UIView new];
        _colBackgroundView.backgroundColor = [DMColorWithHexString(@"#212121") colorWithAlphaComponent:0.8];
    }
    
    return _colBackgroundView;
}

@end
