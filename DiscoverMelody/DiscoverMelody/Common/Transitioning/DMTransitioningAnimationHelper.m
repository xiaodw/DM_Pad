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

// 谁负责专场动画
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    DMPresentationController *presentationController = [[DMPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentationController.coverBackgroundColor = self.coverBackgroundColor;
    presentationController.presentFrame = self.presentFrame;
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
    if(_isShowPopView) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//        UIViewController *toViewVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        toViewVC.delegate?.viewControllerShow(toViewVC)
//        toView.layer.anchorPoint = CGPointMake(0, 1);
        toView.transform = CGAffineTransformMakeTranslation(-DMScreenWidth*0.5, 0);
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
//    UIViewController *fromViewVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    fromViewVC.delegate?.viewControllerHide(fromViewVC)
    [UIView animateWithDuration:[self transitionDuration:nil] animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(-DMScreenWidth*0.5, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
