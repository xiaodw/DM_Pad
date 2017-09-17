#import "DMLiveController.h"
#import "DMButton.h"
#import "DMLiveVideoManager.h"
#import "DMLiveButtonControlView.h"
#import "DMLiveWillStartView.h"
#import "DMLiveCoursewareView.h"
#import "NSString+Extension.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "DMCourseFilesController.h"
#import "DMMicrophoneView.h"
#import "DMSecretKeyManager.h"

#define kSmallSize CGSizeMake(DMScaleWidth(240), DMScaleHeight(180))
#define kColor31 DMColorWithRGBA(33, 33, 33, 1)

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

@interface DMLiveController ()<DMLiveButtonControlViewDelegate, DMLiveCoursewareViewDelegate>

#pragma mark - UI
@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager; // 声网SDK Manager
@property (strong, nonatomic) UIView *remoteView; // 远端窗口
@property (strong, nonatomic) UIView *remoteBackgroundView; // 远端窗口
@property (strong, nonatomic) DMMicrophoneView *remoteMicrophoneView; // 远端麦克风音量
@property (strong, nonatomic) UIImageView *remotePlaceholderView; // 远端没有人占位图
@property (strong, nonatomic) UILabel *remotePlaceholderTitleLabel; // 远端没有人占位图远端说明
@property (strong, nonatomic) DMLiveCoursewareView *coursewareView; // 课件视图

@property (strong, nonatomic) UIView *localView; // 本地窗口
@property (strong, nonatomic) DMMicrophoneView *localMicrophoneView; // 本地麦克风音量
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
@property (assign, nonatomic) BOOL isRemoteUserOnline; // 远端是否上线
@property (nonatomic, strong) dispatch_source_t timer; // 1秒中更新一次时间UI
@property (assign, nonatomic) NSInteger tapLayoutCount; // 点击布局按钮次数
@property (assign, nonatomic) BOOL isCoursewareMode; // 是否是课件布局模式
@property (assign, nonatomic) DMLayoutMode beforeLayoutMode; // 课件布局模式之前的模式

#pragma mark - 临时变量做测试用
@property (strong, nonatomic) NSDate *startDate;
@property (assign, nonatomic) NSInteger lectureTotalSecond;
@property (assign, nonatomic) NSInteger userIdentity; // 0: 学生, 1: 老师

@end

@implementation DMLiveController

- (void)setIsRemoteUserOnline:(BOOL)isRemoteUserOnline {
    _isRemoteUserOnline = isRemoteUserOnline;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.remoteView.alpha = isRemoteUserOnline ? 1 : 0;;
    }];
}

- (void)setupServerData {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    _startDate = [formater dateFromString:@"2017-09-13 09:40:00"];
    _lectureTotalSecond = 45 * 60;
    _userIdentity = 0;
    
    self.remotePlaceholderTitleLabel.text = _userIdentity == 1 ? @"学生尚未进入课堂" : @"老师尚未进入课堂";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupServerData];
    
    self.view.backgroundColor = kColor31;
    [self.navigationController setNavigationBarHidden:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoTapped)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self joinChannel];
    [self setupMakeLiveCallback];
    
    
//    [self.liveVideoManager switchSound:NO block:nil];
    
#warning 移动到API 返回之后启动
    //[self timer];
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

// 远端有人回调
- (void)setupMakeLiveCallback {
    // 有用户加入
    WS(weakSelf)
    self.liveVideoManager.blockDidJoinedOfUid = ^(NSUInteger uid) {
        NSLog(@"blockDidJoinedOfUid");
        weakSelf.isRemoteUserOnline = YES;
    };
    
    // 退出直播事件
    self.liveVideoManager.blockQuitLiveVideoEvent = ^(BOOL success) {
       NSLog(@"blockQuitLiveVideoEvent");
    };
    
    // 有用户离开
    self.liveVideoManager.blockDidOfflineOfUid = ^(NSUInteger uid) {
        NSLog(@"blockDidOfflineOfUid");
        weakSelf.isRemoteUserOnline = NO;
    };
    
    // 重新加入
    self.liveVideoManager.blockDidRejoinChannel = ^(NSUInteger uid, NSString *channel) {
        NSLog(@"blockDidRejoinChannel");
        weakSelf.isRemoteUserOnline = YES;
    };
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
                weakSelf.localMicrophoneView.voiceValue = volumeInfo.volume / 255.0;
                return;
            }
            
            if (volumeInfo.volume > 0) {
                weakSelf.remoteMicrophoneView.voiceValue = volumeInfo.volume / 255.0;
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
//    [self.liveVideoManager switchCamera];
    
    if (_isCoursewareMode) return;
    _isCoursewareMode = YES;
}

