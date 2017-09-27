#import "DMCourseListController.h"

#import "DMCourseListCell.h"
#import "DMCourseListHeaderView.h"

#import "DMMoviePlayerViewController.h"
//#import "DMClassFilesViewController.h"
#import "DMQuestionViewController.h"
#import "DMPullDownMenu.h"
#define kCellID @"course"
#import "DMCourseFilesController.h"
#import "DMTransitioningAnimationHelper.h"

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
@property (strong, nonatomic) DMTransitioningAnimationHelper *animationHelper;
@property (nonatomic, strong) UIView *bgVV;

@end

@implementation DMCourseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DMTitleCourseList;
    self.view.backgroundColor = DMColorWithRGBA(246, 246, 246, 1);
    self.selArray = @[DMTitleAllCourse,DMTitleAlreadyCourse,DMTitleNotStartCourse];
    
    [self setRigthBtn:CGRectMake(0, 4.5, 135, 35)
                title:[self.selArray lastObject]
          titileColor:DMColorWithRGBA(246, 246, 246, 1)
            imageName:@"btn_menu_arrow_bottom"
                 font:DMFontPingFang_Thin(14)];
    self.clCondition = DMCourseListCondition_WillStart;
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    [self setupMJRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataCourseListData:) name:DMNotification_CourseList_Key object:nil];
}

- (void)updataCourseListData:(NSNotification *)notification {
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setNavigationBarNoTransparence];
}

- (void)setupMJRefresh {
    WS(weakSelf)
     DMRefreshNormalHeader *header = [DMRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPageNumber = 1;
        [weakSelf loadDataList:weakSelf.currentPageNumber];
    }];
    
    header.stateLabel.font = DMFontPingFang_Light(12);
    header.lastUpdatedTimeLabel.font = header.stateLabel.font;
    
    // Set textColor
    header.stateLabel.textColor = DMColorWithHexString(@"#999999");
    header.lastUpdatedTimeLabel.textColor = header.stateLabel.textColor;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataList:weakSelf.currentPageNumber];
    }];
//    [footer setTitle:BDCommonLoadNomoreData forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadDataList:(NSInteger)currentPageNumber {
    WS(weakSelf);
    [DMApiModel getCourseListData:[DMAccount getUserIdentity] page:currentPageNumber condition:[NSString stringWithFormat:@"%ld",self.clCondition] block:^(BOOL result, NSArray *array, BOOL nextPage) {
        if (!result) {
            [weakSelf endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;
            weakSelf.noCourseView.hidden = weakSelf.courses.count;
            return;
        }
        
        //请求到了列表数据
        weakSelf.tableView.mj_footer.hidden = !nextPage;
        NSInteger nextPageNum = currentPageNumber + 1;
        if (currentPageNumber == 1) {
            [weakSelf.courses removeAllObjects];
        }
        
        [weakSelf.courses addObjectsFromArray:array];
        weakSelf.currentPageNumber = nextPageNum;
        [weakSelf endRefreshing];
        if (!nextPage) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        weakSelf.noCourseView.hidden = weakSelf.courses.count;
        [weakSelf.tableView reloadData];
    }];
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.tableViewHeaderView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noCourseView];
    
    UIView *bgVV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, DMScreenHeight)];
    bgVV.backgroundColor = [UIColor clearColor];
    //bgVV.alpha = 0.4;
    [self.navigationController.view addSubview:bgVV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapChange)];
    tap.numberOfTapsRequired = 1;
    [bgVV addGestureRecognizer:tap];
    bgVV.hidden = YES;
    self.bgVV = bgVV;
    
    [self.navigationController.view addSubview:self.pullDownMenu];
}


- (void)doTapChange {
    NSLog(@"点击手势");
    [self.pullDownMenu hidePullDown];
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

- (void)pulldownMenuWillShow:(DMPullDownMenu *)menu    // 当下拉菜单将要显示时调用
{
    self.bgVV.hidden = NO;
}

- (void)pulldownMenuWillHidden:(DMPullDownMenu *)menu   // 当下拉菜单将要收起时调用
{
    self.bgVV.hidden = YES;
}

- (void)rightOneAction:(id)sender {
    [self.pullDownMenu clickMainBtn:(UIButton *)sender];
}

// 回看
- (void)courseListCellDidTapRelook:(DMCourseListCell *)courseListCell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:courseListCell];
    if (indexPath.row < self.courses.count) {
        DMCourseDatasModel *model = [self.courses objectAtIndex:indexPath.row];
        
        DMMoviePlayerViewController *movieVC = [[DMMoviePlayerViewController alloc] init];
        //movieVC.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456316686552The.mp4"];
        movieVC.lessonID = model.lesson_id;
        [self.navigationController pushViewController:movieVC animated:YES];
    }
}

// 课件
- (void)courseListCellDidTapCoursesFiles:(DMCourseListCell *)courseListCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:courseListCell];
    if (indexPath.row < self.courses.count) {
        DMCourseDatasModel *model = [self.courses objectAtIndex:indexPath.row];
        DMCourseFilesController *courseFilesVC = [DMCourseFilesController new];
        courseFilesVC.columns = 6;
        courseFilesVC.leftMargin = 15;
        courseFilesVC.rightMargin = 15;
        courseFilesVC.columnSpacing = 15;
        courseFilesVC.isFullScreen = YES;
        DMTransitioningAnimationHelper *animationHelper = [DMTransitioningAnimationHelper new];
        self.animationHelper = animationHelper;
        animationHelper.animationType = DMTransitioningAnimationRight;
        animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
        courseFilesVC.transitioningDelegate = animationHelper;
        courseFilesVC.modalPresentationStyle = UIModalPresentationCustom;
        courseFilesVC.lessonID = model.lesson_id;
        [self presentViewController:courseFilesVC animated:YES completion:nil];
    }
}

// 调查问卷
- (void)courseListCellDidTapQuestionnaire:(DMCourseListCell *)courseListCell {
    DMLogFunc
    NSIndexPath *indexPath = [self.tableView indexPathForCell:courseListCell];
    if (indexPath.row < self.courses.count) {
        DMCourseDatasModel *model = [self.courses objectAtIndex:indexPath.row];
        DMQuestionViewController *qtVC = [[DMQuestionViewController alloc] init];
        qtVC.courseObj = model;
        [self.navigationController pushViewController:qtVC animated:YES];
    }
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
        iconImageView.image = [UIImage imageNamed:@"quest_no_teacher_com"];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = DMTextNotClass;
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
