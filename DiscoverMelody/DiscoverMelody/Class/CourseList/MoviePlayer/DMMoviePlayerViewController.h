//
//  DMMoviePlayerViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/13.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockVideoVCBack)();

@interface DMMoviePlayerViewController : UIViewController
/** 视频URL */
@property (nonatomic, strong) NSString *lessonID;
@property (nonatomic, strong) NSString *lessonName;
@property (nonatomic, strong) NSString *lessonTime;

@property (nonatomic, strong) BlockVideoVCBack blockVideoVCBack;
- (void)clickVidoBackPlay:(BlockVideoVCBack)blockVideoVCBack;

@end