// 切换布局
- (void)liveButtonControlViewDidTapSwichLayout:(DMLiveButtonControlView *)liveButtonControlView {
    [self makeLayoutViews];
}

// 课件
- (void)liveButtonControlViewDidTapCourseFiles:(DMLiveButtonControlView *)liveButtonControlView {
    DMCourseFilesController *courseFilesVC = [DMCourseFilesController new];
    courseFilesVC.transitioningDelegate = self.animationHelper;
    self.animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
    courseFilesVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:courseFilesVC animated:YES completion:nil];
    
//    [self didTapCourseFiles];
 
}

- (void)liveCoursewareViewDidTapClose:(DMLiveCoursewareView *)liveCoursewareView {
    if (!_isCoursewareMode) return;
    _isCoursewareMode = NO;
    [self didTapCourseFiles];
}

- (void)didTapCourseFiles {
    if (_isCoursewareMode) _beforeLayoutMode = self.tapLayoutCount-1 % DMLayoutModeAll;
    
    self.tapLayoutCount = _isCoursewareMode ? 1 : _beforeLayoutMode;
    [self makeLayoutViews];
    if (_isCoursewareMode) {
        [self.view addSubview:self.coursewareView];
        [_coursewareView makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self.view);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
        self.coursewareView.allCoursewares = @[@"http://f11.baidu.com/it/u=435066478,1958291651&fm=76",
                                               @"http://f12.baidu.com/it/u=108550577,1474666626&fm=76",
                                               @"http://f11.baidu.com/it/u=4245406495,4169406916&fm=76",
                                               @"http://f12.baidu.com/it/u=189212114,1570521444&fm=76",
                                               @"http://f11.baidu.com/it/u=10925524,1784854435&fm=76",
                                               @"http://f10.baidu.com/it/u=1262675490,65787803&fm=76",
                                               @"http://f11.baidu.com/it/u=435066478,1958291651&fm=76"];
    }else {
        [self.coursewareView removeFromSuperview];
        _coursewareView = nil;
    }
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.remoteBackgroundView];
    [self.remoteBackgroundView addSubview:self.remoteView];
    [self.view addSubview:self.remotePlaceholderView];
    [self.view addSubview:self.remotePlaceholderTitleLabel];
    [self.view addSubview:self.shadowRightImageView];
    [self.view addSubview:self.localView];
    [self.view addSubview:self.shadowImageView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.remoteMicrophoneView];
    [self.view addSubview:self.localMicrophoneView];
    
    [self.localView addSubview:self.localPlaceholderView];
    [self.localView addSubview:self.localPlaceholderTitleLabel];
    
    [self.view addSubview:self.willStartView];
}

