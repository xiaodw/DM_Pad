//
//  DMTransitioningAnimationHelper.m
//  专场动画
//
//  Created by My mac on 2017/9/14.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMTransitioningAnimationHelper.h"
#import "DMPresentationController.h"
#define DMScreenHeight [UIScreen mainScreen].bounds.size.height
#define DMScreenWidth [UIScreen mainScreen].bounds.size.width


@interface DMTransitioningAnimationHelper() 

@property (assign, nonatomic) BOOL isShowPopView;

@end

@implementation DMTransitioningAnimationHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        _closeAnimate = YES;
    }
    return self;
}

// 谁负责专场动画
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    DMPresentationController *presentationController = [[DMPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentationController.coverBackgroundColor = self.coverBackgroundColor;
    presentationController.presentFrame = self.presentFrame;
    presentationController.closeAnimate = _closeAnimate;
    return presentationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isShowPopView = YES;
    
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isShowPopView = NO;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.animationType == DMTransitioningAnimationRight) {
        if(_isShowPopView) {
            UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            toView.transform = CGAffineTransformMakeTranslation(self.presentFrame.size.width, 0);
            UIView *containerView = transitionContext.containerView;
            [containerView addSubview:toView];
            
            [UIView animateWithDuration:[self transitionDuration:nil] animations:^{
                toView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            return;
        }
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:[self transitionDuration:nil] animations:^{
            fromView.transform = CGAffineTransformMakeTranslation(self.presentFrame.size.width, 0);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        return;
    }
    
    
    if(_isShowPopView) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.transform = CGAffineTransformMakeTranslation(-self.presentFrame.size.width, 0);
        UIView *containerView = transitionContext.containerView;
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:[self transitionDuration:nil] animations:^{
            toView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        return;
    }
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [UIView animateWithDuration:[self transitionDuration:nil] animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(-self.presentFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
