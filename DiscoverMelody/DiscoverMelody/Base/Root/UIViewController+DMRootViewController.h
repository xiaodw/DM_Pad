//
//  UIViewController+DMRootViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMRootViewController;

@interface UIViewController (DMRootViewController)

@property (strong, readonly, nonatomic) DMRootViewController *dmRootViewController;
- (void)dm_displaySelectedController:(NSInteger)selectedIndex
                                 old:(NSInteger)oldSelectedIndex
                                  vc:(UIViewController *)controller
                               frame:(CGRect)frame
                               block:(void(^)(void))completionHandler;
- (void)dm_addController:(UIViewController *)controller frame:(CGRect)frame;
- (void)dm_hideController:(UIViewController *)controller;

@end
