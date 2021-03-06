#import "DMLiveController.h"
#import "DMLiveVideoManager.h"
#import "DMLiveButtonControlView.h"
#import "DMLiveWillStartView.h"
#import "DMLiveCoursewareView.h"
#import "DMLivingTimeView.h"
#import "DMLiveView.h"
#import "NSString+Extension.h"
#import "DMCourseFilesController.h"
#import "DMMicrophoneView.h"
#import "DMSecretKeyManager.h"
#import "DMSendSignalingMsg.h"
#import "DMSignalingMsgData.h"
#import "DMButton.h"

#import "DMQuestionViewController.h"

#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

#define kSmallSize CGSizeMake(DMScaleWidth(240), DMScaleHeight(180))
#define kColor33 DMColorWithRGBA(33, 33, 33, 1)

// 布局模式
typedef NS_ENUM(NSInteger, DMLayoutMode) {
    DMLayoutModeRemoteFullAndLocalSmall = 0, // 远端大, 本地小模式
    DMLayoutModeRemoteSmallAndLocalFull = 1, // 远端小, 本地大模式
    DMLayoutModeAveragDistribution = 2, // 课件模式 or 左右模式
    DMLayoutModeAll // 全部模式
};

typedef void (^BlockExchangeViewLayout)(MASConstraintMaker *make);// 窗口布局

@interface DMLiveController ()<DMLiveButtonControlViewDelegate, DMLiveCoursewareViewDelegate, DMCourseFilesControllerDelegate>

#pragma mark - UI property
@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager; // 声网SDK Manager

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) DMLiveView *remoteView;
@property (strong, nonatomic) DMLiveView *localView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGuestureRecognizer;
@property (nonatomic, strong) BlockExchangeViewLayout smallViewLayout;
@property (nonatomic, strong) BlockExchangeViewLayout fullViewLayout;

@property (strong, nonatomic) DMLiveCoursewareView *coursewareView; // 课件视图
@property (strong, nonatomic) DMLiveButtonControlView *controlView; // 左侧按钮们
@property (strong, nonatomic) DMLivingTimeView *timeView;
@property (strong, nonatomic) DMLiveWillStartView *willStartView; // 即将开始的View
@property (strong, nonatomic) UILabel *recordingLabel; // 录制中...

#pragma mark - Other property
@property (strong, nonatomic) NSMutableArray *syncCourseFiles;
@property (strong, nonatomic) dispatch_source_t timer; // 1秒中更新一次时间UI
@property (assign, nonatomic) NSInteger tapLayoutCount; // 点击布局按钮次数
@property (assign, nonatomic) BOOL isCoursewareMode; // 是否是课件布局模式
@property (assign, nonatomic) DMLayoutMode beforeLayoutMode; // 课件布局模式之前的模式
@property (assign, nonatomic) NSInteger userIdentity; // 当前身份 0: 学生, 1: 老师
@property (assign, nonatomic) CGPoint smallViewCuttentPoint; // 当前小屏幕的位置

@end

@implementation DMLiveController

#pragma mark - Set Methods
- (void)setIsRemoteUserOnline:(BOOL)isRemoteUserOnline {
    _isRemoteUserOnline = isRemoteUserOnline;

    if (isRemoteUserOnline) return;
    for (int i = 0; i < self.remoteView.view.subviews.count; i++) {
        UIView *subview = self.remoteView.view.subviews[i];
        [subview removeFromSuperview];
    }
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

    [self agoraUserStatusLog:self.lessonID
                   targetUID:[DMAccount getUserID]
                   uploadUID:[DMAccount getUserID]
                      action:DMAgoraUserStatusLog_Enter];
    
    [self setupMakeInitializationVariate];
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self setupMakeLayoutBlocks];
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

#pragma mark - Functions
- (void)didTapShowControlButtons {
    [UIView animateWithDuration:0.15 animations:^{
        self.controlView.alpha = self.controlView.alpha == 1 ? 0 : 1;;
    }];
}

