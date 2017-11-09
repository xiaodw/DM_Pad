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
#import "DMSignalingKey.h"
#import "DMGeTuiManager.h"
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
    self.items = [NSArray arrayWithObjects:DMTitleHome, DMTitleCourseList, DMTitleContactCustomerService, nil];
    self.imageItems = [NSArray arrayWithObjects:@"home_icon", @"course_icon", @"customer_icon", nil];
    self.selImageItems = [NSArray arrayWithObjects:@"home_icon_sel", @"course_icon_sel", @"customer_icon_sel", nil];
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self updateUserInfo];
}

//废弃的方法
//- (void)updateUserInfo {
//    NSString *headUrl = [DMAccount getUserHeadUrl];
//    [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:HeadPlaceholderName];
//    self.headView.nameLabel.text = [DMAccount getUserName];
//}

- (void)clickLoginOut:(id)sender {
    WS(weakSelf)
    DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:@"" message:Logout_Msg preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleCancel otherTitle:DMTitleOK, nil];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        NSLog(@"%ld",index);
        if (index == 1) {
            [weakSelf logoutSystem:@""];
        }
    }];

}

- (void)logoutSystem:(NSString *)msg {
    
    [DMApiModel logoutSystem:^(BOOL result) {
        if (result) {
            
            [[DMGeTuiManager shareInstance] unbindAliasGT:[DMSignalingKey MD5:[DMAccount getUserID]]
                                           andSequenceNum:[[DMGeTuiManager shareInstance] clientIdGT]
                                                andIsSelf:YES];
            
            [DMCommonModel removeUserAllDataAndOperation];
            [APP_DELEGATE toggleRootView:YES];
            if (!STR_IS_NIL(msg)) {
                [DMTools showAlertLogout:msg];
            }
        }
    }];
}

#pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dmRootViewController togglePage:indexPath.row]; //0 主页 ，1 课表，2 客服
    [self refreshTable];
}

- (void)refreshTable {
    [self.tableView reloadData];
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
    
    cell.redView.hidden = YES;
    if (APP_DELEGATE.dmrVC.selectedIndex == indexPath.row) {
        [cell configObj:[_items objectAtIndex:indexPath.row] imageName:[_selImageItems objectAtIndex:indexPath.row]];
        cell.redView.hidden = NO;
    } else {
        [cell configObj:[_items objectAtIndex:indexPath.row] imageName:[_imageItems objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)loadUI {
    
    UIButton *loginOutBtn = [self loadLoginOutView];
    [self.view addSubview:loginOutBtn];
    
    self.headView = [[DMMenuHeadView alloc] initWithFrame:CGRectMake(0, 0, 150, 73)];
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
    [loginOut setTitle:DMTitleExitLogin forState:UIControlStateNormal];
    [loginOut setImage:[UIImage imageNamed:@"logout_icon"] forState:UIControlStateNormal];
    [loginOut setTitleColor:DMColorWithRGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [loginOut.titleLabel setFont:DMFontPingFang_Light(14)];
    [loginOut addTarget:self action:@selector(clickLoginOut:) forControlEvents:UIControlEventTouchUpInside];
    //[loginOut setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -24, -28.0, 0.0)];
    [loginOut setImageEdgeInsets:UIEdgeInsetsMake(0, -5.0, 0.0, 5)];
    return loginOut;
}

@end



