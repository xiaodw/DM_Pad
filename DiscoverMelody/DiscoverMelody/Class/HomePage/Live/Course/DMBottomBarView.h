//
//  DMBottomBar.h
//  DiscoverMelody
//
//  Created by My mac on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DMBottomBarView;

@protocol DMBottomBarViewDelegate <NSObject>

@optional
- (void)botoomBarViewDidTapUpload:(DMBottomBarView *)botoomBarView;
- (void)botoomBarViewDidTapSync:(DMBottomBarView *)botoomBarView;
- (void)botoomBarViewDidTapDelete:(DMBottomBarView *)botoomBarView;

@end

@interface DMBottomBarView : UIView

@property (weak, nonatomic) id<DMBottomBarViewDelegate> delegate;

@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIButton *syncButton;
@property (strong, nonatomic) UIButton *deleteButton;

@end
