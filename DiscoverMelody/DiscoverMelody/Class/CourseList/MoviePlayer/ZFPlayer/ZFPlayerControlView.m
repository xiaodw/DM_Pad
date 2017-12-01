//
//  ZFPlayerControlView.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+CustomControlView.h"
#import "MMMaterialDesignSpinner.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

static const CGFloat ZFPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat ZFPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface ZFPlayerControlView () <UIGestureRecognizerDelegate>

/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 系统菊花 */
@property (nonatomic, strong) MMMaterialDesignSpinner *activity;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** bottomView*/
@property (nonatomic, strong) UIView                  *bottomImageView;
/** topView */
@property (nonatomic, strong) UIView                  *topImageView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playeBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 占位图 */
@property (nonatomic, strong) UIImageView             *placeholderImageView;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;

/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;

@end

@implementation ZFPlayerControlView

- (instancetype)init {
    self = [super init];
    if (self) {

        [self addSubview:self.placeholderImageView];
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.progressView];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.topImageView addSubview:self.backBtn];
        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.playeBtn];
        [self addSubview:self.failBtn];
        
        [self addSubview:self.fastView];
        [self.fastView addSubview:self.fastImageView];
        [self.fastView addSubview:self.fastTimeLabel];
        [self.fastView addSubview:self.fastProgressView];
        self.fastView.hidden = YES;

        [self.topImageView addSubview:self.titleLabel];
        [self addSubview:self.bottomProgressView];
        
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        // 初始化时重置controlView
        [self zf_playerResetControlView];
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];

        [self listeningRotating];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - Action

/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTap:)]) {
            [self.delegate zf_controlView:self progressSliderTap:tapValue];
        }
    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

- (void)backBtnClick:(UIButton *)sender {
    [self.delegate zf_controlView:self backAction:sender];
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.showing = NO;
    [self zf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:lockScreenAction:)]) {
        [self.delegate zf_controlView:self lockScreenAction:sender];
    }
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
        [self.delegate zf_controlView:self playAction:sender];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:fullScreenAction:)]) {
        [self.delegate zf_controlView:self fullScreenAction:sender];
    }
}

- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self zf_playerResetControlView];
    [self zf_playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(zf_controlView:repeatPlayAction:)]) {
        [self.delegate zf_controlView:self repeatPlayAction:sender];
    }
}

- (void)downloadBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:downloadVideoAction:)]) {
        [self.delegate zf_controlView:self downloadVideoAction:sender];
    }
}

- (void)centerPlayBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:cneterPlayAction:)]) {
        [self.delegate zf_controlView:self cneterPlayAction:sender];
    }
}

- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:failAction:)]) {
        [self.delegate zf_controlView:self failAction:sender];
    }
}

- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self zf_playerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zf_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderValueChanged:)]) {
        [self.delegate zf_controlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zf_controlView:self progressSliderTouchEnded:sender];
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    [self zf_playerCancelAutoFadeOutControlView];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    //if (!self.isShrink) { [self zf_playerShowControlView]; }
}

- (void)playerPlayDidEnd {
    self.backgroundColor  = RGBA(0, 0, 0, .6);
    self.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.showing = NO;
    // 延迟隐藏controlView
    [self zf_playerShowControlView];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    //if (!self.isShrink && !self.isPlayEnd && !self.showing) {
        // 显示、隐藏控制层
        //[self zf_playerShowOrHideControlView];
    //}
}

#pragma mark - Private Method

- (void)showControlView {
    self.showing = YES;

    self.topImageView.alpha    = 1;
    self.bottomImageView.alpha = 1;
    
    self.backgroundColor           = RGBA(0, 0, 0, 0.3);
    self.bottomProgressView.alpha  = 0;
    ZFPlayerShared.isStatusBarHidden = NO;
}

- (void)hideControlView {
    self.showing = NO;
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.topImageView.alpha       = self.playeEnd;
    self.bottomImageView.alpha    = 0;
    self.bottomProgressView.alpha = 1;
    ZFPlayerShared.isStatusBarHidden = YES;
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(zf_playerHideControlView) object:nil];
    [self performSelector:@selector(zf_playerHideControlView) withObject:nil afterDelay:ZFPlayerAnimationTimeInterval];
}

