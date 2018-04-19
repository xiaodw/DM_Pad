#import "DMLiveCoursewareView.h"
#import "DMLiveCoursewareCell.h"
#import "DMSendSignalingMsg.h"
#import "DMLiveVideoManager.h"
#import "DMSycBrowseView.h"
#import "DMWhiteBoardControl.h"
#import "DMSlider.h"
#import "DMColorsView.h"
#import "DMWhiteBoardView.h"

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
@property (strong, nonatomic) DMWhiteBoardView *whiteBoardView;

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
    WS(weakSelf)
    [alert showWithViewController:(UIViewController *)self.delegate IndexBlock:^(NSInteger index) {
        if (index == 1) { // 右侧
            NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_End_Syn sourceData:nil synType:DMSignalingMsgSynCourse];
            [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
                if (![weakSelf.delegate respondsToSelector:@selector(liveCoursewareViewDidTapClose:)]) return;
                [weakSelf.delegate liveCoursewareViewDidTapClose:weakSelf];
            } faile:^(NSString *messageID, AgoraEcode ecode) {
                
            }];
        }
    }];
}

//- (void)didTapLineWidth:(DMSlider *)slider {
//    NSLog(@"%s   ----- %f", __func__, slider.value);
//    _whiteBoardView.lineWidth = slider.value;
//}
//
//- (void)didTapAction:(DMSlider *)slider {
//    NSLog(@"%s", __func__);
//    [self didTapLineWidth:slider];
//}

- (void)cleanWhiteBoard {
    [_whiteBoardView clean];
}

- (void)didTapBackground {
    _whiteBoardView.lineWidth = self.slider.value;
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
    if (index >= self.allCoursewares.count) return;
    
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_Turn_Page sourceData:@[self.allCoursewares[index]] synType:DMSignalingMsgSynCourse];
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
    } completion:^(BOOL finished) {
        _whiteBoardView.hidden = NO;
        _whiteBoardView.userInteractionEnabled = YES;
    }];
}

- (void)sycBrowseView:(DMSycBrowseView *)sycBrowseView didTapIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.allCoursewares.count) return;
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_Turn_Page sourceData:@[self.allCoursewares[indexPath.row]] synType:DMSignalingMsgSynCourse];
    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
        
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        
    }];
}

#pragma mark - DMWhiteBoardControlDelegate
- (void)whiteBoardControlDidTapClean:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
    [self cleanWhiteBoard];
}

- (void)whiteBoardControlDidTapUndo:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
    [_whiteBoardView undo];
}

- (void)whiteBoardControlDidTapForward:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
    [_whiteBoardView forward];
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
    } completion:^(BOOL finished) {
        _whiteBoardView.hidden = YES;
        _whiteBoardView.userInteractionEnabled = NO;
        [self cleanWhiteBoard];
    }];
}

#pragma mark - DMColorsViewDelegate
- (void)colorsView:(DMColorsView *)colorsView didTapColr:(UIColor *)color strHex:(NSString *)strHex {
    _whiteBoardControl.lineColor = color;
    _whiteBoardView.hexString = strHex;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.sycBrowseView];
    [self addSubview:self.collectionView];
    [self addSubview:self.closeButton];
    [self addSubview:self.whiteBoardControl];
    [self addSubview:self.whiteBoardView];
    [self addSubview:self.backgroundView];
}

- (void)setupMakeLayoutSubviews {
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue];
    CGFloat bheight = userIdentity ? 80 : 0; // 0: 学生, 1: 老师
    [_sycBrowseView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(bheight);
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
    
    [_whiteBoardView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.collectionView);
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
        _sycBrowseView.hidden = ![[DMAccount getUserIdentity] integerValue];
        _sycBrowseView.delegate = self;
    }
    
    return _sycBrowseView;
}

- (DMWhiteBoardControl *)whiteBoardControl {
    if (!_whiteBoardControl) {
        _whiteBoardControl = [DMWhiteBoardControl new];
        _whiteBoardControl.hidden = ![[DMAccount getUserIdentity] integerValue];
        _whiteBoardControl.delegate = self;
        _whiteBoardControl.alpha = 0;
    }
    
    return _whiteBoardControl;
}

- (DMSlider *)slider {
    if (!_slider) {
        _slider = [DMSlider new];
        _slider.minimumValue = 1;
        _slider.maximumValue = 4;
        _slider.value = (_slider.minimumValue + _slider.maximumValue) * 0.5;
//        [_slider addTarget:self action:@selector(didTapLineWidth:) forControlEvents:UIControlEventTouchUpInside];
//        [_slider dm_addTarget:self action:@selector(didTapAction:) forControlEvents:DMControlEventTouchUpInside];
        _slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    
    return _slider;
}

- (DMColorsView *)colorsView {
    if (!_colorsView) {
        _colorsView = [DMColorsView new];
        _colorsView.delegate = self;
        // 红, 黄, 绿, 蓝, 黑, 白
        _colorsView.colors = @[@"ff0000", @"#ffff00", @"#00ff00", @"#00a0e9", @"#000000", @"#ffffff"];
    }
    
    return _colorsView;
}

- (DMWhiteBoardView *)whiteBoardView {
    if (!_whiteBoardView) {
        _whiteBoardView = [DMWhiteBoardView new];
        _whiteBoardView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
        _whiteBoardView.userInteractionEnabled = NO;
        _whiteBoardView.hidden = [[DMAccount getUserIdentity] integerValue];
    }
    
    return _whiteBoardView;
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
