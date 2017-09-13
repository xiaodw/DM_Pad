//
//  DMRootContainerViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMRootContainerViewController.h"
#import "UIViewController+DMRootViewController.h"
#import "DMRootViewController.h"

@interface DMRootContainerViewController ()
@property (strong, readwrite, nonatomic) NSMutableArray *backgroundViews;
@property (strong, readwrite, nonatomic) UIView *containerView;
@property (assign, readwrite, nonatomic) CGPoint containerOrigin;
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (assign, readwrite, nonatomic) BOOL limitMenuViewSize;
@property (assign, readwrite, nonatomic) CGFloat backgroundFadeAmount;
@end

@interface DMRootViewController ()

@property (assign, readwrite, nonatomic) BOOL visible;
@property (assign, readwrite, nonatomic) CGSize calculatedMenuViewSize;

@end

@implementation DMRootContainerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _animationDuration = 0.35f;
    _backgroundFadeAmount = 0.3f;
    self.backgroundViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i++) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.0f;
        [self.view addSubview:backgroundView];
        [self.backgroundViews addObject:backgroundView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [backgroundView addGestureRecognizer:tapRecognizer];
    }
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];

    if (self.dmRootViewController.menuViewController) {
        [self addChildViewController:self.dmRootViewController.menuViewController];
        self.dmRootViewController.menuViewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:self.dmRootViewController.menuViewController.view];
        [self.dmRootViewController.menuViewController didMoveToParentViewController:self];
    }
    
    [self.view addGestureRecognizer:self.dmRootViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!self.dmRootViewController.visible) {
        self.dmRootViewController.menuViewController.view.frame = self.containerView.bounds;
        [self setContainerFrame:CGRectMake(- self.dmRootViewController.calculatedMenuViewSize.width, 0, self.dmRootViewController.calculatedMenuViewSize.width, self.dmRootViewController.calculatedMenuViewSize.height)];
        if (self.animateApperance)
            [self show];
    }
}

- (void)setContainerFrame:(CGRect)frame {
    UIView *leftBackgroundView = self.backgroundViews[0];
    UIView *rightBackgroundView = self.backgroundViews[1];
    
    leftBackgroundView.frame = CGRectMake(0, 0, frame.origin.x, self.view.frame.size.height);
    rightBackgroundView.frame = CGRectMake(frame.size.width + frame.origin.x, 0, self.view.frame.size.width - frame.size.width - frame.origin.x, self.view.frame.size.height);

    self.containerView.frame = frame;
}

- (void)setBackgroundViewsAlpha:(CGFloat)alpha {
    for (UIView *view in self.backgroundViews) {
        view.alpha = alpha;
    }
}

- (void)resizeToSize:(CGSize)size {
    [UIView animateWithDuration:_animationDuration animations:^{
        [self setContainerFrame:CGRectMake(0, 0, size.width, size.height)];
        [self setBackgroundViewsAlpha:_backgroundFadeAmount];
    } completion:nil];
    
}

- (void)show {
    void (^completionHandler)(BOOL finished) = ^(BOOL finished) {};

    [UIView animateWithDuration:_animationDuration animations:^{
        [self setContainerFrame:CGRectMake(0, 0, self.dmRootViewController.calculatedMenuViewSize.width, self.dmRootViewController.calculatedMenuViewSize.height)];
        [self setBackgroundViewsAlpha:_backgroundFadeAmount];
    } completion:completionHandler];

}


- (void)hide {
    [self hideWithCompletionHandler:nil];
}

- (void)hideWithCompletionHandler:(void(^)(void))completionHandler {
    void (^completionHandlerBlock)(void) = ^{
        if (completionHandler)
            completionHandler();
    };
    [UIView animateWithDuration:0.1 animations:^{
        [self setBackgroundViewsAlpha:0];
        self.dmRootViewController.visible = NO;
        [self setContainerFrame:CGRectMake(-self.dmRootViewController.calculatedMenuViewSize.width, 0, self.dmRootViewController.calculatedMenuViewSize.width, self.dmRootViewController.calculatedMenuViewSize.height)];
        
    } completion:^(BOOL finished) {
        
        [self.dmRootViewController dm_hideController:self];
        completionHandlerBlock();
    }];

}

#pragma mark -
#pragma mark Gesture recognizer
- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer {
    [self hide];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    if (!self.dmRootViewController.panGestureEnabled)
        return;
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.containerOrigin = self.containerView.frame.origin;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.containerView.frame;

        frame.origin.x = self.containerOrigin.x + point.x;
        if (frame.origin.x > 0) {
            frame.origin.x = 0;
                
            if (!_limitMenuViewSize) {
                frame.size.width = Menu_Width;//self.dmRootViewController.calculatedMenuViewSize.width + self.containerOrigin.x + point.x;
                if (frame.size.width > self.view.frame.size.width)
                    frame.size.width = self.view.frame.size.width;
            }
        }
        
        [self setContainerFrame:frame];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:self.view].x < 0) {
            [self hide];
        } else {
            [self show];
        }
    }
}

@end


