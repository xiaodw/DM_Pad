#import "DMLiveController.h"
#import "DMButton.h"
#import "DMLiveVideoManager.h"
#import "DMLiveButtonControlView.h"
#import "DMLiveWillStartView.h"
#import "DMLiveCoursewareView.h"
#import "NSString+Extension.h"
#import "DMCourseFilesController.h"
#import "DMMicrophoneView.h"
#import "DMSecretKeyManager.h"
#import "DMSignalingMsgData.h"
#import "DMSendSignalingMsg.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

#define kSmallSize CGSizeMake(DMScaleWidth(240), DMScaleHeight(180))
#define kColor33 DMColorWithRGBA(33, 33, 33, 1)
#define kColor06 DMColorWithRGBA(06, 06, 06, 1)

// 布局模式
typedef NS_ENUM(NSInteger, DMLayoutMode) {
    DMLayoutModeRemoteAndSmall, // 远端大, 本地小模式
    DMLayoutModeSmallAndRemote, // 本地大, 远端小模式
    DMLayoutModeAveragDistribution, //课件模式 And 左右模式
    DMLayoutModeAll // 全部模式
};

@interface DMLiveController ()<DMLiveButtonControlViewDelegate, DMLiveCoursewareViewDelegate, DMCourseFilesControllerDelegate>

#pragma mark - UI property
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
@property (strong, nonatomic) UIImageView *alreadyTimeShadowImageView; // 底部时间条阴影
@property (strong, nonatomic) UILabel *describeTimeLabel; // 底部时间条: 提示
@property (strong, nonatomic) DMLiveWillStartView *willStartView; // 即将开始的View
@property (strong, nonatomic) UILabel *recordingLabel; // 录制中...

#pragma mark - Other property
@property (strong, nonatomic) NSMutableArray *syncCourseFiles;
@property (strong, nonatomic) dispatch_source_t timer; // 1秒中更新一次时间UI
@property (assign, nonatomic) NSInteger tapLayoutCount; // 点击布局按钮次数
@property (assign, nonatomic) BOOL isCoursewareMode; // 是否是课件布局模式
@property (assign, nonatomic) DMLayoutMode beforeLayoutMode; // 课件布局模式之前的模式
@property (assign, nonatomic) NSInteger userIdentity; // 当前身份 0: 学生, 1: 老师

@end

@implementation DMLiveController

#pragma mark - Set Methods
- (void)setIsRemoteUserOnline:(BOOL)isRemoteUserOnline {
    _isRemoteUserOnline = isRemoteUserOnline;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.remoteView.alpha = isRemoteUserOnline ? 1 : 0;;
    }];
}

//声网用户状态统计
- (void)agoraUserStatusLog:(NSString *)lessonID
      targetUID:(NSString *)targetUid //动作用户的id
      uploadUID:(NSString *)uploadUID //上报用户的id
         action:(DMAgoraUserStatusLog)action
{
    [DMApiModel agoraUserStatusLog:lessonID targetUID:targetUid uploadUID:uploadUID action:action block:nil];
}

#pragma mark - Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColor33;
    [self.navigationController setNavigationBarHidden:YES];
    
    self.tapLayoutCount = 3;
    
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    _userIdentity = userIdentity;
    self.remotePlaceholderTitleLabel.text = userIdentity ? DMTextLiveStudentNotEnter : DMTextLiveTeacherNotEnter;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoTapped)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

    [self agoraUserStatusLog:self.lessonID
                   targetUID:[DMAccount getUserID]
                   uploadUID:[DMAccount getUserID]
                      action:DMAgoraUserStatusLog_Enter];

    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self joinChannel];
    [self setupMakeLiveCallback];

    [self timer];
    
    // [self.liveVideoManager switchSound:NO block:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self computTime];
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

#pragma mark - Functions
- (void)didTapRemote {
    self.tapLayoutCount = DMLayoutModeAveragDistribution;
    [self makeLayoutViews];
}

- (void)didTapLocal {
    self.tapLayoutCount = DMLayoutModeRemoteAndSmall;
    [self makeLayoutViews];
}

