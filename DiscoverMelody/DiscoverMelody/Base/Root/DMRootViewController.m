//
//  DMRootViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMRootViewController.h"
#import "DMRootContainerViewController.h"
#import "UIViewController+DMRootViewController.h"
@interface DMRootViewController ()

@property (assign, readwrite, nonatomic) BOOL visible;
@property (strong, readwrite, nonatomic) DMRootContainerViewController *containerViewController;
@property (strong, readwrite, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, readwrite, nonatomic) BOOL automaticSize;
@property (assign, readwrite, nonatomic) CGSize calculatedMenuViewSize;
@property (nonatomic, strong) UINavigationController *selNav;
@property (nonatomic, strong) UINavigationController *oldNav;

@end

@implementation DMRootViewController
- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
        [self createVC];
        self.selectedIndex = 0;
        self.oldSelectedIndex = 0;
    }
    return self;
}

- (void)commonInit {
    _panGestureEnabled = YES;
    _containerViewController = [[DMRootContainerViewController alloc] init];
    _containerViewController.dmRootViewController = self;
    _menuViewSize = CGSizeZero;
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_containerViewController
                                                                    action:@selector(panGestureRecognized:)];
    _automaticSize = YES;
}

- (void)createVC {
    DMHomeViewController *homeVC = [[DMHomeViewController alloc] init];
    UINavigationController *navHomeVC =
    [[UINavigationController alloc] initWithRootViewController:homeVC];
    DMMenuViewController *menuVC = [[DMMenuViewController alloc] init];
    _menuViewController = menuVC;

    UINavigationController *navClVC =
    [[UINavigationController alloc] init];
    UINavigationController *navSsVC =
    [[UINavigationController alloc] init];
    _contentVCs = [NSMutableArray arrayWithObjects:navHomeVC, navClVC, navSsVC, nil];
    
/*  //原始
    DMHomeViewController *homeVC = [[DMHomeViewController alloc] init];
    DMCourseListController *clVC = [[DMCourseListController alloc] init];
    DMCustomerServiceViewController *ssVC = [[DMCustomerServiceViewController alloc] init];
    UINavigationController *navHomeVC =
    [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController *navClVC =
    [[UINavigationController alloc] initWithRootViewController:clVC];
    UINavigationController *navSsVC =
    [[UINavigationController alloc] initWithRootViewController:ssVC];
    
    DMMenuViewController *menuVC = [[DMMenuViewController alloc] init];
    _menuViewController = menuVC;
    _contentVCs = [NSMutableArray arrayWithObjects:navHomeVC, navClVC, navSsVC, nil];
*/
}

//- (id)initWithContentViewControllers:(NSMutableArray *)contentViewControllers
//                  menuViewController:(UIViewController *)menuViewController {
//    self = [self init];
//    if (self) {
//        _contentVCs = contentViewControllers;
//        _menuViewController = menuViewController;
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    for (int i = 0; i < _contentVCs.count; i++) {
        [self dm_addController:[_contentVCs objectAtIndex:i] frame:self.view.bounds];
    }
    [self togglePage:0];
    [self.view addSubview:self.contentViewController.view];
    NSLog(@"sub = %@",self.view.subviews);
}

- (void)togglePage:(NSInteger)selected {
    self.selectedIndex = selected;
    [self updateContentVCs:selected];
    [self setContentViewController:[_contentVCs objectAtIndex:selected]];
    [self sendVCUpdateNotification];
}

- (void)sendVCUpdateNotification {
    if (self.selectedIndex == self.oldSelectedIndex) {
        return;
    }
    switch (self.selectedIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNotification_HomePage_Key object:nil userInfo:nil];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNotification_CourseList_Key object:nil userInfo:nil];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNotification_CustomerService_Key object:nil userInfo:nil];
            break;
        default:
            break;
    }
    
}

- (void)updateContentVCs:(NSInteger)selected {
    if (self.selectedIndex == self.oldSelectedIndex) {
        return;
    }
    
    if (selected == 1) {
        DMCourseListController *clVC = [[DMCourseListController alloc] init];
        UINavigationController *navClVC = [_contentVCs objectAtIndex:selected];
        [navClVC setViewControllers:@[clVC]];
        //navClVC = [navClVC initWithRootViewController:clVC];
        NSLog(@"%@", [_contentVCs objectAtIndex:selected]);
    } else if (selected == 2) {
        DMCustomerServiceViewController *ssVC = [[DMCustomerServiceViewController alloc] init];
        UINavigationController *navSsVC = [_contentVCs objectAtIndex:selected];
        //navSsVC = [navSsVC initWithRootViewController:ssVC];
        [navSsVC setViewControllers:@[ssVC]];
    }
}

#pragma mark -
#pragma mark Setters

- (void)setContentViewController:(UIViewController *)contentViewController {
    if (!_contentViewController) {
        [self.containerViewController hide];
        _contentViewController = contentViewController;
        return;
    }
    
    WS(weakSelf);
    [self.containerViewController hideWithCompletionHandler:^{
        if (contentViewController) {
            [weakSelf dm_displaySelectedController:_selectedIndex
                                               old:_oldSelectedIndex
                                                vc:contentViewController
                                             frame:weakSelf.view.bounds
                                             block:^{
                                                 _oldSelectedIndex = _selectedIndex;
                                             }];
        }
        _contentViewController = contentViewController;
        
        if ([weakSelf respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [weakSelf performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }];
    
    
//    [self.containerViewController hide];
//
//    if (!_contentViewController) {
//        _contentViewController = contentViewController;
//        return;
//    }
//    
//    if (contentViewController) {
//        [self dm_displaySelectedController:_selectedIndex
//                                       old:_oldSelectedIndex
//                                        vc:contentViewController
//                                     frame:self.view.bounds
//                                     block:^{
//            _oldSelectedIndex = _selectedIndex;
//        }];
//    }
//    _contentViewController = contentViewController;
//    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    if (_menuViewController) {
        [_menuViewController.view removeFromSuperview];
        [_menuViewController removeFromParentViewController];
    }
    
    _menuViewController = menuViewController;
    
    CGRect frame = _menuViewController.view.frame;
    [_menuViewController willMoveToParentViewController:nil];
    [_menuViewController removeFromParentViewController];
    [_menuViewController.view removeFromSuperview];
    _menuViewController = menuViewController;
    if (!_menuViewController)
        return;
    
    [self.containerViewController addChildViewController:menuViewController];
    menuViewController.view.frame = frame;
    [self.containerViewController.containerView addSubview:menuViewController.view];
    [menuViewController didMoveToParentViewController:self];
}

- (void)setMenuViewSize:(CGSize)menuViewSize
{
    _menuViewSize = menuViewSize;
    self.automaticSize = NO;
}

#pragma mark -
- (void)presentMenuViewController {
    [self presentMenuViewControllerWithAnimatedApperance:YES];
}

- (void)presentMenuViewControllerWithAnimatedApperance:(BOOL)animateApperance {
    self.containerViewController.animateApperance = animateApperance;
    self.calculatedMenuViewSize = CGSizeMake(Menu_Width, self.contentViewController.view.frame.size.height);
    [self dm_addController:self.containerViewController frame:self.contentViewController.view.frame];
    self.visible = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//// 是否支持自动转屏
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//// 支持哪些屏幕方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//}
//
//// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
