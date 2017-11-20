//
//  DMQuestionViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/13.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBaseViewController.h"

typedef void (^BlockQuestionBack)();
@interface DMQuestionViewController : DMBaseViewController
@property (nonatomic, strong) BlockQuestionBack blockQuestionBack;
@property (nonatomic, strong) DMCourseDatasModel *courseObj;

- (void)clickBackQuestion:(BlockQuestionBack)blockQuestionBack;
@end