- (void)setupMakeLayoutSubviews {
    [_controlView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(225);
    }];
    
    [_shadowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_controlView);
    }];
    
    [_shadowRightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.width.equalTo(_shadowImageView);
    }];
    
    [_timeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(23);
        make.bottom.equalTo(self.view.mas_bottom).offset(-18);
        make.height.equalTo(20);
        make.right.equalTo(self.view);
    }];
    
    [_remoteBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_remoteView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_remoteBackgroundView);
    }];
    
    [_localView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(kSmallSize);
        make.top.right.equalTo(self.view);
    }];
    
    [_remoteMicrophoneView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remoteView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_remoteView.mas_bottom).offset(-20);
    }];
    
    [_localMicrophoneView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_localView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_localView.mas_bottom).offset(-20);
    }];
    
    [_remotePlaceholderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(290);
        make.size.equalTo(CGSizeMake(154, 154));
        make.centerX.equalTo(_remoteView);
    }];
    
    [_remotePlaceholderTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(45);
        make.centerX.equalTo(_remotePlaceholderView);
    }];
    
    [_localPlaceholderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(49);
        make.size.equalTo(CGSizeMake(42, 46));
        make.centerX.equalTo(_localView);
    }];
    
    [_localPlaceholderTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_localPlaceholderView.mas_bottom).offset(15);
        make.centerX.equalTo(_localPlaceholderView);
    }];
    
    [_willStartView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
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
    self.remotePlaceholderView.hidden = timeDifference < 0 || _isRemoteUserOnline;
    self.remotePlaceholderTitleLabel.hidden = self.remotePlaceholderView.hidden;
    
    // 做几分钟开课操作
    if (timeDifference < 0) {
        self.willStartView.willStartDescribeLabel.text = [NSString stringWithFormat:@"距离上课时间还有%zd分钟", -dateCom.minute + 1];
        return;
    }
    if (_willStartView != nil) {
        [_willStartView removeFromSuperview];
        _willStartView = nil;
        _timeView.hidden = NO;
    }
    
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

- (DMMicrophoneView *)remoteMicrophoneView {
    if (!_remoteMicrophoneView) {
        _remoteMicrophoneView = [DMMicrophoneView new];
    }
    
    return _remoteMicrophoneView;
}

- (DMMicrophoneView *)localMicrophoneView {
    if (!_localMicrophoneView) {
        _localMicrophoneView = [DMMicrophoneView new];
    }
    
    return _localMicrophoneView;
}

- (UIView *)remoteBackgroundView {
    if (!_remoteBackgroundView) {
        _remoteBackgroundView = [UIView new];
        _remoteBackgroundView.backgroundColor = kColor31;
        _remoteBackgroundView.userInteractionEnabled = NO;
    }
    
    return _remoteBackgroundView;
}

- (UIView *)remoteView {
    if (!_remoteView) {
        _remoteView = [UIView new];
        _remoteView.backgroundColor = kColor31;
        _remoteView.userInteractionEnabled = self.remoteBackgroundView.userInteractionEnabled;
    }
    
    return _remoteView;
}

- (UIView *)localView {
    if (!_localView) {
        _localView = [UIView new];
        _localView.backgroundColor = kColor31;
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

- (DMLiveCoursewareView *)coursewareView {
    if (!_coursewareView) {
        _coursewareView = [DMLiveCoursewareView new];
        _coursewareView.delegate = self;
    }
    
    return _coursewareView;
}

- (void)dealloc {
    [self invalidate];
    DMLogFunc
}

- (void)makeLayoutViews {
    self.tapLayoutCount += 1;
    [_localView removeFromSuperview];
    [_remoteBackgroundView removeFromSuperview];
    
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteAndSmall) { // 远端大, 本地小模式
        [self.view insertSubview:_localView atIndex:0];
        [self.view insertSubview:_remoteBackgroundView atIndex:0];
        
        [_remoteBackgroundView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_localView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.view);
            make.size.equalTo(kSmallSize);
        }];
        
        [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(290);
            make.size.equalTo(CGSizeMake(154, 154));
            make.centerX.equalTo(_remoteBackgroundView);
        }];
        
        [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(45);
            make.centerX.equalTo(_remotePlaceholderView);
        }];
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(20);
        
        _localView.userInteractionEnabled = YES;
        _remoteBackgroundView.userInteractionEnabled = NO;
        _remoteView.userInteractionEnabled = _remoteBackgroundView.userInteractionEnabled;
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeSmallAndRemote) { // 本地大, 远端小模式
        [self.view insertSubview:_remoteBackgroundView atIndex:0];
        [self.view insertSubview:_localView atIndex:0];
        
        [_remoteBackgroundView remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(self.view);
            make.size.equalTo(kSmallSize);
        }];
        
        [_localView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(52);
            make.size.equalTo(CGSizeMake(45, 45));
            make.centerX.equalTo(_remoteBackgroundView);
        }];
        
        [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(15);
            make.centerX.equalTo(_remotePlaceholderView);
        }];
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(16);
        _localView.userInteractionEnabled = NO;
        _remoteBackgroundView.userInteractionEnabled = YES;
        _remoteView.userInteractionEnabled = _remoteBackgroundView.userInteractionEnabled;
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) {
        [self.view insertSubview:_remoteBackgroundView atIndex:0];
        [self.view insertSubview:_localView atIndex:0];
        if (_isCoursewareMode) { // 上下
            [_remoteBackgroundView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, DMScreenHeight * 0.5));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.left.equalTo(_remoteBackgroundView);
                make.bottom.equalTo(self.view);
            }];
            
            
            [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(100);
                make.size.equalTo(CGSizeMake(154, 154));
                make.centerX.equalTo(_remoteBackgroundView);
            }];
            
            [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(28);
                make.centerX.equalTo(_remotePlaceholderView);
            }];
        }else { // 左右
            [_remoteBackgroundView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, 385));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.centerY.equalTo(_remoteBackgroundView);
                make.right.equalTo(self.view);
            }];
            
            CGFloat remotePHVTop = (DMScreenHeight - 385) * 0.5 + 95;
            [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(remotePHVTop);
                make.size.equalTo(CGSizeMake(154, 154));
                make.centerX.equalTo(_remoteBackgroundView);
            }];
            
            [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(39);
                make.centerX.equalTo(_remotePlaceholderView);
            }];
            _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(16);
        }
        _localView.userInteractionEnabled = NO;
        _remoteBackgroundView.userInteractionEnabled = NO;
        _remoteView.userInteractionEnabled = _remoteBackgroundView.userInteractionEnabled;
    }
    
    [_remoteMicrophoneView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remoteBackgroundView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_remoteBackgroundView.mas_bottom).offset(-20);
    }];
    
    [_localMicrophoneView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_localView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_localView.mas_bottom).offset(-20);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
    }];
}

@end
