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

#pragma mark - UI
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

//@property (strong, nonatomic) UIView *remotePlaceholderView;
//@property (strong, nonatomic) UILabel *remotePlaceholderTitleLabel;
//@property (strong, nonatomic) UIView *localPlaceholderView;
//@property (strong, nonatomic) UILabel *localPlaceholderTitleLabel;

#pragma mark - Other
@property (strong, nonatomic) NSArray *animationImages;
@property (assign, nonatomic) NSInteger tapLayoutCount;
@property (assign, nonatomic) BOOL isCoursewareMode;
@property (assign, nonatomic) DMLayoutMode beforeLayoutMode;

@end

@implementation DMLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoTapped)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self joinChannel];
    
    [self.liveVideoManager switchSound:NO block:^(BOOL success) {
        
    }];
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
        if (self.tapLayoutCount % DMLayoutModeAll == DMLayoutModeAveragDistribution) return;
        if (DMLiveVideoViewType_Local == type) {
            [self didTapLocal];
            return;
        }
        [self didTapRemote];
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

//- (UIView *)remotePlaceholderView {
//    if (!_remotePlaceholderView) {
//        _remotePlaceholderView = [UIView new];
//    }
//    
//    return _remotePlaceholderView;
//}
//
//- (UILabel *)remotePlaceholderTitleLabel {
//    if (!_remotePlaceholderTitleLabel) {
//        _remotePlaceholderTitleLabel = [UILabel new];
//        _remotePlaceholderTitleLabel.textColor = DMColorWithRGBA(102, 102, 102, 1);
//        _remotePlaceholderTitleLabel.font = DMFontPingFang_Light(20);
//    }
//    
//    return _remotePlaceholderTitleLabel;
//}
//
//- (UIView *)localPlaceholderView {
//    if (!_localPlaceholderView) {
//        _localPlaceholderView = [UIView new];
//    }
//    
//    return _localPlaceholderView;
//}
//
//- (UILabel *)localPlaceholderTitleLabel {
//    if (!_localPlaceholderTitleLabel) {
//        _localPlaceholderTitleLabel = [UILabel new];
//        _localPlaceholderTitleLabel.textColor = DMColorWithRGBA(102, 102, 102, 1);
//    }
//    
//    return _localPlaceholderTitleLabel;
//}

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
        _localView.userInteractionEnabled = YES;
        _remoteView.userInteractionEnabled = NO;
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
        _localView.userInteractionEnabled = NO;
        _remoteView.userInteractionEnabled = YES;
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
