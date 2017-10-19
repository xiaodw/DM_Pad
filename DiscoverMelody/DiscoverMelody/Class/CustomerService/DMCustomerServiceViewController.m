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
#import "DMCustomerDataModel.h"
@interface DMCustomerServiceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *phoneArray;
@property (nonatomic, strong) NSArray *customerArray;

@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, assign) BOOL isFruled;

@property (nonatomic, assign) BOOL havePhone;
@property (nonatomic, assign) BOOL haveCustomer;

@property (nonatomic, strong) NSMutableDictionary *statusDic;

@end

@implementation DMCustomerServiceViewController

- (void)initDataInfo {
    WS(weakSelf);
    [DMApiModel getCustomerInfo:^(BOOL result, DMCustomerDataModel *obj) {
        if (result) {
            if (!OBJ_IS_NIL(obj)) {
                if (obj.tel.count > 0) {
                    weakSelf.phoneArray = obj.tel;
                    _havePhone = YES;
                }
                if (obj.customer.count > 0) {
                    weakSelf.customerArray = obj.customer;
                    _haveCustomer = YES;
                }
                [weakSelf.tableView reloadData];
            }
        }
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:DMTitleContactCustomerService];
    self.view.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);//[UIColor whiteColor];
    _isFruled = YES;
    _phoneArray = [NSArray array];
    _customerArray = [NSArray array];
    [self loadUI];
    [self initDataInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataCSData:) name:DMNotification_CustomerService_Key object:nil];
}

- (void)updataCSData:(NSNotification *)notification {
    [self initDataInfo];
}

- (void)loadUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];//DMColorWithRGBA(246, 246, 246, 1);
    
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = DMTextCustomerServiceDescribe;
    bottomLabel.font = DMFontPingFang_UltraLight(13);
    bottomLabel.textColor = DMColorWithRGBA(153, 153, 153, 1);
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    [self.view addSubview:self.tableView];
    
    [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).equalTo(-30);
        make.height.equalTo(16);
    }];
    
}

- (void)sectionClick:(BOOL)isfurled section:(NSInteger)section {
    
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        if (indexPath.section-1 < self.customerArray.count) {
            DMCustomerTeacher *objList = [self.customerArray objectAtIndex:indexPath.section-1];
            if (indexPath.row < objList.customer_list.count) {
                DMCustomerTeacherInfo *obj = [objList.customer_list objectAtIndex:indexPath.row];
                if (!STR_IS_NIL(obj.img_url)) {
                    DMPopCodeView *codeView = [[DMPopCodeView alloc] initWithTitle:obj.name
                                                                           message:@""//[NSString stringWithFormat:DMStringWeChatNumber, obj.webchat]
                                                                         imageName:obj.img_url];
                    [codeView show];
        
                }
            }
        }
    }
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        if (_haveCustomer) {
            return 70;
        }
    } else {
        if (_havePhone) {
            return 60;
        } else if (_haveCustomer) {
            return 70;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger num = 0;
    if (_haveCustomer) {
        num = self.customerArray.count;
    }
    if (_havePhone) {
        num = num + 1;
    }
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.phoneArray.count;
    }
    
    if (section-1 < self.customerArray.count) {
        DMCustomerTeacher *cT = [self.customerArray objectAtIndex:section-1];
        return cT.isFurled ? 0 : cT.customer_list.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        static NSString *CCell = @"customerPhoneCell";
        DMCustomerPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:CCell];
        if (!cell) {
            cell = [[DMCustomerPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CCell];
        }
        if (indexPath.row < self.phoneArray.count) {
            [cell configObj:[self.phoneArray objectAtIndex:indexPath.row]];
        }
        
        return cell;
    }
    static NSString *ccell = @"customerCell";
    DMCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:ccell];
    if (!cell) {
        cell = [[DMCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ccell];
    }
    if (indexPath.section-1 < self.customerArray.count) {
        DMCustomerTeacher *objList = [self.customerArray objectAtIndex:indexPath.section-1];
        if (indexPath.row < objList.customer_list.count) {
            [cell configObj:[objList.customer_list objectAtIndex:indexPath.row]];
        }
    }
    
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
    DMCustomerTeacher *cT = [self.customerArray objectAtIndex:section-1];
    infoV.blockTapEvent = ^{
        if (section-1 < self.customerArray.count) {
            cT.isFurled = !cT.isFurled;
            [weakSelf sectionClick:cT.isFurled section:section];
        }
    };
    [infoV updateSubViewsObj:cT.customer_region isFurled:cT.isFurled];
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