#pragma mark - Setup make live
// 远端有人回调
- (void)setupMakeLiveCallback {
    // 有用户加入
    WS(weakSelf)
    // 自己退出直播事件
    self.liveVideoManager.blockQuitLiveVideoEvent = ^(BOOL success) {
        weakSelf.isRemoteUserOnline = NO;
    };
    
    // 有用户离开
    self.liveVideoManager.blockDidOfflineOfUid = ^(NSUInteger uid) {
        weakSelf.isRemoteUserOnline = NO;
        [weakSelf agoraUserStatusLog:weakSelf.lessonID targetUID:[NSString stringWithFormat:@"%lu",(unsigned long)uid] uploadUID:[DMAccount getUserID] action:DMAgoraUserStatusLog_Exit];
    };
    
    //有用户重新加入
    self.liveVideoManager.blockFirstRemoteVideoDecodedOfUid = ^(NSUInteger uid, CGSize size) {
        weakSelf.isRemoteUserOnline = YES;
        [weakSelf setShowPlaceholderView];
        [weakSelf agoraUserStatusLog:weakSelf.lessonID targetUID:[NSString stringWithFormat:@"%lu",(unsigned long)uid] uploadUID:[DMAccount getUserID] action:DMAgoraUserStatusLog_Enter];
    };
    
    //声网SDK连接中断
    self.liveVideoManager.blockRtcEngineConnectionDidLostDidInterrupted = ^{
        [weakSelf agoraUserStatusLog:weakSelf.lessonID targetUID:[DMAccount getUserID] uploadUID:[DMAccount getUserID] action:DMAgoraUserStatusLog_Neterr];
    };
}

#pragma mark - JoinChannel
- (void)joinChannel {
    WS(weakSelf)
    [self.liveVideoManager startLiveVideo:self.localView remote:self.remoteView isTapVideo:YES blockAudioVolume:^(NSInteger totalVolume, NSArray *speakers) {
        if (speakers.count == 0) return;
        
        for (int i = 0; i < speakers.count; i++) {
            AgoraRtcAudioVolumeInfo *volumeInfo = speakers[i];
            // uid 为 0 说明是自己
            if (volumeInfo.uid == 0) {
                weakSelf.localMicrophoneView.voiceValue = volumeInfo.volume / 255.0;
                return;
            }
            weakSelf.remoteMicrophoneView.voiceValue = volumeInfo.volume / 255.0;
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
        // NSLog(@"接收到来自 %@，的超级好消息 %@", account , msg);
        if (!STR_IS_NIL(msg)) {
            DMSignalingMsgData *responseDataModel = [DMSignalingMsgData mj_objectWithKeyValues:msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 1 同步开始
                if (responseDataModel.code == 1) {
                    NSArray *courses = responseDataModel.data.list.firstObject;
                    [weakSelf courseFilesController:nil syncCourses:@[courses]];
                    return ;
                }
                
                // 2,操作
                if (responseDataModel.code == 2) {
                    [weakSelf courseFilesController:nil syncCourses:responseDataModel.data.list];
                    return ;
                }
                
                // 3,结束同步
                if (responseDataModel.code == 3) {
                    [weakSelf liveCoursewareViewDidTapClose:nil];
                    return ;
                }
            });
        }
    }];
}

