//
//  DMMenuViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMMenuViewController.h"
#import "DMMenuHeadView.h"
#import "DMMenuCell.h"

@interface DMMenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DMMenuHeadView *headView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *imageItems;
@property (nonatomic, strong) NSArray *selImageItems;
@end

@implementation DMMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.items = [NSArray arrayWithObjects:@"个人主页", @"课程列表", @"联系客服", nil];
    self.imageItems = [NSArray arrayWithObjects:@"home_icon", @"course_icon", @"customer_icon", nil];
    self.selImageItems = [NSArray arrayWithObjects:@"home_icon_sel", @"course_icon_sel", @"customer_icon_sel", nil];
    [self loadUI];
    [self updateUserInfo];
}

- (void)updateUserInfo {
    [self.headView.headImageView sd_setImageWithURL:nil placeholderImage:DMPlaceholderImageDefault];
    self.headView.nameLabel.text = @"用户姓名";
}

- (void)clickLoginOut:(id)sender {

}

#pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dmRootViewController togglePage:indexPath.row]; //0 主页 ，1 课表，2 客服
    //DMMenuCell *cell = (DMMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    //[cell configObj:[_items objectAtIndex:indexPath.row] imageName:[_selImageItems objectAtIndex:indexPath.row]];
    [tableView reloadData];
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"menuCell";
    DMMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[DMMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (APP_DELEGATE.dmrVC.selectedIndex == indexPath.row) {
        [cell configObj:[_items objectAtIndex:indexPath.row] imageName:[_selImageItems objectAtIndex:indexPath.row]];
    } else {
        [cell configObj:[_items objectAtIndex:indexPath.row] imageName:[_imageItems objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)loadUI {
    
    UIButton *loginOutBtn = [self loadLoginOutView];
    [self.view addSubview:loginOutBtn];
    
    self.headView = [[DMMenuHeadView alloc] initWithFrame:CGRectMake(0, 0, 150, 193)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = self.headView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled =NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [loginOutBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo(34);
    }];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.equalTo(150);
        make.bottom.equalTo(loginOutBtn.mas_top).offset(0);
    }];
}

- (UIButton *)loadLoginOutView {
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOut setImage:[UIImage imageNamed:@"logout_icon"] forState:UIControlStateNormal];
    [loginOut setTitleColor:DMColorWithRGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [loginOut.titleLabel setFont:DMFontPingFang_Light(14)];
    [loginOut addTarget:self action:@selector(clickLoginOut:) forControlEvents:UIControlEventTouchUpInside];
    //[loginOut setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -24, -28.0, 0.0)];
    [loginOut setImageEdgeInsets:UIEdgeInsetsMake(0, -5.0, 0.0, 5)];
    return loginOut;
}

@end



