//
//  DMCoursewareBottom.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^BlockDidUpload)(void);

typedef void (^BlockDidDelete)(void);
typedef void (^BlockDidSyn)(void);

@interface DMCoursewareBottom : UIView
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) UIButton *synBtn;
@property (nonatomic, strong) UIButton *delBtn;

@property (nonatomic, strong) BlockDidUpload blockDidUpload;
@property (nonatomic, strong) BlockDidDelete blockDidDelete;
@property (nonatomic, strong) BlockDidSyn blockDidSyn;
-(void)didUpload:(BlockDidUpload)blockDidUpload;
-(void)didDelete:(BlockDidDelete)blockDidDelete;
-(void)didSyn:(BlockDidSyn)blockDidSyn;
@end
