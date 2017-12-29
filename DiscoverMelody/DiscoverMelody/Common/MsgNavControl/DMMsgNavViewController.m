//
//  DMMsgNavViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/11/17.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMMsgNavViewController.h"
#import "DMQuestionViewController.h"
#import "DMMoviePlayerViewController.h"

@interface DMMsgNavViewController ()

@end

@implementation DMMsgNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:DMFontPingFang_Regular(16)}];
    [self setNavigationbar];
    
    if (self.navType == 2) {
        [self gotoQuestionPage];
    } else if (self.navType == 3) {
        [self gotoPlayerPage];
    }

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)gotoQuestionPage {
    DMQuestionViewController *qtVC = [[DMQuestionViewController alloc] init];
    DMCourseDatasModel *model = [[DMCourseDatasModel alloc] init];
    model.lesson_id = self.lessonID;
    qtVC.courseObj = model;
    [self.navigationController pushViewController:qtVC animated:NO];
    WS(weakSelf)
    qtVC.blockQuestionBack = ^{
        [weakSelf dissVC];
    };
}

- (void)gotoPlayerPage {
    DMMoviePlayerViewController *movieVC = [[DMMoviePlayerViewController alloc] init];
    movieVC.lessonID = self.lessonID;
    [self.navigationController pushViewController:movieVC animated:NO];
    WS(weakSelf)
    movieVC.blockVideoVCBack = ^{
        [weakSelf dissVC];
    };
}

- (void)dissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setNavigationbar {
    [self setLeftBtn:CGRectMake(0, 0, 44, 44) title:@"" titileColor:nil imageName:@"back_icon" font:nil];
}

- (void)leftOneAction:(id)sender {
    
}
- (void)setLeftBtn:(CGRect)frame title:(NSString *)title titileColor:(UIColor *)titleColor imageName:(NSString *)imageName font:(UIFont *)font {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (!STR_IS_NIL(title)) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:font];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    if (!STR_IS_NIL(imageName)) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        if (DM_SystemVersion_11) {
            btn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
    }
    [btn addTarget:self action:@selector(leftOneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = -15;
    //btn.backgroundColor = [UIColor randomColor];
    self.navigationItem.leftBarButtonItems = @[fixedSpace, [[UIBarButtonItem alloc] initWithCustomView:btn]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
