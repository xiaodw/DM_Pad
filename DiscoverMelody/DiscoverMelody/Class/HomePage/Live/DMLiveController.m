#import "DMLiveController.h"
#import "DMLiveButtonControlView.h"
#import "DMLiveVideoManager.h"
#import "DMButton.h"
#import "DMLiveWillStartView.h"
#import "NSString+Extension.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>


#define kSmallSize CGSizeMake(DMScaleWidth(240), DMScaleHeight(180))

#define kBeforeClassTimeMinute 5 // 5分钟
#define kBeforeClassTimeSecond (kBeforeClassTimeMinute*60) // 5分钟
#define kAfterClassMaxTimeMinute 15 // 15分钟
#define kAfterClassMaxTimeSecond (kAfterClassMaxTimeMinute*60) // 15分钟

// 布局模式
typedef NS_ENUM(NSInteger, DMLayoutMode) {
    DMLayoutModeRemoteAndSmall, // 远端大, 本地小模式
    DMLayoutModeSmallAndRemote, // 本地大, 远端小模式
    DMLayoutModeAveragDistribution, //课件模式 And 左右模式
    DMLayoutModeAll // 全部模式
};

@interface DMLiveController () <DMLiveButtonControlViewDelegate>

#pragma mark - UI
@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager; // 声网SDK Manager
@property (strong, nonatomic) UIView *remoteView; // 远端窗口
@property (strong, nonatomic) UIImageView *remoteVoiceImageView; // 远端声音的view
@property (strong, nonatomic) UIImageView *remotePlaceholderView; // 远端没有人占位图
@property (strong, nonatomic) UILabel *remotePlaceholderTitleLabel; // 远端没有人占位图远端说明

@property (strong, nonatomic) UIView *localView; // 本地窗口
@property (strong, nonatomic) UIImageView *localVoiceImageView; // 本地声音的view
@property (strong, nonatomic) UIImageView *localPlaceholderView; // 本地没有人占位图
@property (strong, nonatomic) UILabel *localPlaceholderTitleLabel; // 本地没有人占位图远端说明

@property (strong, nonatomic) DMLiveButtonControlView *controlView; // 左侧按钮们
@property (strong, nonatomic) UIImageView *shadowImageView;
@property (strong, nonatomic) UIImageView *shadowRightImageView;
@property (strong, nonatomic) UIView *timeView; // 底部时间条
@property (strong, nonatomic) DMButton *timeButton; // 底部时间条: 图标
@property (strong, nonatomic) UILabel *alreadyTimeLabel; // 底部时间条: 过了多少时间
@property (strong, nonatomic) UILabel *describeTimeLabel; // 底部时间条: 提示
@property (strong, nonatomic) DMLiveWillStartView *willStartView; // 即将开始的View

#pragma mark - Other
@property (nonatomic, strong) dispatch_source_t timer; // 1秒中更新一次时间UI
@property (strong, nonatomic) NSArray *animationImages; // 声音动画所有的图片
@property (assign, nonatomic) NSInteger tapLayoutCount; // 点击布局按钮次数
@property (assign, nonatomic) BOOL isCoursewareMode; // 是否是课件布局模式
@property (assign, nonatomic) DMLayoutMode beforeLayoutMode; // 课件布局模式之前的模式

#pragma mark - 临时变量做测试用
@property (strong, nonatomic) NSDate *startDate;
@property (assign, nonatomic) NSInteger lectureTotalSecond;
@property (assign, nonatomic) NSInteger userIdentity; // 0: 学生, 1: 老师

@end

@implementation DMLiveController

- (void)setupServerData {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    _startDate = [formater dateFromString:@"2017-09-12 09:30:00"];
    _lectureTotalSecond = 45 * 60;
    _userIdentity = 0;
    
    self.remotePlaceholderTitleLabel.text = _userIdentity == 1 ? @"学生尚未进入课堂" : @"老师尚未进入课堂";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupServerData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    //
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoTapped)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self joinChannel];
    
    [self.liveVideoManager switchSound:NO block:nil];
    