#pragma mark - DMLiveButtonControlViewDelegate
// 离开
- (void)liveButtonControlViewDidTapLeave:(DMLiveButtonControlView *)liveButtonControlView {
    WS(weakSelf)
    if(self.alreadyTime < self.totalTime + self.delayTime) {
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:DMTitleExitLiveRoom message:DMTitleLiveAutoClose preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleCancel otherTitle:DMTitleOK, nil];
        [alert showWithViewController:self IndexBlock:^(NSInteger index) {
            if (index == 1) { // 右侧
                [weakSelf.liveVideoManager quitLiveVideo:^(BOOL success) {
                    [weakSelf.navigationVC popViewControllerAnimated:YES];
                    if ([[DMAccount getUserIdentity] integerValue]) {
                        NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_End_Syn sourceData:nil index:0];
                        [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) { } faile:^(NSString *messageID, AgoraEcode ecode) {}];
                    }
                }];
                [weakSelf agoraUserStatusLog:weakSelf.lessonID targetUID:[DMAccount getUserID] uploadUID:[DMAccount getUserID] action:DMAgoraUserStatusLog_Exit];
            }
        }];
        return;
    }
    
    [self.liveVideoManager quitLiveVideo:^(BOOL success) {
        [weakSelf agoraUserStatusLog:weakSelf.lessonID targetUID:[DMAccount getUserID] uploadUID:[DMAccount getUserID] action:DMAgoraUserStatusLog_Exit];
        
        if (weakSelf.presentVCs.count == 0) {
            [weakSelf.navigationVC popViewControllerAnimated:YES];
            return;
        }
        
        [DMActivityView hideActivity];
        for (int i = (int)weakSelf.presentVCs.count-1; i >= 0; i--) {
            UIViewController *presentVC = weakSelf.presentVCs[i];
            [weakSelf.presentVCs removeObject:presentVC];
            [presentVC dismissViewControllerAnimated:NO completion:^{
                [weakSelf.navigationVC popViewControllerAnimated:YES];
            }];
        }
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
    DMCourseFilesController *courseFilesVC = [DMCourseFilesController new];
    courseFilesVC.columns = 3;
    courseFilesVC.leftMargin = 15;
    courseFilesVC.rightMargin = 15;
    courseFilesVC.columnSpacing = 15;
    courseFilesVC.delegate = self;
    self.animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
    courseFilesVC.transitioningDelegate = self.animationHelper;
    courseFilesVC.modalPresentationStyle = UIModalPresentationCustom;
    courseFilesVC.lessonID = self.lessonID;
    [self presentViewController:courseFilesVC animated:YES completion:nil];
    courseFilesVC.liveVC = self;
    [self.presentVCs addObject:courseFilesVC];
}

#pragma mark - DMLiveCoursewareViewDelegate
- (void)liveCoursewareViewDidTapClose:(DMLiveCoursewareView *)liveCoursewareView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isCoursewareMode) return;
        _isCoursewareMode = NO;
        [self.coursewareView removeFromSuperview];
        _coursewareView = nil;
        _syncCourseFiles  = nil;
        self.tapLayoutCount = _beforeLayoutMode;
        [self makeLayoutViews];
    });
}

#pragma mark - DMCourseFilesControllerDelegate
- (void)courseFilesController:(DMCourseFilesController *)courseFilesController syncCourses:(NSArray *)syncCourses {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isCoursewareMode) _beforeLayoutMode = self.tapLayoutCount-1 % DMLayoutModeAll;
        _isCoursewareMode = YES;
        self.tapLayoutCount = 1;
        
        [self makeLayoutViews];
        _syncCourseFiles = nil;
        [self.syncCourseFiles addObjectsFromArray:syncCourses];
        self.coursewareView.allCoursewares = self.syncCourseFiles;
    });
}

#pragma mark - AddSubviews
- (void)setupMakeAddSubviews {
    [self.view addSubview:self.remoteBackgroundView];
    [self.remoteBackgroundView addSubview:self.remoteView];
    [self.view addSubview:self.remotePlaceholderView];
    [self.view addSubview:self.remotePlaceholderTitleLabel];
    [self.view addSubview:self.shadowRightImageView];
    [self.view addSubview:self.localView];
    [self.view addSubview:self.shadowImageView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.alreadyTimeShadowImageView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.remoteMicrophoneView];
    [self.view addSubview:self.localMicrophoneView];

    [self.localView addSubview:self.localPlaceholderView];
    [self.localView addSubview:self.localPlaceholderTitleLabel];

    [self.view addSubview:self.willStartView];
    [self.view addSubview:self.recordingLabel];
}

#pragma mark - LayoutSubviews
- (void)setupMakeLayoutSubviews {
    [_recordingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-22);
    }];
    
    [_controlView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(225);
    }];
    
    [_shadowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_controlView);
    }];
    
    [_shadowRightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.width.equalTo(50);
    }];
    
    [_timeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(23);
        make.bottom.equalTo(self.view.mas_bottom).offset(-18);
        make.height.equalTo(20);
        make.right.equalTo(self.view);
    }];
    
    [_alreadyTimeShadowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_timeView);
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
        make.size.equalTo(CGSizeMake(17, 25));
        make.bottom.equalTo(_remoteView.mas_bottom).offset(-15);
    }];
    
    [_localMicrophoneView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_localView.mas_right).offset(-15);
        make.size.equalTo(_remoteMicrophoneView);
        make.bottom.equalTo(_localView.mas_bottom).offset(-15);
    }];
    
    [_remotePlaceholderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(290);
        make.size.equalTo(CGSizeMake(154, 154));
        make.centerX.equalTo(_remoteView);
    }];
    
    [_remotePlaceholderTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(45);
        make.left.equalTo(_remoteView).offset(10);
        make.right.equalTo(_remoteView.mas_right).offset(-10);
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
        make.size.equalTo(CGSizeMake(220, 220));
    }];
}

