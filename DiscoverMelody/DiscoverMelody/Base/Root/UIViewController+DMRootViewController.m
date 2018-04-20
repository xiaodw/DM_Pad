//
//  UIViewController+DMRootViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "UIViewController+DMRootViewController.h"
#import "DMRootViewController.h"

@implementation UIViewController (DMRootViewController)

- (void)dm_displaySelectedController:(NSInteger)selectedIndex old:(NSInteger)oldSelectedIndex vc:(UIViewController *)controller
                               frame:(CGRect)frame
                               block:(void(^)(void))completionHandler {
    
    if (selectedIndex == oldSelectedIndex) {
        return;
    }
    controller.view.frame = frame;
    [self transitionFromViewController:[self.childViewControllers objectAtIndex:oldSelectedIndex]
                      toViewController:[self.childViewControllers objectAtIndex:selectedIndex]
                              duration:0 options:UIViewAnimationOptionTransitionNone
                            animations:nil completion:^(BOOL finished) {
        if (finished) {
            [self.view addSubview:[self.childViewControllers objectAtIndex:selectedIndex].view];
        } else {
            [self.view addSubview:[self.childViewControllers objectAtIndex:oldSelectedIndex].view];
        }
        completionHandler();
    }];
}

- (void)dm_addController:(UIViewController *)controller frame:(CGRect)frame {
    
    if (![self.childViewControllers containsObject:controller]) {
        [self addChildViewController:controller];
        controller.view.frame = frame;
        [self.view addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
//    NSLog(@"addchild = %@", self.childViewControllers);
}

- (void)dm_hideController:(UIViewController *)controller {
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
//    NSLog(@"addchild = %@", self.childViewControllers);
}

- (DMRootViewController *)dmRootViewController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[DMRootViewController class]]) {
            return (DMRootViewController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end