- (void)didPanGuestureRecognizer:(UIPanGestureRecognizer *)pan {
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) {
        return;
    }
    UIView *view = pan.view;
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:view.superview];
        CGFloat left = view.dm_x + translation.x;
        left = left > DMScreenWidth - kSmallSize.width ? DMScreenWidth - kSmallSize.width : left;
        left = left < 0 ? 0 : left;
        CGFloat top = view.dm_y + translation.y;
        top = top > DMScreenHeight - kSmallSize.height ? DMScreenHeight - kSmallSize.height : top;
        top = top < 0 ? 0 : top;
        [view remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(left);
            make.top.equalTo(top);
            make.size.equalTo(kSmallSize);
        }];
        [pan setTranslation:CGPointZero inView:view.superview];
        return;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        self.smallViewCuttentPoint = [self.view convertRect:view.frame toView:self.view].origin;
    }
}

- (void)didTapRemote {
    self.tapLayoutCount = DMLayoutModeAveragDistribution; // tapLayoutCount = 2
    [self makeLayoutViews]; // tapLayoutCount = DMLayoutModeRemoteAndFull
}

- (void)didTapLocal {
    self.tapLayoutCount = DMLayoutModeRemoteFullAndLocalSmall; // tapLayoutCount = 0
    [self makeLayoutViews]; // tapLayoutCount = 1
}

#pragma mark - Setup make live
// 远端有人回调
- (void)setupMakeLiveCallback {
    WS(weakSelf)
    // 自己退出直播事件
    self.liveVideoManager.blockQuitLiveVideoEvent = ^(BOOL success) {
        weakSelf.isRemoteUserOnline = NO;
    };
    
    // 有用户离开
    self.liveVideoManager.blockDidOfflineOfUid = ^(NSUInteger uid) {
        [weakSelf liveCoursewareViewDidTapClose:nil];
        weakSelf.isRemoteUserOnline = NO;
        [weakSelf setShowPlaceholderView];
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
    [self.liveVideoManager startLiveVideo:self.localView.view remote:self.remoteView.view isTapVideo:YES blockAudioVolume:^(NSInteger totalVolume, NSArray *speakers) {
        if (speakers.count == 0) return;
        
        for (int i = 0; i < speakers.count; i++) {
            AgoraRtcAudioVolumeInfo *volumeInfo = speakers[i];
            // uid 为 0 说明是自己
            if (volumeInfo.uid == 0) {
                weakSelf.localView.voiceValue = volumeInfo.volume / 255.0;
                return;
            }
            weakSelf.remoteView.voiceValue = volumeInfo.volume / 255.0;
        }
    } blockTapVideoEvent:^(DMLiveVideoViewType type) {
        // 课件模式 or 左右模式
        if (weakSelf.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) {
            [weakSelf didTapShowControlButtons];
            return;
        }
        
        if (DMLiveVideoViewType_Local == type) {
            [weakSelf didTapLocal];
            return;
        }
        
        [weakSelf didTapRemote];
        return;
    }];
    
    //接收信令同步的消息，完成同步功能
    [self.liveVideoManager onSignalingMessageReceive:^(NSString *account, DMSignalingMsgData *responseDataModel) {
        NSLog(@"onSignalingMessageReceive: %@", [NSThread currentThread]);
        [weakSelf.coursewareView resetWhiteBoard];
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
    }];
}

#pragma mark - DMLiveButtonControlViewDelegate
// 离开
- (void)liveButtonControlViewDidTapLeave:(DMLiveButtonControlView *)liveButtonControlView {
    WS(weakSelf)
    if(self.alreadyTime < self.totalTime + self.delayTime) {//
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:DMTitleExitLiveRoom
                                                                             message:DMTitleLiveAutoClose
                                                                      preferredStyle:UIAlertControllerStyleAlert
                                                                         cancelTitle:DMTitleCancel otherTitle:DMTitleOK, nil];
        [alert showWithViewController:self IndexBlock:^(NSInteger index) {
            if (index == 1) { // 右侧
                //判断 是否到正常结束时间,并且 需要跳转到 问题页面 字段为1
                
                if ((weakSelf.alreadyTime > weakSelf.totalTime) && weakSelf.isToQuestionPage == 1) {
                    [weakSelf desSubVC:NO];
                    [weakSelf gotoQuestionPage];
                } else {
                    [weakSelf desSubVC:YES];
                }
            }
        }];
        return;
    }
    
    //以下代码自动强制退出逻辑
    [DMActivityView hideActivity];
    if (weakSelf.isToQuestionPage == 1) {
        [weakSelf desSubVC:NO];
        [weakSelf gotoQuestionPage];
    } else {
        [weakSelf desSubVC:YES];
    }
}

