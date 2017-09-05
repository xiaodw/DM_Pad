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

@end

@implementation DMRootViewController
- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _panGestureEnabled = YES;
    _containerViewController = [[DMRootContainerViewController alloc] init];
    _containerViewController.dmRootViewController = self;
    _menuViewSize = CGSizeZero;
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_containerViewController action:@selector(panGestureRecognized:)];
    _automaticSize = YES;
}

- (id)initWithContentViewControllers:(NSMutableArray *)contentViewControllers
                  menuViewController:(UIViewController *)menuViewController {
    self = [self init];
    if (self) {
        _contentVCs = contentViewControllers;
        _menuViewController = menuViewController;
    }
    return self;
}


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
    [self setContentViewController:[_contentVCs objectAtIndex:selected]];
}
#pragma mark -
#pragma mark Setters

- (void)setContentViewController:(UIViewController *)contentViewController {
    [self.containerViewController hide];
    
    if (!_contentViewController) {
        _contentViewController = contentViewController;
        return;
    }
    
    if (contentViewController) {
        [self dm_displaySelectedController:_selectedIndex
                                       old:_oldSelectedIndex
                                        vc:contentViewController
                                     frame:self.view.bounds
                                     block:^{
            _oldSelectedIndex = _selectedIndex;
        }];
    }
    _contentViewController = contentViewController;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
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
    self.calculatedMenuViewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/3, self.contentViewController.view.frame.size.height);
    [self dm_addController:self.containerViewController frame:self.contentViewController.view.frame];
    self.visible = YES;
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
