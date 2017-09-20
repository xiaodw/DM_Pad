#import "DMLiveCoursewareView.h"
#import "DMLiveCoursewareCell.h"

#define kCoursewareCellID @"Courseware"

@interface DMLiveCoursewareView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation DMLiveCoursewareView

- (void)setAllCoursewares:(NSArray *)allCoursewares {
    _allCoursewares = allCoursewares;
    
    [self.collectionView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
        
        NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
        self.closeButton.hidden = userIdentity;
        self.leftButton.hidden = userIdentity;
        self.rightButton.hidden = userIdentity;
    }
    return self;
}

- (void)didTapClose {
    if (![self.delegate respondsToSelector:@selector(liveCoursewareViewDidTapClose:)]) return;
    [self.delegate liveCoursewareViewDidTapClose:self];
}

static bool currentTurnPage = false;
- (void)didTapTurnPage:(UIButton *)sender {
    if (currentTurnPage) return;
    currentTurnPage = true;
    self.collectionView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        currentTurnPage = false;
        self.collectionView.userInteractionEnabled = YES;
    });
    NSInteger index = self.collectionView.contentOffset.x / self.dm_width + (sender == self.leftButton ? - 1 : 1);
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allCoursewares.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMLiveCoursewareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCoursewareCellID forIndexPath:indexPath];
    cell.model = self.allCoursewares[indexPath.row];
    
    _leftButton.hidden = indexPath.row == 0;
    _rightButton.hidden = indexPath.row == self.allCoursewares.count-1;
    
    return cell;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.collectionView];
    [self addSubview:self.closeButton];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
}

- (void)setupMakeLayoutSubviews {
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 30));
        make.top.equalTo(18);
        make.right.equalTo(self.mas_right).offset(-23);
    }];
    
    CGFloat leftMargin = (DMScreenWidth * 0.5 - 40 * 2 - 82) * 0.5;
    [_leftButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftMargin);
        make.size.equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.mas_bottom).offset(-27);
    }];
    
    [_rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftButton.mas_right).offset(82);
        make.size.bottom.equalTo(_leftButton);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(DMScreenWidth*0.5, DMScreenHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
#warning iOS10 属性
        _collectionView.prefetchingEnabled = NO;
        [_collectionView registerClass:[DMLiveCoursewareCell class] forCellWithReuseIdentifier:kCoursewareCellID];
    }
    
    return _collectionView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didTapClose) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImage imageNamed:@"icon_previous_arrow"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(didTapTurnPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        [_rightButton setImage:[UIImage imageNamed:@"icon_next_arrow"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(didTapTurnPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightButton;
}

- (void)dealloc {
    DMLogFunc
}

@end