#warning 移动到API 返回之后启动
    [self timer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)remoteVideoTapped {
    [UIView animateWithDuration:0.15 animations:^{
        self.controlView.alpha = self.controlView.alpha == 1 ? 0 : 1;;
    }];
}

- (void)joinChannel {
    WS(weakSelf)
    [self.liveVideoManager startLiveVideo:self.localView remote:self.remoteView isTapVideo:YES blockAudioVolume:^(NSInteger totalVolume, NSArray *speakers) {
        if (speakers.count == 0) return;
        
        for (int i = 0; i < speakers.count; i++) {
            AgoraRtcAudioVolumeInfo *volumeInfo = speakers[i];
            // uid 为 0 说明是自己
            if (volumeInfo.uid == 0) {
                if (volumeInfo.volume <= 0) return;
                // self make animation
                [weakSelf.localVoiceImageView startAnimating];
                return;
            }
            
            if (volumeInfo.volume > 0) {
                [weakSelf.remoteVoiceImageView startAnimating];
            }
        }
    } blockTapVideoEvent:^(DMLiveVideoViewType type) {
        if (weakSelf.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) return;
        if (DMLiveVideoViewType_Local == type) {
            [weakSelf didTapLocal];
            return;
        }
        [weakSelf didTapRemote];
        return;
    }];
    
    //接收信令同步的消息，完成同步功能
    [self.liveVideoManager onSignalingMessageReceive:^(NSString *account, NSString *msg) {
        NSLog(@"接收到来自 %@，的超级好消息 %@", account , msg);
    }];
}

#pragma mark - 左侧按钮们点击
// 离开
- (void)liveButtonControlViewDidTapLeave:(DMLiveButtonControlView *)liveButtonControlView {
    WS(weakSelf)
    [self.liveVideoManager quitLiveVideo:^(BOOL success) {
        [weakSelf.navigationVC popViewControllerAnimated:YES];
    }];
}

// 切换摄像头
- (void)liveButtonControlViewDidTapSwichCamera:(DMLiveButtonControlView *)liveButtonControlView {
    [self.liveVideoManager switchCamera];
}

// 切换布局
- (void)liveButtonControlViewDidTapSwichLayout:(DMLiveButtonControlView *)liveButtonControlView {
    [self makeLayoutViews];
}

// 课件
- (void)liveButtonControlViewDidTapCourseFiles:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
    _isCoursewareMode = !_isCoursewareMode;
    if (_isCoursewareMode) _beforeLayoutMode = self.tapLayoutCount-1 % DMLayoutModeAll;
    
    self.tapLayoutCount = _isCoursewareMode ? 1 : _beforeLayoutMode;
    [self makeLayoutViews];
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.remoteView];
    [self.view addSubview:self.shadowRightImageView];
    [self.view addSubview:self.localView];
    [self.view addSubview:self.shadowImageView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.remoteVoiceImageView];
    [self.view addSubview:self.localVoiceImageView];
    
    [self.remoteView addSubview:self.remotePlaceholderView];
    [self.remoteView addSubview:self.remotePlaceholderTitleLabel];
    [self.localView addSubview:self.localPlaceholderView];
    [self.localView addSubview:self.localPlaceholderTitleLabel];
    
    [self.view addSubview:self.willStartView];
}

- (void)setupMakeLayoutSubviews {
    WS(weakSelf)
    [_controlView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.view);
        make.width.equalTo(225);
    }];
    
    [_shadowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.controlView);
    }];
    
    [_shadowRightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.shadowImageView);
    }];
    
    [_timeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(23);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-18);
        make.height.equalTo(20);
        make.right.equalTo(weakSelf.view);
    }];
    
    [_remoteView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [_localView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(kSmallSize);
        make.top.right.equalTo(weakSelf.view);
    }];
    
    [_remoteVoiceImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.remoteView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(weakSelf.remoteView.mas_bottom).offset(-20);
    }];
    
    [_localVoiceImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.localView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(weakSelf.localView.mas_bottom).offset(-20);
    }];
    
    [_remotePlaceholderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(290);
        make.size.equalTo(CGSizeMake(154, 154));
        make.centerX.equalTo(weakSelf.remoteView);
    }];
    
    [_remotePlaceholderTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.remotePlaceholderView.mas_bottom).offset(45);
        make.centerX.equalTo(weakSelf.remotePlaceholderView);
    }];
    
    [_localPlaceholderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(49);
        make.size.equalTo(CGSizeMake(42, 46));
        make.centerX.equalTo(weakSelf.localView);
    }];
    
    [_localPlaceholderTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.localPlaceholderView.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.localPlaceholderView);
    }];
    
    [_willStartView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.equalTo(CGSizeMake(406, 406));
    }];
}

