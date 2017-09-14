//
//  DMPresentationController.m
//  专场动画
//
//  Created by My mac on 2017/9/14.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMPresentationController.h"

@interface DMPresentationController ()

@property (strong, nonatomic) UIView *coverView;

@end

@implementation DMPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}

- (void)tapBackgroundView {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)containerViewWillLayoutSubviews {
    
    if (CGRectEqualToRect(self.presentFrame, CGRectZero)) {
        self.presentFrame = [UIScreen mainScreen].bounds;
    }
    
    self.presentedView.frame = self.presentFrame;
    [self.containerView insertSubview:self.coverView atIndex:0];
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.frame = [UIScreen mainScreen].bounds;
        
        _coverView.backgroundColor = self.coverBackgroundColor;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView)];
        [_coverView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _coverView;
}

@end
