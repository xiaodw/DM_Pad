#import "DMCourseListController.h"

#import "DMCourseListCell.h"
#import "DMCourseListHeaderView.h"

#define kCellID @"course"

@interface DMCourseListController () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DMCourseListHeaderView *tableViewHeaderView;

#pragma mark - 数据
@property (assign, nonatomic) NSInteger currentPageNumber;
@property (strong, nonatomic) NSMutableArray *courses;
@property (strong, nonatomic) NSArray *textArray;

@end

@implementation DMCourseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [array addObject:@1];
    }
    _textArray = array;
    
    self.title = @"课程列表";
    self.view.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self setupMJRefresh];
}

- (void)setupMJRefresh {
    WS(weakSelf)
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPageNumber = 0;
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
    
    NSInteger nextPageNum = currentPageNumber + 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (!kResponseCode(200)) {
//            [self endRefreshing];
//            return;
//        }
        
        if (currentPageNumber == 0) {
            self.courses = nil;
            self.tableView.mj_footer.hidden = NO;
        }
        
//        NSArray *data = [responseObject objectForKey:@"data"];
//        NSArray *moreData = [BDArticleListModel mj_objectArrayWithKeyValuesArray:data];
        [self.courses addObjectsFromArray:self.textArray];
        
        self.currentPageNumber = nextPageNum;
        [self endRefreshing];
//        if (最后一条) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            self.tableView.mj_footer.hidden = YES;
//        }
        
        [self.tableView reloadData];
    });
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.tableViewHeaderView];
    [self.view addSubview:self.tableView];
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
}

#pragma mark - UITableViewDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%zd", self.courses.count);
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    cell.contentView.backgroundColor = indexPath.row%2 ? self.view.backgroundColor : [UIColor whiteColor];
    cell.model = [NSObject new];
    return cell;
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

@end
