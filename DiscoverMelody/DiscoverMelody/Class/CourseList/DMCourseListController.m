#import "DMCourseListController.h"

#import "DMCourseListCell.h"
#import "DMCourseListHeaderView.h"

#import "DMMoviePlayerViewController.h"
#import "DMClassFilesViewController.h"
#import "DMQuestionViewController.h"
#import "DMPullDownMenu.h"
#define kCellID @"course"

@interface DMCourseListController () <UITableViewDelegate, UITableViewDataSource, DMCourseListCellDelegate, DMPullDownMenuDelegate>

#pragma mark - UI
@property (strong, nonatomic) UIView *noCourseView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DMCourseListHeaderView *tableViewHeaderView;

#pragma mark - 数据
@property (assign, nonatomic) NSInteger currentPageNumber;
@property (strong, nonatomic) NSMutableArray *courses;
@property (strong, nonatomic) DMPullDownMenu *pullDownMenu;
@property (nonatomic, strong) NSArray *selArray;

@property (nonatomic, assign) DMCourseListCondition clCondition;

@end

@implementation DMCourseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程列表";
    self.view.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
    self.selArray = @[@"全部课程",@"已上课程",@"未上课程"];
    
    [self setRigthBtn:CGRectMake(0, 4.5, 135, 35)
                title:[self.selArray lastObject]
          titileColor:DMColorWithRGBA(246, 246, 246, 1)
            imageName:@"btn_menu_arrow_bottom"
                 font:DMFontPingFang_UltraLight(14)];
    self.clCondition = DMCourseListCondition_WillStart;
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self setupMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNavigationBarNoTransparence];
}

- (void)setupMJRefresh {
    WS(weakSelf)
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPageNumber = 1;
        [weakSelf loadDataList:weakSelf.currentPageNumber];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataList:weakSelf.currentPageNumber];
    }];
//    [footer setTitle:BDCommonLoadNomoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
//    [self loadinghiden];
}

- (void)loadDataList:(NSInteger)currentPageNumber {
    NSLog(@"发送API请求数据");
    WS(weakSelf);
    [DMApiModel getCourseListData:[DMAccount getUserIdentity] sort:@"" page:currentPageNumber condition:[NSString stringWithFormat:@"%ld",self.clCondition] block:^(BOOL result, NSArray *array, BOOL nextPage) {
        if (result && array.count > 0) {
            //请求到了列表数据
            
            NSInteger nextPageNum = currentPageNumber + 1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //        if (!kResponseCode(200)) {
                //            [self endRefreshing];
                //            return;
                //        }
                
                if (currentPageNumber == 1) {
                    [weakSelf.courses removeAllObjects];
                    weakSelf.tableView.mj_footer.hidden = NO;
                }
                
                //        NSArray *data = [responseObject objectForKey:@"data"];
                //        NSArray *moreData = [BDArticleListModel mj_objectArrayWithKeyValuesArray:data];
                [weakSelf.courses addObjectsFromArray:array];
                
                weakSelf.currentPageNumber = nextPageNum;
                [weakSelf endRefreshing];
                if (array) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                weakSelf.noCourseView.hidden = weakSelf.courses.count;
                
                [weakSelf.tableView reloadData];
            });
        }
    }];
 
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.tableViewHeaderView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noCourseView];
    
    [self.navigationController.view addSubview:self.pullDownMenu];
}

- (void)setupMakeLayoutSubviews {
    [_tableViewHeaderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.height.equalTo(60);
        make.left.equalTo(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableViewHeaderView.mas_bottom);
        make.left.right.equalTo(_tableViewHeaderView);
        make.bottom.equalTo(self.view);
    }];
    
    [_noCourseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableViewHeaderView.mas_bottom).offset(185);
        make.size.equalTo(CGSizeMake(134, 170));
        make.centerX.equalTo(_tableViewHeaderView);
    }];

}

#pragma mark - UITableViewDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%zd", self.courses.count);
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.delegate = self;
    cell.contentView.backgroundColor = indexPath.row%2 ? self.view.backgroundColor : [UIColor whiteColor];
    if (indexPath.row < self.courses.count) {
        cell.model = [self.courses objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)pulldownMenu:(DMPullDownMenu *)menu selectedCellNumber:(NSInteger)number // 当选择某个选项时调用
{
    if (number < self.selArray.count) {
        self.currentPageNumber = 1;
        if (number == 0) {
            self.clCondition = DMCourseListCondition_All;
        } else if (number == 1) {
            self.clCondition = DMCourseListCondition_Finish;
        } else {
            self.clCondition = DMCourseListCondition_WillStart;
        }
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)rightOneAction:(id)sender {
    [self.pullDownMenu clickMainBtn:(UIButton *)sender];
}

// 回看
- (void)courseListCellDidTapRelook:(DMCourseListCell *)courseListCell {
    DMMoviePlayerViewController *movieVC = [[DMMoviePlayerViewController alloc] init];
    movieVC.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456316686552The.mp4"];
    [self.navigationController pushViewController:movieVC animated:YES];
}

// 课件
- (void)courseListCellDidTapCoursesFiles:(DMCourseListCell *)courseListCell {
    DMClassFilesViewController *cf = [[DMClassFilesViewController alloc] init];
    cf.courseID = @"";
    [self.navigationController pushViewController:cf animated:YES];
}

// 调查问卷
- (void)courseListCellDidTapQuestionnaire:(DMCourseListCell *)courseListCell {
    DMLogFunc
    DMQuestionViewController *qtVC = [[DMQuestionViewController alloc] init];
    [self.navigationController pushViewController:qtVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[DMCourseListCell class] forCellReuseIdentifier:kCellID];
    }
    
    return _tableView;
}

- (DMCourseListHeaderView *)tableViewHeaderView {
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [DMCourseListHeaderView new];
    }
    
    return _tableViewHeaderView;
}

- (NSMutableArray *)courses {
    if (!_courses) {
        _courses = [NSMutableArray array];
    }
    
    return _courses;
}

- (UIView *)noCourseView {
    if (!_noCourseView) {
        _noCourseView = [UIView new];
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:@"icon_noCourse"];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"暂无课程";
        titleLabel.font = DMFontPingFang_Light(20);
        titleLabel.textColor = DMColorWithRGBA(204, 204, 204, 1);
        
        [_noCourseView addSubview:iconImageView];
        [_noCourseView addSubview:titleLabel];
        
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(_noCourseView);
            make.size.equalTo(CGSizeMake(134, 118));
        }];
        
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(15);
            make.centerX.equalTo(iconImageView);
        }];
    }
    
    return _noCourseView;
}

- (DMPullDownMenu *)pullDownMenu {
    if (!_pullDownMenu) {
        
        //初始化下拉表
        _pullDownMenu = [[DMPullDownMenu alloc] init];
        _pullDownMenu.mainBtn = self.rightButton;
        _pullDownMenu.frame = CGRectMake((self.view.frame.size.width-135-15), 64-self.rightButton.frame.origin.y-4.5, 135, 0);
        [_pullDownMenu setMenuTitles:self.selArray rowHeight:35];
        _pullDownMenu.delegate = self;
    }
    return _pullDownMenu;
}

@end
