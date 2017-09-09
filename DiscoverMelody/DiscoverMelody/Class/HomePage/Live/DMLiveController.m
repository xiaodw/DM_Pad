#import "DMLiveController.h"
#import "DMLiveView.h"
#import "DMLiveButtonControlView.h"

#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface DMLiveController () <AgoraRtcEngineDelegate, DMLiveButtonControlViewDelegate>

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) DMLiveView *remoteView;
@property (strong, nonatomic) DMLiveView *localView;
@property (strong, nonatomic) DMLiveButtonControlView *controlView;
@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UIImageView *timeImageView;
@property (strong, nonatomic) UILabel *surplusTimeLabel;
@property (strong, nonatomic) UILabel *describeLabel;

@property (strong, nonatomic) AgoraRtcVideoCanvas *remoteVideoCanvas;
@property (strong, nonatomic) AgoraRtcVideoCanvas *localVideoCanvas;

@end

@implementation DMLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.controlView];
}

- (void)setupMakeLayoutSubviews {
    [_controlView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(106);
    }];
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
        
        
    }
    
    return _timeView;
}

- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [UIImageView new];
        _timeImageView.image = [UIImage imageNamed:@"icon_time_white"];
    }
    
    return _timeImageView;
}

- (UILabel *)surplusTimeLabel {
    if (!_surplusTimeLabel) {
        _surplusTimeLabel = [UILabel new];
        _surplusTimeLabel.textColor = [UIColor whiteColor];
        _surplusTimeLabel.text = @"00:45:00";
        _surplusTimeLabel.font = DMFontPingFang_Light(14);
    }
    
    return _surplusTimeLabel;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.text = @"本课堂将于15分钟后自动关闭";
        _describeLabel.textColor = DMColorWithRGBA(246, 8, 112, 1);
        _describeLabel.font = DMFontPingFang_Light(14);
    }
    
    return _describeLabel;
}















// Tutorial Step 5
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    NSLog(@"RemoteVideo uid : %zd", uid);
    self.remoteVideoCanvas.uid = uid;
    [self.agoraKit setupRemoteVideo:self.remoteVideoCanvas];
}

- (void)liveButtonControlViewDidTapLeave:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
}

- (void)liveButtonControlViewDidTapSwichCamera:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
}

- (void)liveButtonControlViewDidTapSwichLayout:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
}

- (void)liveButtonControlViewDidTapCourseFiles:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
}

- (AgoraRtcEngineKit *)agoraKit {
    if (!_agoraKit) {
        _agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraAppID delegate:self];
        [_agoraKit enableVideo];
        [_agoraKit setVideoProfile:AgoraRtc_VideoProfile_720P swapWidthAndHeight: false];
        [_agoraKit setupLocalVideo:self.localVideoCanvas];
        [_agoraKit joinChannelByKey:nil channelName:@"demoChannel1" info:nil uid:0 joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
            [self.agoraKit setEnableSpeakerphone:YES];
            [UIApplication sharedApplication].idleTimerDisabled = YES;
        }];
    }
    
    return _agoraKit;
}

- (DMLiveView *)remoteView {
    if (!_remoteView) {
        _remoteView = [DMLiveView new];
    }
    
    return _remoteView;
}

- (DMLiveView *)localView {
    if (!_localView) {
        _localView = [DMLiveView new];
    }
    
    return _localView;
}

- (AgoraRtcVideoCanvas *)localVideoCanvas {
    if (!_localVideoCanvas) {
        _localVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        _localVideoCanvas.view = self.localView;
        _localVideoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    }
    
    return _localVideoCanvas;
}

- (AgoraRtcVideoCanvas *)remoteVideoCanvas {
    if (!_remoteVideoCanvas) {
        _remoteVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        _remoteVideoCanvas.view = self.remoteView;
        _remoteVideoCanvas.renderMode = AgoraRtc_Render_Adaptive;
    }
    
    return _remoteVideoCanvas;
}

@end
