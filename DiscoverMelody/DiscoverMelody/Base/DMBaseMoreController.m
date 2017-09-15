//
//  DMBaseMoreController.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseMoreController.h"

@interface DMBaseMoreController ()

@end

@implementation DMBaseMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (DMTransitioningAnimationHelper *)animationHelper {
    if (!_animationHelper) {
        _animationHelper = [DMTransitioningAnimationHelper new];
        _animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth * 0.5, DMScreenHeight);
        _animationHelper.coverBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    
    return _animationHelper;
}

@end
