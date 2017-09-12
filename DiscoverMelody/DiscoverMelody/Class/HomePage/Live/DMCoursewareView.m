#import "DMCoursewareView.h"

#define kCoursewareCellID @"Courseware"

@interface DMCoursewareView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation DMCoursewareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCoursewareCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
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
        layout.itemSize = CGSizeMake(DMScreenWidth*0.5, DMScreenHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(DMScreenWidth*0.5, 0, DMScreenWidth*0.5, DMScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCoursewareCellID];
    }
    
    return _collectionView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    return _closeButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        [_rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    return _rightButton;
}

@end