- (void)setShowPlaceholderView {
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteAndSmall) {
        self.remotePlaceholderView.hidden = self.alreadyTime < 0 || _isRemoteUserOnline;
    }else {
        self.remotePlaceholderView.hidden = _isRemoteUserOnline;
    }
    self.remotePlaceholderTitleLabel.hidden = self.remotePlaceholderView.hidden;
}

#pragma mark - timer
- (void)computTime {
    self.alreadyTime += 1;
    [self setShowPlaceholderView];

    // 做几分钟开课操作
    if (self.alreadyTime < 0) {
        self.willStartView.willStartDescribeLabel.text = [NSString stringWithFormat:DMTextLiveStartTimeInterval, -_alreadyTime/60 + 1];
        return;
    }
    
    // 能到这里就代表上课ing
    if (_willStartView != nil) {
        [_willStartView removeFromSuperview];
        _willStartView = nil;
        _timeView.hidden = NO;
    }
    // 更新UI
    self.alreadyTimeLabel.text = [NSString stringWithTimeToHHmmss:_alreadyTime];
    
    /** 一节课按 totalTime = 45 分钟 warningTime = 5 分钟 delayTime = 15 分钟算 */
    // 0 < alreadyTime < 40
    if ((0 < _alreadyTime && _alreadyTime < self.totalTime - _warningTime) || _userIdentity == 0) { // 0: 学生
        return;
    }
    
    // 40 < alreadyTime < 45
    if (_alreadyTime > self.totalTime - _warningTime && _alreadyTime < self.totalTime) {
        _timeButton.selected = YES;
        _alreadyTimeLabel.textColor = DMColorBaseMeiRed;
        return;
    }
    
    // 45 < alreadyTime < 60
    if (_alreadyTime > self.totalTime && _alreadyTime < self.totalTime + _delayTime) {
        _timeButton.selected = YES;
        _alreadyTimeLabel.textColor = DMColorBaseMeiRed;
        _describeTimeLabel.text = [NSString stringWithFormat:DMTextLiveDelayTime, (_delayTime/60 - (_alreadyTime/60-self.totalTime/60))];
        return;
    }
    
    //  alreadyTime >= 60，直播强制退出
    if (_alreadyTime >= self.totalTime + _delayTime) {
        [self invalidate];
        [self liveButtonControlViewDidTapLeave:nil];
        return;
    }
}

#pragma mark - Lazy
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

- (DMLiveVideoManager *)liveVideoManager {
    if (!_liveVideoManager) {
        _liveVideoManager = [DMLiveVideoManager shareInstance];
    }
    
    return _liveVideoManager;
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
        _remotePlaceholderTitleLabel.numberOfLines = 0;
        _remotePlaceholderTitleLabel.textColor = DMColor102;
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(20);
        _remotePlaceholderTitleLabel.textAlignment = NSTextAlignmentCenter;
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
        _localPlaceholderTitleLabel.text = DMAlertTitleCameraNotOpen;
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
        _remoteBackgroundView.backgroundColor = kColor33;
        _remoteBackgroundView.userInteractionEnabled = NO;
    }
    
    return _remoteBackgroundView;
}

- (UIView *)remoteView {
    if (!_remoteView) {
        _remoteView = [UIView new];
        _remoteView.backgroundColor = kColor33;
        _remoteView.userInteractionEnabled = self.remoteBackgroundView.userInteractionEnabled;
    }
    
    return _remoteView;
}

