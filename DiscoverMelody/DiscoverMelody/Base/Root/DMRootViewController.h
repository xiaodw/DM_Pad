//
//  DMRootViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMRootViewControllerDelegate;

@interface DMRootViewController : UIViewController

@property (strong, readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
@property (assign, readwrite, nonatomic) CGSize menuViewSize;

@property (strong, readwrite, nonatomic) UIViewController *contentViewController;
@property (strong, readwrite, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) NSMutableArray *contentVCs;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic) NSInteger oldSelectedIndex;

- (id)initWithContentViewControllers:(NSArray *)contentViewControllers menuViewController:(UIViewController *)menuViewController;
- (void)presentMenuViewController;

- (void)togglePage:(NSInteger)selected;

@end