- (void)didTapRemote {
    self.tapLayoutCount = DMLayoutModeAveragDistribution;
    [self makeLayoutViews];
}

- (void)didTapLocal {
    self.tapLayoutCount = DMLayoutModeRemoteAndSmall;
    [self makeLayoutViews];
}

- (DMLiveVideoManager *)liveVideoManager {
    if (!_liveVideoManager) {
        _liveVideoManager = [DMLiveVideoManager shareInstance];
    }
    
    return _liveVideoManager;
}

- (void)computTime {
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [formater stringFromDate:currentDate];
    // 截止时间data格式
    currentDate = [formater dateFromString:currentDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:self.startDate toDate:currentDate options:0];
    // 2个时间的时间差
    NSInteger timeDifference = [currentDate timeIntervalSinceDate:_startDate];
    self.remotePlaceholderView.hidden = timeDifference < 0;
    self.remotePlaceholderTitleLabel.hidden = timeDifference < 0;
    
    // 做几分钟开课操作
    if (timeDifference < 0) {
        self.willStartView.willStartDescribeLabel.text = [NSString stringWithFormat:@"距离上课时间还有%zd分钟", -dateCom.minute + 1];
        return;
    }
    [_willStartView removeFromSuperview];
    _willStartView = nil;
    _timeView.hidden = NO;
    NSString *hour = [[NSString stringWithFormat:@"%zd",dateCom.hour] stringByPaddingLeftWithString:@"0" total:2];
    NSString *minute = [[NSString stringWithFormat:@"%zd",dateCom.minute] stringByPaddingLeftWithString:@"0" total:2];
    NSString *second = [[NSString stringWithFormat:@"%zd",dateCom.second] stringByPaddingLeftWithString:@"0" total:2];
    NSString *alreadyTime = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    self.alreadyTimeLabel.text = alreadyTime;
    
    if (0 < timeDifference && timeDifference < _lectureTotalSecond - kBeforeClassTimeSecond) {
        return;
    }
    
    /* 一节课按t=45分钟算 */
    // 40 < t < 45
    if (timeDifference > _lectureTotalSecond - kBeforeClassTimeSecond && timeDifference < _lectureTotalSecond) {
        _timeButton.selected = YES;
        _alreadyTimeLabel.textColor = DMColorBaseMeiRed;
        return;
    }
    
    // 45 < t < 60
    if (timeDifference > _lectureTotalSecond && timeDifference/60 < _lectureTotalSecond/60 + kAfterClassMaxTimeMinute) {
        _describeTimeLabel.text = [NSString stringWithFormat:@"本课堂将于%zd分钟后自动关闭", (kAfterClassMaxTimeMinute-(timeDifference/60-_lectureTotalSecond/60))];
        return;
    }
    
    //  t >= 60，视频聊天强制退出
    if (timeDifference >= _lectureTotalSecond + kAfterClassMaxTimeSecond) {
        [self invalidate];
        [self liveButtonControlViewDidTapLeave:nil];
        return;
    }
}

- (dispatch_source_t)timer {
    if (!_timer) {
        // 获得队列
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        
        // 创建一个定时器(dispatch_source_t本质还是个OC对象)
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
        // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
        // 何时开始执行第一个任务
        // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
        dispatch_source_set_timer(_timer, start, interval, 0);
        
        // 设置回调
        WS(weakSelf)
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf computTime];
            });
            
        });
        dispatch_resume(_timer);
    }
    return _timer;
}

- (void)invalidate {
    if (!_timer) return;
    dispatch_source_cancel(_timer);
    _timer = nil;
}