- (UIView *)localView {
    if (!_localView) {
        _localView = [UIView new];
        _localView.backgroundColor = kColor06;
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

- (UIImageView *)alreadyTimeShadowImageView {
    if (!_alreadyTimeShadowImageView) {
        _alreadyTimeShadowImageView = [UIImageView new];
        _alreadyTimeShadowImageView.image = [UIImage imageNamed:@"image_shadowBottomToTop"];
    }
    
    return _alreadyTimeShadowImageView;
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

- (UILabel *)recordingLabel {
    if (!_recordingLabel) {
        _recordingLabel = [UILabel new];
        _recordingLabel.text = @"录制中...";
        _recordingLabel.textColor = [UIColor whiteColor];
        _recordingLabel.font = DMFontPingFang_Light(14);
    }
    
    return _recordingLabel;
}

- (NSMutableArray *)presentVCs {
    if (!_presentVCs) {
        _presentVCs = [NSMutableArray array];
    }
    
    return _presentVCs;
}

- (NSMutableArray *)syncCourseFiles {
    if (!_syncCourseFiles) {
        _syncCourseFiles = [NSMutableArray array];
    }
    
    return _syncCourseFiles;
}

#pragma mark - Swich Layout
- (void)makeLayoutViews {
    self.tapLayoutCount += 1;
    
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteAndSmall) {
        self.remotePlaceholderView.hidden = self.alreadyTime < 0 || _isRemoteUserOnline;
    }else {
        self.remotePlaceholderView.hidden = _isRemoteUserOnline;
    }
    self.remotePlaceholderTitleLabel.hidden = self.remotePlaceholderView.hidden;
    
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
            make.left.equalTo(_remoteView).offset(10);
            make.right.equalTo(_remoteView.mas_right).offset(-10);
        }];
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(20);
        
        _localView.userInteractionEnabled = YES;
        _remoteBackgroundView.userInteractionEnabled = NO;
        _remoteView.userInteractionEnabled = _remoteBackgroundView.userInteractionEnabled;
        _remoteView.backgroundColor = kColor33;
        _remoteBackgroundView.backgroundColor = _remoteView.backgroundColor;
        _localView.backgroundColor = kColor06;
        
        [_coursewareView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right);
            make.bottom.top.equalTo(self.view);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
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
            make.left.equalTo(_remoteView).offset(10);
            make.right.equalTo(_remoteView.mas_right).offset(-10);
        }];
        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(16);
        _localView.userInteractionEnabled = NO;
        _remoteBackgroundView.userInteractionEnabled = YES;
        _remoteView.userInteractionEnabled = _remoteBackgroundView.userInteractionEnabled;
        _remoteView.backgroundColor = kColor06;
        _remoteBackgroundView.backgroundColor = _remoteView.backgroundColor;
        _localView.backgroundColor = kColor33;
        
        [_coursewareView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right);
            make.bottom.top.equalTo(self.view);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
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
                make.left.equalTo(_remoteView).offset(10);
                make.right.equalTo(_remoteView.mas_right).offset(-10);
            }];
            _remoteView.backgroundColor = kColor06;
            _remoteBackgroundView.backgroundColor = _remoteView.backgroundColor;
            _localView.backgroundColor = kColor06;
            
            if (!self.coursewareView.superview){
                [self.view insertSubview:self.coursewareView belowSubview:self.localView];
            }
            [_coursewareView remakeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.top.equalTo(self.view);
                make.width.equalTo(DMScreenWidth*0.5);
            }];
        }else { // 左右
            [_remoteBackgroundView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, DMScaleWidth(385)));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.centerY.equalTo(_remoteBackgroundView);
                make.right.equalTo(self.view);
            }];
            
            CGFloat remotePHVTop = (DMScreenHeight - DMScaleWidth(385)) * 0.5 + 95;
            [_remotePlaceholderView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(remotePHVTop);
                make.size.equalTo(CGSizeMake(154, 154));
                make.centerX.equalTo(_remoteBackgroundView);
            }];
            
            [_remotePlaceholderTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_remotePlaceholderView.mas_bottom).offset(39);
                make.left.equalTo(_remoteView).offset(10);
                make.right.equalTo(_remoteView.mas_right).offset(-10);
            }];
            _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(16);
        }
        _localView.userInteractionEnabled = NO;
        _remoteBackgroundView.userInteractionEnabled = NO;
        _remoteView.userInteractionEnabled = _remoteBackgroundView.userInteractionEnabled;
        
        _remoteView.backgroundColor = kColor06;
        _remoteBackgroundView.backgroundColor = _remoteView.backgroundColor;
        _localView.backgroundColor = kColor06;
    }
    
    [_remoteMicrophoneView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remoteBackgroundView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(17, 25));
        make.bottom.equalTo(_remoteBackgroundView.mas_bottom).offset(-15);
    }];
    
    [_localMicrophoneView remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_localView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(17, 25));
        make.bottom.equalTo(_localView.mas_bottom).offset(-15);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)dealloc {
    [self invalidate];
    DMLogFunc
}

@end
