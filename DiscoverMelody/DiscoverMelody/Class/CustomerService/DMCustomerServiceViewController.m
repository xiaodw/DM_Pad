//
//  DMCustomerServiceViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCustomerServiceViewController.h"
#import "DMCustomerPhoneCell.h"
#import "DMCustomerCell.h"
#import "DMPopCodeView.h"
@interface DMCustomerServiceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *phoneArray;
@property (nonatomic, strong) NSArray *customerArray;

@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, assign) BOOL isFruled;

@property (nonatomic, strong) NSMutableDictionary *statusDic;

@end

@implementation DMCustomerServiceViewController

- (void)initDataInfo {
    self.phoneArray = [NSArray arrayWithObjects:@"咨询电话（中国）", @"咨询电话（北美）", nil];
    
    self.customerArray = [NSArray arrayWithObjects:@"寻律微信客服（中国）", nil];
    
    self.statusDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"1", nil]; //key为section
    
    self.indexArray = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:1];
        [self.indexArray addObject:path];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"联系客服"];
    self.view.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);//[UIColor whiteColor];
    _isFruled = YES;
    [self initDataInfo];
    [self loadUI];
}

- (void)loadUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
    [self.view addSubview:self.tableView];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"如需修改上课时间，了解更多详情，请联系以上任意客服";
    bottomLabel.font = DMFontPingFang_UltraLight(13);
    bottomLabel.textColor = DMColorWithRGBA(153, 153, 153, 1);
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    
    [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).equalTo(-30);
        make.height.equalTo(16);
    }];
    
}

- (void)sectionClick:(BOOL)isfurled {

    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:1];
    if (isfurled) {
        [self.statusDic setObject:@"1" forKey:@"1"];
        //[self.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
    } else {
        [self.statusDic setObject:@"0" forKey:@"1"];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
}

#pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        DMPopCodeView *codeView = [[DMPopCodeView alloc] initWithTitle:@"寻律课程顾问-A老师" message:@"微信号：Dsicover-Melody-1" imageName:@"codeTest"];
        [codeView show];
    }
    
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return 70;
    }
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1+self.customerArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.phoneArray.count;
    }
    return [[self.statusDic objectForKey:[NSString stringWithFormat:@"%ld", (long)section]] boolValue] ?0:self.indexArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        static NSString *CCell = @"customerPhoneCell";
        DMCustomerPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:CCell];
        if (!cell) {
            cell = [[DMCustomerPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CCell];
        }
        
        [cell configObj:nil];
        return cell;
    }
    static NSString *ccell = @"customerCell";
    DMCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:ccell];
    if (!cell) {
        cell = [[DMCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ccell];
    }
    
    [cell configObj:nil];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        if (section != 0) {
            ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WS(weakSelf)
    if (section == 0) {
        UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 15)];
        oneView.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
        return oneView;
    }
    
    static NSString *HeaderIdentifier = @"header";
    DMCustomerInfoView *infoV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if(infoV==nil) {
        infoV = [[DMCustomerInfoView alloc]
                 initWithReuseIdentifier:HeaderIdentifier
                 frame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)
                 isTap:YES blockTapEvent:nil];
    }
    infoV.blockTapEvent = ^{
        BOOL isFurled = [[weakSelf.statusDic objectForKey:[NSString stringWithFormat:@"%ld", section]] boolValue];
        [weakSelf sectionClick:!isFurled];
    };
    [infoV updateSubViewsObj:nil isFurled:[[weakSelf.statusDic objectForKey:[NSString stringWithFormat:@"%ld", section]] boolValue]];
    infoV.tag = section;

    return infoV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 15)];
        oneView.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
        return oneView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 0;
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