- (void)desSubVC:(BOOL)isPop {
    WS(weakSelf)
    [self.liveVideoManager quitLiveVideo:^(BOOL success) {
        [weakSelf desLastVC:weakSelf.presentVCs isPop:isPop];
        if ([[DMAccount getUserIdentity] integerValue]) {
            NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_End_Syn sourceData:nil synType:DMSignalingMsgSynCourse];
            [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) { } faile:^(NSString *messageID, AgoraEcode ecode) {}];
        }
         [weakSelf agoraUserStatusLog:weakSelf.lessonID targetUID:[DMAccount getUserID] uploadUID:[DMAccount getUserID] action:DMAgoraUserStatusLog_Exit];
    }];
}

- (void)desLastVC:(NSMutableArray *)objs isPop:(BOOL)isPop {
    UIViewController *presentVC = [objs lastObject];
    if (presentVC) {
        [objs removeObject:presentVC];
        if (objs.count > 0) {
            [presentVC dismissViewControllerAnimated:NO completion:nil];
            [self desLastVC:objs isPop:isPop];
        } else {
            [presentVC dismissViewControllerAnimated:NO completion:nil];
            if (isPop) {
                [self.navigationVC popViewControllerAnimated:YES];
            }
        }
    } else {
        if (isPop) {
            [self.navigationVC popViewControllerAnimated:YES];
        }
    }
}

- (void)quitLiveVideoClickSure {
    [self desSubVC:YES];
}

- (void)gotoQuestionPage {
    DMQuestionViewController *qtVC = [[DMQuestionViewController alloc] init];
    DMCourseDatasModel *model = [[DMCourseDatasModel alloc] init];
    model.lesson_id = self.lessonID;
    qtVC.courseObj = model;
    [self.navigationController pushViewController:qtVC animated:YES];
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
// 关闭课件
- (void)liveCoursewareViewDidTapClose:(DMLiveCoursewareView *)liveCoursewareView {
    [self.coursewareView resetWhiteBoard];
     NSLog(@"liveCoursewareViewDidTapClose: %@", [NSThread currentThread]);
    // 关闭课件
    if (!_isCoursewareMode) return;
    _isCoursewareMode = NO;
    _syncCourseFiles  = nil;
    _tapLayoutCount = _beforeLayoutMode;
    [self makeLayoutViews];
}

#pragma mark - DMCourseFilesControllerDelegate
// 点击同步课件
- (void)courseFilesController:(DMCourseFilesController *)courseFilesController syncCourses:(NSArray *)syncCourses {
    [self.coursewareView resetWhiteBoard];
    NSLog(@"syncCourses: %@", [NSThread currentThread]);
    // 记录课件模式值前的布局格式
    if (!_isCoursewareMode) _beforeLayoutMode = self.tapLayoutCount-1 % DMLayoutModeAll;
    _isCoursewareMode = YES;
    self.tapLayoutCount = DMLayoutModeRemoteSmallAndLocalFull; // tapLayoutCount = 1
    
    [self makeLayoutViews]; // tapLayoutCount = 2
    _syncCourseFiles = nil;
    [self.syncCourseFiles addObjectsFromArray:syncCourses];
    self.coursewareView.allCoursewares = self.syncCourseFiles;
}

#pragma mark - initialization variate
- (void)setupMakeInitializationVariate {
    self.view.backgroundColor = kColor33;
    self.tapLayoutCount = DMLayoutModeAll;
    self.smallViewCuttentPoint = CGPointMake(DMScreenWidth-kSmallSize.width, 0);
    self.userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - AddSubviews
- (void)setupMakeAddSubviews {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.remoteView];
    [self.view addSubview:self.localView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.recordingLabel];
    [self.view addSubview:self.coursewareView];
    [self.view addSubview:self.willStartView];
}

#pragma mark - LayoutSubviews
- (void)setupMakeLayoutSubviews {
    [_backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_recordingLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-18);
    }];
    
    [_controlView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(83);
    }];
    
    [_timeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(38);
    }];
    
    [_remoteView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_localView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(kSmallSize);
        make.top.right.equalTo(self.view);
    }];
    
    [_willStartView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(CGSizeMake(220, 220));
    }];
    [_coursewareView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_right);
        make.bottom.top.equalTo(self.view);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
}

