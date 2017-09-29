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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.retryButton];
    [self.playerView playerModel:self.playerModel];
    [self getVideReplayUrl];
}

- (void)getVideReplayUrl {
    WS(weakSelf);
    [DMApiModel getVideoReplay:self.lessonID block:^(BOOL result, DMVideoReplayData *obj) {
        if (result) {
            if (obj) {
                weakSelf.videoURL = [NSURL URLWithString:obj.video_url];
                weakSelf.playerModel.videoURL         = weakSelf.videoURL;
                weakSelf.playerModel.placeholderImage = [UIImage imageNamed:@"image_login_background"];
                [weakSelf.playerView playerModel:weakSelf.playerModel];
                // 自动播放，默认不自动播放
                [weakSelf.playerView autoPlayTheVideo];
            } else {
                [DMTools showSVProgressHudCustom:@"" title:DMAlertTitleVedioNotExist];
                [weakSelf.playerView playerModel:weakSelf.playerModel];
            }

        } else {
            [weakSelf.playerView updateShowPlayerCtr];
            
            weakSelf.retryButton.hidden = NO;
            [weakSelf.view bringSubviewToFront:weakSelf.retryButton];
        }
    }];
    

}

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo {
    // 设置Player相关参数
//    [self configZFPlayer];
}
///**
// *  设置Player相关参数
// */
//- (void)configZFPlayer {
//    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
//    // 初始化playerItem
//    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
//    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
//    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    
//    // 初始化playerLayer
//    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    
//    self.backgroundColor = [UIColor blackColor];
//    // 此处为默认视频填充模式
//    self.playerLayer.videoGravity = self.videoGravity;
//    
//    // 自动播放
//    self.isAutoPlay = YES;
//}


- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = self.lessonName;//DMTitleVedio;
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"image_login_background"];//[UIImage imageNamed:@"loading_bgView1.png"];
        _playerModel.fatherView       = self.view;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        //[_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = YES;
        
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
