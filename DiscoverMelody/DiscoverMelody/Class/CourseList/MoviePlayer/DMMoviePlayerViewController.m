//
//  DMMoviePlayerViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/13.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMMoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
//#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"
//#import "UINavigationController+ZFFullscreenPopGesture.h"

@interface DMMoviePlayerViewController ()<ZFPlayerDelegate>
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;

@property (nonatomic, copy) NSURL *videoURL;

@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, assign) BOOL isMoreClick;

@end

@implementation DMMoviePlayerViewController

- (void)clickVidoBackPlay:(BlockVideoVCBack)blockVideoVCBack {
    self.blockVideoVCBack = blockVideoVCBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.retryButton];
    [self.playerView playerModel:self.playerModel];
    [self.playerView updateShowPlayerCtr:NO];
    [self getVideReplayUrl];
}

- (void)getVideReplayUrl {
    WS(weakSelf);
    [DMApiModel getVideoReplay:self.lessonID block:^(BOOL result, DMVideoReplayData *obj) {
        if (result) {
            if (obj) {
                weakSelf.playerView.isOnlyTopDisplay = YES;
                weakSelf.videoURL = [NSURL URLWithString:obj.video_url];
                weakSelf.playerModel.videoURL         = weakSelf.videoURL;
                NSString *title = [NSString stringWithFormat:@"%@  %@", obj.title, [DMTools timeFormatterYMDFromTs:obj.start_time format:@"yyyy/MM/dd hh:mm"]];
                weakSelf.playerModel.title            = title;
                [weakSelf.playerView playerModel:weakSelf.playerModel];
                [weakSelf.playerView updateShowPlayerCtr:YES];
                // 自动播放，默认不自动播放
                [weakSelf.playerView autoPlayTheVideo];
            } else {
                [DMTools showSVProgressHudCustom:@"" title:DMAlertTitleVedioNotExist];
                [weakSelf.playerView playerModel:weakSelf.playerModel];
                weakSelf.playerView.isOnlyTopDisplay = NO;
                [weakSelf.playerView updateShowPlayerCtr:NO];
            }

        } else {
            weakSelf.playerView.isOnlyTopDisplay = NO;
            [weakSelf.playerView updateShowPlayerCtr:NO];
            weakSelf.retryButton.hidden = NO;
            [weakSelf.view bringSubviewToFront:weakSelf.retryButton];
        }
    }];
}

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.placeholderImage = [UIImage imageNamed:@"image_login_background"];//[UIImage imageNamed:@"loading_bgView1.png"];
        _playerModel.fatherView       = self.view;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.delegate = self;
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        self.playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryButton.frame = CGRectMake(0, 64, DMScreenWidth, DMScreenHeight-64);
        [_retryButton setTitle:DMTitleVedioRetry forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_retryButton.titleLabel setFont:DMFontPingFang_Regular(14)];
        _retryButton.hidden = YES;
        [_retryButton addTarget:self action:@selector(clickRetryButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

- (void)clickRetryButton:(id)sender {
    self.retryButton.hidden = YES;
    _isMoreClick = YES;
    [self getVideReplayUrl];
}


- (void)zf_playerBackAction {
    
    if (self.blockVideoVCBack) {
        self.blockVideoVCBack();
        self.blockVideoVCBack = nil;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