#pragma mark - setupLayoutBlocks
- (void)setupMakeLayoutBlocks {
    WS(weakSelf)
    [self setSmallViewLayout:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.smallViewCuttentPoint.y);
        make.left.equalTo(weakSelf.smallViewCuttentPoint.x);
        make.size.equalTo(kSmallSize);
    }];
    
    [self setFullViewLayout:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

#pragma mark - timer
- (void)setShowPlaceholderView {
    BOOL showPlaceholder = _isRemoteUserOnline;
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteFullAndLocalSmall) {
        showPlaceholder = self.alreadyTime < 0 || _isRemoteUserOnline; // 课程没有开始 or 用户上线
    }
    self.remoteView.showPlaceholder = !showPlaceholder;
}

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
        _recordingLabel.hidden = NO;
    }
    // 更新UI
    self.timeView.alreadyTime = [NSString stringWithTimeToHHmmss:_alreadyTime];
    
    /** 一节课按 totalTime = 45 分钟 warningTime = 5 分钟 delayTime = 15 分钟算 */
    // 0 < alreadyTime < 40
    if ((0 <= _alreadyTime && _alreadyTime < self.totalTime - _warningTime) ||
        (_userIdentity == 0 && _alreadyTime < self.totalTime + _delayTime)) { // _userIdentity = 0: 学生, 如果超出拖堂范围退出
        return;
    }
    
    // 40 < alreadyTime < 45
    _timeView.timeButton.selected = YES;
    _timeView.alreadyTimeColor = DMColorBaseMeiRed;
    if (_alreadyTime > self.totalTime - _warningTime && _alreadyTime < self.totalTime) {
        return;
    }
    
    // 45 < alreadyTime < 60
    if (_alreadyTime > self.totalTime && _alreadyTime < self.totalTime + _delayTime) {
        _timeView.describeTime = [NSString stringWithFormat:DMTextLiveDelayTime, (_delayTime/60 - (_alreadyTime/60-self.totalTime/60))];
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
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
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

- (UIView *)remoteView {
    if (!_remoteView) {
        _remoteView = [DMLiveView new];
        _remoteView.mode = DMLiveViewFull;
        _remoteView.placeholderImage = [UIImage imageNamed:@"icon_notEnter"];
    }
    
    return _remoteView;
}

- (UIView *)localView {
    if (!_localView) {
        _localView = [DMLiveView new];
        _localView.mode = DMLiveViewSmall;
        _localView.placeholderImage = [UIImage imageNamed:@"icon_unturnedCamera"];
        _localView.showPlaceholder = NO;
        [_localView addGestureRecognizer:self.panGuestureRecognizer];
    }
    
    return _localView;
}

- (UIPanGestureRecognizer *)panGuestureRecognizer {
    if (!_panGuestureRecognizer) {
        _panGuestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanGuestureRecognizer:)];
    }
    
    return _panGuestureRecognizer;
}

