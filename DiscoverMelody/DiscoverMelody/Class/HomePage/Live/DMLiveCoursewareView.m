#import "DMLiveCoursewareView.h"
#import "DMLiveCoursewareCell.h"
#import "DMSendSignalingMsg.h"
#import "DMLiveVideoManager.h"
#import "DMSycBrowseView.h"
#import "DMWhiteBoardControl.h"
#import "DMSlider.h"
#import "DMColorsView.h"

#define kCoursewareCellID @"Courseware"

@interface DMLiveCoursewareView() <UICollectionViewDelegate, UICollectionViewDataSource, DMSycBrowseViewDelegate, DMWhiteBoardControlDelegate, DMColorsViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DMSycBrowseView *sycBrowseView;
@property (strong, nonatomic) DMWhiteBoardControl *whiteBoardControl;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) DMSlider *slider;
@property (strong, nonatomic) DMColorsView *colorsView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation DMLiveCoursewareView

- (void)setAllCoursewares:(NSArray *)allCoursewares {
    _allCoursewares = allCoursewares;
    
    [self.collectionView reloadData];
    self.sycBrowseView.allCoursewares = allCoursewares;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
        
        NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
        self.closeButton.hidden = !userIdentity;
    }
    return self;
}

- (void)didTapClose {
    DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:DMTitleCloseSync message:DMTitleCloseSyncMessage preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleCancel otherTitle:DMTitleOK, nil];
    [alert showWithViewController:(UIViewController *)self.delegate IndexBlock:^(NSInteger index) {
        if (index == 1) { // 右侧
            NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_End_Syn sourceData:nil index:0];
            [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
                if (![self.delegate respondsToSelector:@selector(liveCoursewareViewDidTapClose:)]) return;
                [self.delegate liveCoursewareViewDidTapClose:self];
            } faile:^(NSString *messageID, AgoraEcode ecode) {
                
            }];
        }
    }];
}

- (void)didTapLineWidth:(DMSlider *)slider {
    NSLog(@"%s", __func__);
//    _drawView.lineWidth = slider.value;
}

- (void)didTapAction:(DMSlider *)slider {
    NSLog(@"%s", __func__);
//    [self didTapLineWidth:slider];
}

- (void)didTapBackground {
    [self.colorsView removeFromSuperview];
    [self.slider removeFromSuperview];
    [_imageView removeFromSuperview];
    self.backgroundView.hidden = YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allCoursewares.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMLiveCoursewareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCoursewareCellID forIndexPath:indexPath];
    cell.model = self.allCoursewares[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x / self.collectionView.dm_width + 0.5); // 约等于
    
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_Turn_Page sourceData:[self.allCoursewares mutableCopy] index:index];
    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
        
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        
    }];
    self.sycBrowseView.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
}

#pragma mark - DMSycBrowseViewDelegate
- (void)sycBrowseViewDidTapWhiteBoard:(DMSycBrowseView *)sycBrowseView {
    NSLog(@"%s", __func__);
    [UIView animateWithDuration:0.25 animations:^{
        _whiteBoardControl.alpha = 1;
        _sycBrowseView.alpha = 0;
    }];
}

- (void)sycBrowseView:(DMSycBrowseView *)sycBrowseView didTapIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - DMWhiteBoardControlDelegate
- (void)whiteBoardControlDidTapClean:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
}

- (void)whiteBoardControlDidTapUndo:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
}

- (void)whiteBoardControlDidTapForward:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
}

- (void)whiteBoardControl:(DMWhiteBoardControl *)whiteBoardControl didTapBrushButton:(UIButton *)button {
    NSLog(@"%s", __func__);
    
    [self setupMakeLayoutPoperViews:button toView:self.slider];
}

