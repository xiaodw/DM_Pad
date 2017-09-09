#import "DMLiveController.h"
#import "DMLiveButtonControlView.h"
#import "DMLiveVideoManager.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

#define kSmallSize CGSizeMake(DMScaleWidth(240), DMScaleHeight(180))

typedef NS_ENUM(NSInteger, DMLayoutMode) {
    DMLayoutModeRemoteAndSmall, // 远端大, 本地小
    DMLayoutModeSmallAndRemote, // 本地大, 远端小
    DMLayoutModeAveragDistribution, //课件模式 And 左右模式
    DMLayoutModeAll
};

@interface DMLiveController () <DMLiveButtonControlViewDelegate>

@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager;
@property (strong, nonatomic) UIView *remoteView;
@property (strong, nonatomic) UIView *localView;
@property (strong, nonatomic) UIImageView *remoteVoiceImageView;
@property (strong, nonatomic) UIImageView *localVoiceImageView;
@property (strong, nonatomic) DMLiveButtonControlView *controlView;
@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UIImageView *timeImageView;
@property (strong, nonatomic) UILabel *surplusTimeLabel;
@property (strong, nonatomic) UILabel *describeLabel;

@property (strong, nonatomic) NSArray *animationImages;

@property (assign, nonatomic) NSInteger tapLayoutCount;
@property (assign, nonatomic) BOOL isCoursewareMode;
//@property (strong, nonatomic) UIView *smallView;
//@property (strong, nonatomic) UITapGestureRecognizer *smallTGR;
@property (assign, nonatomic) DMLayoutMode beforeLayoutMode;

@end

@implementation DMLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
//    [self setupMakeButtons];
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    
    [self joinChannel];
    
//    [self.liveVideoManager switchSound:NO block:^(BOOL success) {
//        
//    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}


//- (void)setupMakeButtons {
//    // 停止一切等待
//    
//    [self performSelector:@selector(hideControlButtons) withObject:nil afterDelay:3];
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoTapped:)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];
//    self.view.userInteractionEnabled = true;
//}

//- (void)hideControlButtons {
//    self.controlView.hidden = true;
//}
//
//- (void)remoteVideoTapped:(UITapGestureRecognizer *)recognizer {
//    if (self.controlView.hidden) {
//        self.controlView.hidden = false;
//        [self performSelector:@selector(hideControlButtons) withObject:nil afterDelay:3];
//    }
//}

- (void)joinChannel {
    WS(weakSelf)
    [self.liveVideoManager startLiveVideo:self.localView remote:self.remoteView isTapVideo:YES blockAudioVolume:^(NSInteger totalVolume, NSArray *speakers) {
        if (speakers.count == 0) return;
        
        for (int i = 0; i < speakers.count; i++) {
            AgoraRtcAudioVolumeInfo *volumeInfo = speakers[i];
            // (uid == self)
            if (volumeInfo.uid == 10009) {
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
        if (DMLiveVideoViewType_Local == type) {
            NSLog(@"DMLiveVideoViewType_Local");
            return;
        }
        NSLog(@"DMLiveVideoViewType_Remote");
        return;
    }];
}

#pragma mark - 左侧按钮们点击
// 离开
- (void)liveButtonControlViewDidTapLeave:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
    [self.liveVideoManager quitLiveVideo:^(BOOL success) {
        [self.navigationVC popViewControllerAnimated:YES];
    }];
}

// 切换摄像头
- (void)liveButtonControlViewDidTapSwichCamera:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
    [self.liveVideoManager switchCamera];
}

// 切换布局
- (void)liveButtonControlViewDidTapSwichLayout:(DMLiveButtonControlView *)liveButtonControlView {
    DMLogFunc
    
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
    [self.view addSubview:self.localView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.remoteVoiceImageView];
    [self.view addSubview:self.localVoiceImageView];
}