- (DMLiveButtonControlView *)controlView {
    if (!_controlView) {
        _controlView = [DMLiveButtonControlView new];
        _controlView.delegate = self;
    }
    
    return _controlView;
}

- (DMLivingTimeView *)timeView {
    if (!_timeView) {
        _timeView = [DMLivingTimeView new];
    }
    
    return _timeView;
}

- (DMLiveWillStartView *)willStartView {
    if (!_willStartView) {
        _willStartView = [DMLiveWillStartView new];
        _willStartView.userInteractionEnabled = NO;
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
        _recordingLabel.text = DMTextLiveRecording;
        _recordingLabel.textColor = [UIColor whiteColor];
        _recordingLabel.font = DMFontPingFang_Light(14);
        _recordingLabel.hidden = YES;
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

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapShowControlButtons)];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _backgroundView;
}

#pragma mark - Swich Layout
- (void)makeLayoutViews {
    self.tapLayoutCount += 1;
    
    [self setShowPlaceholderView];
    
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteFullAndLocalSmall) { // 远端大, 本地小模式
        [self.view insertSubview:_localView aboveSubview:self.backgroundView];
        [self.view insertSubview:_remoteView aboveSubview:self.backgroundView];
        [_localView addGestureRecognizer:self.panGuestureRecognizer];
        
        [_remoteView remakeConstraints:self.fullViewLayout];
        [_localView remakeConstraints:self.smallViewLayout];
        
        [_coursewareView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right);
            make.bottom.top.equalTo(self.view);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
        _localView.mode  = DMLiveViewSmall;
        _remoteView.mode = DMLiveViewFull;
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteSmallAndLocalFull) { // 远端小, 本地大模式
        [self.view insertSubview:_localView aboveSubview:self.backgroundView];
        [self.view insertSubview:_remoteView aboveSubview:self.backgroundView];
        [_remoteView addGestureRecognizer:self.panGuestureRecognizer];
        
        [_remoteView remakeConstraints:self.smallViewLayout];
        [_localView remakeConstraints:self.fullViewLayout];
        
        [_coursewareView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right);
            make.bottom.top.equalTo(self.view);
            make.width.equalTo(DMScreenWidth*0.5);
        }];
        _localView.mode  = DMLiveViewFull;
        _remoteView.mode = DMLiveViewSmall;
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) {
        [self.view insertSubview:_remoteView aboveSubview:self.backgroundView];
        [self.view insertSubview:_localView aboveSubview:self.backgroundView];
        
        if (_isCoursewareMode) { // 上下
            [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, DMScreenHeight * 0.5));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.left.equalTo(_remoteView);
                make.bottom.equalTo(self.view);
            }];
            
            [_coursewareView remakeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.top.equalTo(self.view);
                make.width.equalTo(DMScreenWidth*0.5);
            }];
            _localView.mode  = DMLiveViewBalanceTB;
            _remoteView.mode = DMLiveViewBalanceTB;
        }else { // 左右
            [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, DMScaleWidth(385)));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.centerY.equalTo(_remoteView);
                make.right.equalTo(self.view);
            }];
            _localView.mode  = DMLiveViewBalanceLR;
            _remoteView.mode = DMLiveViewBalanceLR;
        }
    }
    MASViewAttribute *att = self.view.mas_right;
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution && _isCoursewareMode) {
        att = self.localView.mas_right;
    }
    [_recordingLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(att).offset(-44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-18);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
        [self.remoteView layoutSubviews];
        [self.localView layoutSubviews];
    } completion:^(BOOL finished) {
        if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteSmallAndLocalFull) {
            [self.view insertSubview:_localView atIndex:0];
        }
    }];
}

- (void)dealloc {
    [self invalidate];
    DMLogFunc
}

@end