- (NSArray *)animationImages {
    if (!_animationImages) {
        NSMutableArray *images = [NSMutableArray array];
        NSString *iconName = @"icon_microphone_%d.png";
        for (int i = 0; i < 5; i++) {
            NSString *resource = [NSString stringWithFormat:iconName,i];
            UIImage *image = [UIImage imageNamed:resource];
            [images addObject:image];
        }
        
        _animationImages = images;
    }
    
    return _animationImages;
}

- (UIImageView *)remotePlaceholderView {
    if (!_remotePlaceholderView) {
        _remotePlaceholderView = [UIImageView new];
        _remotePlaceholderView.image = [UIImage imageNamed:@"icon_notEnter"];
    }
    
    return _remotePlaceholderView;
}

- (UILabel *)remotePlaceholderTitleLabel {
    if (!_remotePlaceholderTitleLabel) {
        _remotePlaceholderTitleLabel = [UILabel new];
        _remotePlaceholderTitleLabel.textColor = DMColor102;
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(20);
    }
    
    return _remotePlaceholderTitleLabel;
}

- (UIImageView *)localPlaceholderView {
    if (!_localPlaceholderView) {
        _localPlaceholderView = [UIImageView new];
        _localPlaceholderView.image = [UIImage imageNamed:@"icon_unturnedCamera"];
    }
    
    return _localPlaceholderView;
}

- (UILabel *)localPlaceholderTitleLabel {
    if (!_localPlaceholderTitleLabel) {
        _localPlaceholderTitleLabel = [UILabel new];
        _localPlaceholderTitleLabel.textColor = DMColor102;
        _localPlaceholderTitleLabel.text = @"您的摄像头未开启";
        _localPlaceholderTitleLabel.font = DMFontPingFang_Light(16);
    }
    
    return _localPlaceholderTitleLabel;
}

- (UIImageView *)setupVoiceImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = self.animationImages.firstObject;
    imageView.animationRepeatCount = 1;
    imageView.animationDuration = 0.35;
    imageView.animationImages = self.animationImages;
    
    return imageView;
}

- (UIImageView *)remoteVoiceImageView {
    if (!_remoteVoiceImageView) {
        _remoteVoiceImageView = [self setupVoiceImageView];
    }
    
    return _remoteVoiceImageView;
}

- (UIImageView *)localVoiceImageView {
    if (!_localVoiceImageView) {
        _localVoiceImageView = [self setupVoiceImageView];
    }
    
    return _localVoiceImageView;
}

- (UIView *)remoteView {
    if (!_remoteView) {
        _remoteView = [UIView new];
        _remoteView.backgroundColor = [UIColor blackColor];
        _remoteView.userInteractionEnabled = NO;
    }
    
    return _remoteView;
}

- (UIView *)localView {
    if (!_localView) {
        _localView = [UIView new];
        _localView.backgroundColor = [UIColor blackColor];
    }
    
    return _localView;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [UIImageView new];
        _shadowImageView.image = [UIImage imageNamed:@"image_shadow"];
    }
    
    return _shadowImageView;
}


- (UIImageView *)shadowRightImageView {
    if (!_shadowRightImageView) {
        _shadowRightImageView = [UIImageView new];
        _shadowRightImageView.image = [UIImage imageNamed:@"image_shadowRigthToLeft"];
    }
    
    return _shadowRightImageView;
}

- (DMLiveButtonControlView *)controlView {
    if (!_controlView) {
        _controlView = [DMLiveButtonControlView new];
        _controlView.delegate = self;
    }
    
    return _controlView;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [UIView new];
        _timeView.hidden = YES;
        
        [_timeView addSubview:self.timeButton];
        [_timeView addSubview:self.alreadyTimeLabel];
        [_timeView addSubview:self.describeTimeLabel];
        
        [_timeButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(_timeView);
            make.size.equalTo(CGSizeMake(19, 19));
        }];
        
        [_alreadyTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeButton.mas_right).offset(10);
            make.centerY.equalTo(_timeButton);
        }];
        
        [_describeTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(106);
            make.centerY.equalTo(_timeButton);
        }];
    }
    
    return _timeView;
}

