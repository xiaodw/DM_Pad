//
//  DMMsgWebViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/10/31.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseMoreController.h"
//#import "DMTransitioningAnimationHelper.h"
@interface DMMsgWebViewController : DMBaseMoreController
@property (nonatomic, copy) NSString *msgUrl;
@property (nonatomic, assign) BOOL isHaveToken;
//@property (nonatomic, strong) DMTransitioningAnimationHelper *animationHelper;
@end