/**
 slider滑块的bounds
 */
- (CGRect)thumbRect {
    return [self.videoSlider thumbRectForBounds:self.videoSlider.bounds
                                      trackRect:[self.videoSlider trackRectForBounds:self.videoSlider.bounds]
                                          value:self.videoSlider.value];
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = DMFontPingFang_Medium(16);//[UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"";
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.alpha                  = 0.9;
        _topImageView.backgroundColor        = UIColorFromRGB(0x212121);
    }
    return _topImageView;
}

- (UIView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.alpha                  = 0.9;
        _bottomImageView.backgroundColor        = UIColorFromRGB(0x212121);
    }
    return _bottomImageView;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:@"video_play_small_icon"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"video_pause_icon"] forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (ASValueTrackingSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;

        //[_videoSlider setThumbImage:ZFPlayerImage(@"ZFPlayer_slider") forState:UIControlStateNormal];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"slider_thumb_point"] forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = DMColorBaseMeiRed;//[UIColor redColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        //_videoSlider.thumbTintColor = DMColorBaseMeiRed;
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:[UIImage imageNamed:@"video_replay_icon"] forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}

- (UIButton *)playeBtn {
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:[UIImage imageNamed:@"video_play_icon"] forState:UIControlStateNormal];
        //[_playeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_playeBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:DMTitleVedioRetry forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failBtn;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = RGBA(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.userInteractionEnabled = YES;
    }
    return _placeholderImageView;
}

- (UIProgressView *)bottomProgressView {
    if (!_bottomProgressView) {
        _bottomProgressView                   = [[UIProgressView alloc] init];
        _bottomProgressView.progressTintColor = DMColorBaseMeiRed;//[UIColor whiteColor];
        _bottomProgressView.trackTintColor    = [UIColor clearColor];
    }
    return _bottomProgressView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.videoSlider];
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}

#pragma mark - Public method

/** 重置ControlView */
- (void)zf_playerResetControlView {
    [self.activity stopAnimating];
    self.videoSlider.value           = 0;
    self.bottomProgressView.progress = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.fastView.hidden             = YES;
    self.repeatBtn.hidden            = YES;
    self.playeBtn.hidden             = YES;
    self.failBtn.hidden              = YES;
    self.backgroundColor             = [UIColor clearColor];

    self.showing                     = NO;
    self.playeEnd                    = NO;

    self.failBtn.hidden              = YES;
    self.placeholderImageView.alpha  = 1;
    [self hideControlView];
}

- (void)zf_playerResetControlViewForResolution {
    self.fastView.hidden        = YES;
    self.repeatBtn.hidden       = YES;

    self.playeBtn.hidden        = YES;

    self.failBtn.hidden         = YES;
    self.backgroundColor        = [UIColor clearColor];
 
    self.showing                = NO;
    self.playeEnd               = NO;
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)zf_playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/** 设置播放模型 */
- (void)zf_playerModel:(ZFPlayerModel *)playerModel {

    if (playerModel.title) { self.titleLabel.text = playerModel.title; }
    // 设置网络占位图片
    if (playerModel.placeholderImageURLString) {
        [self.placeholderImageView setImageWithURLString:playerModel.placeholderImageURLString placeholder:ZFPlayerImage(@"ZFPlayer_loading_bgView")];
    } else {
        self.placeholderImageView.image = playerModel.placeholderImage;
    }
}

/** 正在播放（隐藏placeholderImageView） */
- (void)zf_playerItemPlaying {
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}

- (void)zf_playerShowOrHideControlView {
    if (self.isShowing) {
        [self zf_playerHideControlView];
    } else {
        [self zf_playerShowControlView];
    }
}

- (void)zf_playerShowTopControlView {
    self.showing = YES;
    
    self.topImageView.alpha    = 1;
    
    self.backgroundColor           = RGBA(0, 0, 0, 0.3);
    self.bottomProgressView.alpha  = 0;
    ZFPlayerShared.isStatusBarHidden = NO;
}