- (DMButton *)timeButton {
    if (!_timeButton) {
        _timeButton = [DMNotHighlightedButton new];
        [_timeButton setImage:[UIImage imageNamed:@"icon_time_white"] forState:UIControlStateNormal];
        [_timeButton setImage:[UIImage imageNamed:@"icon_time_red"] forState:UIControlStateSelected];
    }
    
    return _timeButton;
}

- (UILabel *)alreadyTimeLabel {
    if (!_alreadyTimeLabel) {
        _alreadyTimeLabel = [UILabel new];
        _alreadyTimeLabel.textColor = [UIColor whiteColor];
        _alreadyTimeLabel.font = DMFontPingFang_Light(14);
    }
    
    return _alreadyTimeLabel;
}

- (UILabel *)describeTimeLabel {
    if (!_describeTimeLabel) {
        _describeTimeLabel = [UILabel new];
        _describeTimeLabel.textColor = DMColorBaseMeiRed;
        _describeTimeLabel.font = DMFontPingFang_Light(14);
    }
    
    return _describeTimeLabel;
}

- (DMLiveWillStartView *)willStartView {
    if (!_willStartView) {
        _willStartView = [DMLiveWillStartView new];
    }
    
    return _willStartView;
}

- (void)dealloc {
    [self invalidate];
    DMLogFunc
}

- (void)makeLayoutViews {
    self.tapLayoutCount += 1;
    [_localView removeFromSuperview];
    [_remoteView removeFromSuperview];
    
    self.remotePlaceholderView.hidden = self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteAndSmall;
    self.remotePlaceholderTitleLabel.hidden = self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteAndSmall;
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteAndSmall) { // 远端大, 本地小模式
        [self.view insertSubview:_localView atIndex:0];
        [self.view insertSubview:_remoteView atIndex:0];
        
        [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_localView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.view);
            make.size.equalTo(kSmallSize);
        }];
        
        [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(290);
            make.size.equalTo(CGSizeMake(154, 154));
            make.centerX.equalTo(_remoteView);
        }];
        
        [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(45);
            make.centerX.equalTo(_remotePlaceholderView);
        }];
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(20);
        
        _localView.userInteractionEnabled = YES;
        _remoteView.userInteractionEnabled = NO;
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeSmallAndRemote) { // 本地大, 远端小模式
        [self.view insertSubview:_remoteView atIndex:0];
        [self.view insertSubview:_localView atIndex:0];
        
        [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(self.view);
            make.size.equalTo(kSmallSize);
        }];
        
        [_localView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(52);
            make.size.equalTo(CGSizeMake(45, 45));
            make.centerX.equalTo(_remoteView);
        }];
        
        [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(15);
            make.centerX.equalTo(_remotePlaceholderView);
        }];
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(16);
        _localView.userInteractionEnabled = NO;
        _remoteView.userInteractionEnabled = YES;
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) {
        [self.view insertSubview:_remoteView atIndex:0];
        [self.view insertSubview:_localView atIndex:0];
        if (_isCoursewareMode) { // 上下
            [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, DMScreenHeight * 0.5));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.left.equalTo(_remoteView);
                make.bottom.equalTo(self.view);
            }];
            
            
            [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(290);
                make.size.equalTo(CGSizeMake(154, 154));
                make.centerX.equalTo(_remoteView);
            }];
            
            [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(45);
                make.centerX.equalTo(_remotePlaceholderView);
            }];
        }else { // 左右
            [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, 385));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.centerY.equalTo(_remoteView);
                make.right.equalTo(self.view);
            }];
            
            [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(95);
                make.size.equalTo(CGSizeMake(154, 154));
                make.centerX.equalTo(_remoteView);
            }];
            
            [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(39);
                make.centerX.equalTo(_remotePlaceholderView);
            }];
            _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(16);
        }
        _localView.userInteractionEnabled = NO;
        _remoteView.userInteractionEnabled = NO;
    }
    
    [_remoteVoiceImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remoteView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_remoteView.mas_bottom).offset(-20);
    }];
    
    [_localVoiceImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_localView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_localView.mas_bottom).offset(-20);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
    }];
}

@end
