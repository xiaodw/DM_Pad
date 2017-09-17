//
//  DMTransitioningAnimationHelper.h
//  专场动画
//
//  Created by My mac on 2017/9/14.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTransitioningAnimationHelper : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) CGRect presentFrame;
@property (strong, nonatomic) UIColor *coverBackgroundColor;
@property (assign, nonatomic, getter=isCloseAnimate) BOOL closeAnimate;

@end