/**
 *  显示控制层
 */
- (void)zf_playerShowControlView {
    if ([self.delegate respondsToSelector:@selector(zf_controlViewWillShow:isFullscreen:)]) {
        [self.delegate zf_controlViewWillShow:self isFullscreen:NO];
    }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
}

/**
 *  隐藏控制层
 */
- (void)zf_playerHideControlView {
    if ([self.delegate respondsToSelector:@selector(zf_controlViewWillHidden:isFullscreen:)]) {
        [self.delegate zf_controlViewWillHidden:self isFullscreen:YES];
    }
    [self zf_playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:ZFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/** 小屏播放 */
- (void)zf_playerBottomShrinkPlay {
    [self hideControlView];
}

- (void)zf_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    NSInteger proHou = currentTime / 3600;//当前小时
    NSInteger proMin = (currentTime % 3600)  / 60;//当前秒
    NSInteger proSec = (currentTime % 3600)  % 60;//当前分钟
    // duration 总时长
    NSInteger durHou = totalTime / 3600; //总小时
    NSInteger durMin = (totalTime % 3600) / 60;//总秒
    NSInteger durSec = (totalTime % 3600) % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", proHou, proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd:%02zd",durHou, durMin, durSec];
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proHou = draggedTime / 3600;//当前小时
    NSInteger proMin = (draggedTime % 3600) / 60;//当前秒
    NSInteger proSec = (draggedTime % 3600) % 60;//当前分钟
    
    // duration 总时长
    NSInteger durHou = totalTime / 3600; //总小时
    NSInteger durMin = (totalTime % 3600) / 60;//总秒
    NSInteger durSec = (totalTime % 3600) % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", proHou, proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", durHou, durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
    self.bottomProgressView.progress  = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    
    //设计需求不需要显示fastView，所以注释掉了
    self.fastView.hidden = YES;//preview
//    if (forawrd) {
//        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_forward");
//    } else {
//        self.fastImageView.image = ZFPlayerImage(@"ZFPlayer_fast_backward");
//    }
//    self.fastView.hidden           = preview;
//    self.fastTimeLabel.text        = timeStr;
//    self.fastProgressView.progress = draggedValue;

}

- (void)zf_playerDraggedEnd {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutControlView];
}

- (void)zf_playerDraggedTime:(NSInteger)draggedTime sliderImage:(UIImage *)image; {
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    [self.videoSlider setImage:image];
    [self.videoSlider setText:currentTimeStr];
    self.fastView.hidden = YES;
}

/** progress显示缓冲进度 */
- (void)zf_playerSetProgress:(CGFloat)progress {
    [self.progressView setProgress:progress animated:NO];
}

/** 视频加载失败 */
- (void)zf_playerItemStatusFailed:(NSError *)error {
    self.failBtn.hidden = NO;
}

/** 加载的菊花 */
- (void)zf_playerActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];
    }
}

/** 播放完了 */
- (void)zf_playerPlayEnd {
    self.repeatBtn.hidden = NO;
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    ZFPlayerShared.isStatusBarHidden = NO;
    self.bottomProgressView.alpha = 0;
}

/** 播放按钮状态 */
- (void)zf_playerPlayBtnState:(BOOL)state {
    self.startBtn.selected = state;
    if (!state) {
        self.playeBtn.hidden = NO;
    } else {
        self.playeBtn.hidden = YES;
    }
}


- (void)makeSubViewsConstraints {
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(15);
        make.top.equalTo(self.topImageView.mas_top).offset(20);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right).offset(10);
        make.right.equalTo(self.topImageView.mas_right).offset(-54);
        make.bottom.mas_equalTo(self.topImageView).offset(0);
        make.top.equalTo(self.topImageView.mas_top).offset(20);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(0);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(0);
        make.width.height.mas_equalTo(70);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(54);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-25);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(54);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(69);
        make.center.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    
    [self.bottomProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
}


@end