- (void)setupMakeLayoutPoperViews:(UIView *)button toView:(UIView *)toView {
    self.backgroundView.hidden = NO;
    CGFloat height = 268;
    CGFloat width = 50;
    
    [_backgroundView addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
        make.width.equalTo(width);
        make.bottom.equalTo(self.whiteBoardControl.mas_top).offset(-10);
        make.centerX.equalTo(button);
    }];
    
    [self layoutIfNeeded];
    CGFloat offset = 0;
    CGSize size = CGSizeMake(width, height);
    if ([toView isKindOfClass:[DMSlider class]]) {
        offset = -3;
        height = height - 20;
        size = CGSizeMake(height, width);
        toView.layer.position = CGPointMake(_imageView.center.x, _imageView.center.y);
    }
    [self.backgroundView addSubview:toView];
    [toView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imageView.mas_centerY).offset(offset);
        make.centerX.equalTo(_imageView);
        make.size.equalTo(size);
    }];
}

- (void)whiteBoardControl:(DMWhiteBoardControl *)whiteBoardControl didTapColorsButton:(UIButton *)button {
    NSLog(@"%s", __func__);
    [self setupMakeLayoutPoperViews:button toView:self.colorsView];
}

- (void)whiteBoardControlDidTapClose:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
    [UIView animateWithDuration:0.25 animations:^{
        _whiteBoardControl.alpha = 0;
        _sycBrowseView.alpha = 1;
    }];
}

#pragma mark - DMColorsViewDelegate
- (void)colorsView:(DMColorsView *)colorsView didTapColr:(UIColor *)color {
    self.whiteBoardControl.lineColor = color;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.sycBrowseView];
    [self addSubview:self.collectionView];
    [self addSubview:self.closeButton];
    [self addSubview:self.whiteBoardControl];
    [self addSubview:self.backgroundView];
}

- (void)setupMakeLayoutSubviews {
    [_sycBrowseView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(80);
    }];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(_sycBrowseView.mas_top);
    }];
    
    [_closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 30));
        make.top.equalTo(40);
        make.right.equalTo(self.mas_right).offset(-23);
    }];
    
    [_whiteBoardControl makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_sycBrowseView);
    }];
    [_backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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

- (DMSycBrowseView *)sycBrowseView {
    if (!_sycBrowseView) {
        _sycBrowseView = [DMSycBrowseView new];
        _sycBrowseView.delegate = self;
    }
    
    return _sycBrowseView;
}

- (DMWhiteBoardControl *)whiteBoardControl {
    if (!_whiteBoardControl) {
        _whiteBoardControl = [DMWhiteBoardControl new];
        _whiteBoardControl.delegate = self;
        _whiteBoardControl.alpha = 0;
    }
    
    return _whiteBoardControl;
}

- (DMSlider *)slider {
    if (!_slider) {
        _slider = [DMSlider new];
        _slider.minimumValue = 1;
        _slider.maximumValue = 5;
        _slider.value = 3;
        [_slider addTarget:self action:@selector(didTapLineWidth:) forControlEvents:UIControlEventTouchUpInside];
        [_slider dm_addTarget:self action:@selector(didTapAction:) forControlEvents:DMControlEventTouchUpInside];
        _slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    
    return _slider;
}

- (DMColorsView *)colorsView {
    if (!_colorsView) {
        _colorsView = [DMColorsView new];
        _colorsView.delegate = self;
        
        UIColor *redColor = [UIColor redColor];
        UIColor *yellowColor = [UIColor yellowColor];
        UIColor *greenColor = [UIColor greenColor];
        UIColor *blueColor = [UIColor blueColor];
        UIColor *blackColor = [UIColor blackColor];
        UIColor *whiteColor = [UIColor whiteColor];
        _colorsView.colors = @[redColor, yellowColor, greenColor, blueColor, blackColor, whiteColor];
    }
    
    return _colorsView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.hidden = YES;
         UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground)];
        
        _backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"opover_background"];
    }
    
    return _backgroundView;
}

- (void)dealloc {
    DMLogFunc
}

@end
