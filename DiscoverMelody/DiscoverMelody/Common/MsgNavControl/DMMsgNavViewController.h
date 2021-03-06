//
//  DMMsgNavViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/11/17.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMTransitioningAnimationHelper.h"
@interface DMMsgNavViewController : UIViewController
@property (nonatomic, copy) NSString *lessonID;
@property (nonatomic, assign) NSInteger navType;
@property (nonatomic, strong) DMTransitioningAnimationHelper *animationHelper;
@end
