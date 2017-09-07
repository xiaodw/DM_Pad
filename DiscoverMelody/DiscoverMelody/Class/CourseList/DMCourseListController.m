//
//  DMCourseListController.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCourseListController.h"

@interface DMCourseListController ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DMCourseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.left.equalTo(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}
@end