- (void)setupMakeLayoutSubviews {
    [_controlView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(225);
    }];
    
    [_timeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(23);
        make.bottom.equalTo(self.view.mas_bottom).offset(-18);
        make.height.equalTo(20);
        make.right.equalTo(self.view);
    }];
    
    [_remoteView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_localView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(kSmallSize);
        make.top.right.equalTo(self.view);
    }];
    
    [_remoteVoiceImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_remoteView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_remoteView.mas_bottom).offset(-20);
    }];
    
    [_localVoiceImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_localView.mas_right).offset(-15);
        make.size.equalTo(CGSizeMake(16, 25));
        make.bottom.equalTo(_localView.mas_bottom).offset(-20);
    }];
    
}

//- (UITapGestureRecognizer *)smallTGR {
//    if (!_smallTGR) {
//        _smallTGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSmall:)];
//    }
//    
//    return _smallTGR;
//}
//
//- (void)setSmallView:(UIView *)smallView {
//    [_smallView removeGestureRecognizer:self.smallTGR];
//    _smallView.userInteractionEnabled = NO;
//    _smallView = smallView;
//    _smallView.userInteractionEnabled = YES;
//    [_smallView addGestureRecognizer:self.smallTGR];
//}

//- (void)didTapSmall:(UITapGestureRecognizer *)tap {
//    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) return;
//    
//    NSLog(@"%@", tap.view);
//    if (tap.view == self.remoteView) {
//        [self didTapRemote];
//        return;
//    }
//    
//    if (tap.view == self.localView) {
//        [self didTapLocal];
//    }
//}

- (void)didTapRemote {
    self.tapLayoutCount = DMLayoutModeSmallAndRemote;
    [self makeLayoutViews];
//    self.smallView = self.localView;
}

- (void)didTapLocal {
    self.tapLayoutCount = DMLayoutModeRemoteAndSmall;
    [self makeLayoutViews];
//    self.smallView = self.remoteView;
}

- (DMLiveVideoManager *)liveVideoManager {
    if (!_liveVideoManager) {
        _liveVideoManager = [DMLiveVideoManager shareInstance];
    }
    
    return _liveVideoManager;
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
    }
    
    return _remoteView;
}

- (UIView *)localView {
    if (!_localView) {
        _localView = [UIView new];
        _localView.backgroundColor = [UIColor blackColor];
//        _smallView = _localView;
    }
    
    return _localView;
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
        
        [_timeView addSubview:self.timeImageView];
        [_timeView addSubview:self.surplusTimeLabel];
        [_timeView addSubview:self.describeLabel];
        
        [_timeImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(_timeView);
            make.size.equalTo(CGSizeMake(19, 19));
        }];
        
        [_surplusTimeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeImageView.mas_right).offset(10);
            make.centerY.equalTo(_timeImageView);
        }];
        
        [_describeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_surplusTimeLabel.mas_right).offset(20);
            make.centerY.equalTo(_timeImageView);
        }];
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

- (void)dealloc {
    DMLogFunc
}

- (void)makeLayoutViews {
    self.tapLayoutCount += 1;
    [_localView removeFromSuperview];
    [_remoteView removeFromSuperview];
    
    if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeRemoteAndSmall) {
        NSLog(@"3%f", DMScreenWidth);
        [self.view insertSubview:_localView atIndex:0];
        [self.view insertSubview:_remoteView atIndex:0];
        
        [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [_localView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.view);
            make.size.equalTo(kSmallSize);
        }];
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeSmallAndRemote) {
        NSLog(@"1%f", DMScreenWidth);
        [self.view insertSubview:_remoteView atIndex:0];
        [self.view insertSubview:_localView atIndex:0];
        
        [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.equalTo(self.view);
            make.size.equalTo(kSmallSize);
        }];
        
        [_localView remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) {
        NSLog(@"2%f", DMScreenWidth);
        [self.view insertSubview:_remoteView atIndex:0];
        [self.view insertSubview:_localView atIndex:0];
        if (_isCoursewareMode) {
            [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, DMScreenHeight * 0.5));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.left.equalTo(_remoteView);
                make.bottom.equalTo(self.view);
            }];
        }else {
            [_remoteView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.centerY.equalTo(self.view);
                make.size.equalTo(CGSizeMake(DMScreenWidth * 0.5, 385));
            }];
            
            [_localView remakeConstraints:^(MASConstraintMaker *make) {
                make.size.centerY.equalTo(_remoteView);
                make.right.equalTo(self.view);
            }];
        }
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
