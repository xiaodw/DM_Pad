#import "DMLiveCoursewareView.h"
#import "DMLiveCoursewareCell.h"
#import "DMSendSignalingMsg.h"
#import "DMLiveVideoManager.h"
#import "DMSycBrowseView.h"
#import "DMWhiteBoardControl.h"
#import "DMSlider.h"
#import "DMColorsView.h"
#import "DMWhiteBoardView.h"
#import "DMBrushWidthView.h"

#define kConstNumber 80

#define kCoursewareCellID @"Courseware"

#define ksliderMinWidth 2
#define ksliderMaxWidth 15

@interface DMLiveCoursewareView() <UICollectionViewDelegate, UICollectionViewDataSource, DMSycBrowseViewDelegate, DMWhiteBoardControlDelegate, DMColorsViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DMSycBrowseView *sycBrowseView;
@property (strong, nonatomic) DMWhiteBoardControl *whiteBoardControl;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) DMBrushWidthView *sliderView;
@property (strong, nonatomic) DMSlider *slider;
@property (strong, nonatomic) DMColorsView *colorsView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) DMWhiteBoardView *whiteBoardView;

@end

@implementation DMLiveCoursewareView

- (void)setAllCoursewares:(NSArray *)allCoursewares {
    _allCoursewares = allCoursewares;
    
    [self.collectionView reloadData];
    self.sycBrowseView.allCoursewares = allCoursewares;
    
    [self didTapBackground];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DMColorWithRGBA(62, 62, 62, 1);
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

- (void)didChangeLineWidth:(DMSlider *)slider {
    NSLog(@"slider: %f", slider.value);
    CGFloat value = (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue);
    self.sliderView.value = 1-value;
}

- (void)didTapAction:(DMSlider *)slider {
    [self didChangeLineWidth:slider];
}

- (void)resetWhiteBoard {
    [self whiteBoardControlDidTapClose:self.whiteBoardControl];
}

- (void)didTapBackground { // 有个问题循环引用的问题rem之后不设置nil就会引起, 现在未解决
    _whiteBoardView.lineWidth = self.slider.value;
    [_colorsView removeFromSuperview];
    [_slider removeFromSuperview];
    [_sliderView removeFromSuperview];
    [_imageView removeFromSuperview];
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
    if (index == self.sycBrowseView.currentIndexPath.row) return;
    
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
    [_whiteBoardView clean];
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
    BOOL isSuperView = self.slider.superview;
    [self didTapBackground];
    if (isSuperView) { return; }
    [self setupMakeLayoutPoperViews:button toView:self.slider];
}

- (void)setupMakeLayoutPoperViews:(UIView *)button toView:(UIView *)toView {
    CGFloat height = 268;
    CGFloat width = 50;
    self.sliderView.hidden = ![toView isKindOfClass:[DMSlider class]];
    [self addSubview:self.imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
        make.width.equalTo(width);
        make.bottom.equalTo(self.whiteBoardControl.mas_top).offset(-10);
        make.centerX.equalTo(button);
    }];
    
    [self layoutIfNeeded];
    CGSize size = CGSizeMake(width, height);
    CGFloat offset = 0;
    if ([toView isKindOfClass:[DMSlider class]]) {
        size = CGSizeMake(height-5, width);
        toView.layer.position = CGPointMake(_imageView.center.x, _imageView.center.y);
        [self addSubview:self.sliderView];
        offset = 3;
    }
    [self addSubview:toView];
    [toView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imageView).offset(-5);
        make.centerX.equalTo(_imageView).offset(offset);
        make.size.equalTo(size);
    }];
    [self layoutIfNeeded];
    self.sliderView.frame = CGRectMake(self.imageView.dm_x + (width - ksliderMaxWidth)*0.5, self.slider.dm_y+18, ksliderMaxWidth, 233);
}

- (void)whiteBoardControl:(DMWhiteBoardControl *)whiteBoardControl didTapColorsButton:(UIButton *)button {
    NSLog(@"%s", __func__);
    BOOL isSuperView = self.colorsView.superview;
    [self didTapBackground];
    if (isSuperView) { return; }
    
    [self setupMakeLayoutPoperViews:button toView:self.colorsView];
}

- (void)whiteBoardControlDidTapClose:(DMWhiteBoardControl *)whiteBoardControl {
    NSLog(@"%s", __func__);
    [DMNotificationCenter postNotificationName:DMNotificationWhiteBoardCleanStatusKey object:nil];
    [_whiteBoardView clean];
    [self didTapBackground];
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue];
    [UIView animateWithDuration:0.25 animations:^{
        _whiteBoardControl.alpha = 0;
        _sycBrowseView.alpha = 1;
    } completion:^(BOOL finished) {
        if (userIdentity) {
            _whiteBoardView.hidden = YES;
            _whiteBoardView.userInteractionEnabled = NO;
        }
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
    [self addSubview:self.whiteBoardControl];
    [self addSubview:self.whiteBoardView];
    [self addSubview:self.closeButton];
}

- (void)setupMakeLayoutSubviews {
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue];
    
    CGFloat bheight = userIdentity ? kConstNumber : 0; // 0: 学生, 1: 老师
    CGFloat top = userIdentity ? 0 : kConstNumber * 0.5; // 0: 学生, 1: 老师
    CGFloat bottom = userIdentity ? 0 : -kConstNumber * 0.5; // 0: 学生, 1: 老师
    [_sycBrowseView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(bheight);
    }];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(top);
        make.bottom.equalTo(_sycBrowseView.mas_top).offset(bottom);
    }];
    
    [_closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 30));
        make.top.equalTo(40);
        make.right.equalTo(self.mas_right).offset(-23);
    }];
    
    [_whiteBoardControl makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_sycBrowseView);
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
        layout.itemSize = CGSizeMake(DMScreenWidth*0.5, DMScreenHeight-kConstNumber);
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
        _slider.minimumValue = ksliderMinWidth;
        _slider.maximumValue = ksliderMaxWidth;
        _slider.value = (_slider.minimumValue + _slider.maximumValue) * 0.5;
        [_slider dm_addTarget:self action:@selector(didTapAction:) forControlEvents:DMControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(didChangeLineWidth:) forControlEvents:UIControlEventValueChanged];
        _slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _slider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.003];
        _slider.minimumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.003];
        [_slider setThumbImage:[UIImage imageNamed:@"icon_slider"] forState:UIControlStateNormal];
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
        _whiteBoardView.backgroundColor = [UIColor clearColor];
        _whiteBoardView.userInteractionEnabled = NO;
        _whiteBoardView.hidden = [[DMAccount getUserIdentity] integerValue];
        WS(weakSelf)
        [_whiteBoardView setTouchesBeganBlock:^{
            [weakSelf didTapBackground];
        }];
    }
    
    return _whiteBoardView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"opover_background"];
    }
    
    return _imageView;
}

- (DMBrushWidthView *)sliderView {
    if (!_sliderView) {
        _sliderView = [DMBrushWidthView new];
    }
    
    return _sliderView;
}

- (void)dealloc {
    DMLogFunc
}

@end
