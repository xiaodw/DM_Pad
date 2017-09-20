#import "DMBrowseCourseController.h"
#import "DMBrowseCourseFlowLayout.h"
#import "DMButton.h"
#import "DMBrowseCourseCell.h"
#import "DMLiveController.h"

#define kBrowseCourseCellID @"BrowseCourse"
@interface DMBrowseCourseController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *deletedView;
@property (strong, nonatomic) DMButton *deletedButton;

@end

@implementation DMBrowseCourseController

- (void)setCourses:(NSMutableArray *)courses {
    _courses = courses;
    
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
}

- (void)didTapDeleted {
    if (![self.browseDelegate respondsToSelector:@selector(browseCourseController:deleteIndexPath:)]) return;
    
    [self.browseDelegate browseCourseController:self deleteIndexPath:self.currentIndexPath];
    if (self.courses.count == 0) {
        [self.liveVC.presentVCs removeObject:self];
        self.liveVC = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.courses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMBrowseCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrowseCourseCellID forIndexPath:indexPath];
    cell.courseModel = self.courses[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.liveVC.presentVCs removeObject:self];
    self.liveVC = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x / self.collectionView.dm_width + 0.5); // 约等于
    self.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSLog(@"%@", self.currentIndexPath);
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.deletedView];
    [self.view addSubview:self.collectionView];
}

- (void)setupMakeLayoutSubviews {
    [_deletedView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.bottom.equalTo(_deletedView.mas_top).offset(-40);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DMBrowseCourseFlowLayout *layout = [[DMBrowseCourseFlowLayout alloc] init];
        layout.contentOffset = CGPointMake(self.itemSize.width * self.currentIndexPath.row, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.itemSize;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.prefetchingEnabled = NO;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[DMBrowseCourseCell class] forCellWithReuseIdentifier:kBrowseCourseCellID];
    }
    
    return _collectionView;
}

- (UIView *)deletedView {
    if (!_deletedView) {
        _deletedView = [UIView new];
        _deletedView.backgroundColor = DMColorWithRGBA(38, 38, 38, 1);
        
        _deletedButton = [DMNotHighlightedButton new];
        _deletedButton.titleAlignment = DMTitleButtonTypeBottom;
        [_deletedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deletedButton.titleLabel.font = DMFontPingFang_Light(12);
        [_deletedButton setTitle:DMTitleDeleted forState:UIControlStateNormal];
        [_deletedButton setImage:[UIImage imageNamed:@"c_delete_normal"] forState:UIControlStateNormal];
        [_deletedButton addTarget:self action:@selector(didTapDeleted) forControlEvents:UIControlEventTouchUpInside];
        [_deletedView addSubview:_deletedButton];
        [_deletedButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.equalTo(_deletedView);
            make.width.equalTo(100);
        }];
    }
    
    return _deletedView;
}

- (void)dealloc {
    DMLogFunc
}

@end
