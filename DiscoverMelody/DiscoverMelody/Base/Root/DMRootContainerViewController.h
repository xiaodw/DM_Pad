//
//  DMRootContainerViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMRootViewController;

@interface DMRootContainerViewController : UIViewController

@property (weak, readwrite, nonatomic) DMRootViewController *dmRootViewController;
@property (assign, readwrite, nonatomic) BOOL animateApperance;
@property (strong, readonly, nonatomic) UIView *containerView;

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;
- (void)hide;
- (void)resizeToSize:(CGSize)size;
- (void)hideWithCompletionHandler:(void(^)(void))completionHandler;

@end
