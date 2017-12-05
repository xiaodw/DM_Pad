//
//  AppDelegate.h
//  DiscoverMelody
//
//  Created by Ares on 2017/8/29.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMRootViewController.h"

/*
 ┏┳━━━━━━━━━━━━━━┓
 ┃┃██████████████┃
 ┃┃█████████┏━━┓█┃
 ┣┫█████████┃永┃█┃
 ┃┃█████████┃不┃█┃
 ┃┃█████████┃崩┃█┃
 ┣┫█████████┃溃┃█┃
 ┣┫█████████┃经┃█┃
 ┃┃█████████┗━━┛█┃
 ┣┫██████████████┃
 ┃┃██████████████┃
 ┗┻━━━━━━━━━━━━━━┛
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DMRootViewController *dmrVC;
- (void)toggleRootView:(BOOL)isLogin;
@end

