//
//  DMHomeViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMHomeViewController.h"
#import "DMRootContainerViewController.h"
#import "UIViewController+DMRootViewController.h"
#import "DMHomeView.h"
@interface DMHomeViewController () <DMHomeVCDelegate>


@property (nonatomic, strong) DMHomeView *homeView;

@end

@implementation DMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"个人主页"];
    [self setNavigationBarTransparence];
    [self.view addSubview:self.homeView];
}

- (DMHomeView *)homeView {
    if (!_homeView) {
        _homeView = [[DMHomeView alloc] initWithFrame:self.view.bounds delegate:self];
    }
    return _homeView;
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    
    return cell;
}
//本课文件
- (void)clickCourseFiles {
    
    NSLog(@"本课文件");
}
//进入课堂
- (void)clickClassRoom {
    
    NSLog(@"进入课堂");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self setNavigationBarTransparence];
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
