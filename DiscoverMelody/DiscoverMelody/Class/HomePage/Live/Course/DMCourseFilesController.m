
//
//  DMCourseFilesController.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCourseFilesController.h"
#import "DMCourseFileCell.h"
#import "DMTabBarView.h"
#import "DMBottomBarView.h"
#import "DMCourseModel.h"
#import "DMBrowseCourseController.h"

#define kCourseFileCellID @"Courseware"
#define kLeftMargin 15
#define kRightMargin 15
#define kColumnSpacing 15
#define kColumns 3

@interface DMCourseFilesController () <DMBottomBarViewDelegate, DMTabBarViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, DMBrowseCourseControllerDelegate>

@property (strong, nonatomic) UIButton *rightBarButton;
@property (strong, nonatomic) UIView *navigationBar;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *closeBackgroundView;

@property (strong, nonatomic) DMTabBarView *tabBarView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DMBottomBarView *bottomBar;

@property (strong, nonatomic) NSArray *identifierCpirsesArray;
@property (strong, nonatomic) NSMutableArray *currentCpirses;
@property (strong, nonatomic) NSMutableArray *selectedCpirses;
@property (strong, nonatomic) NSMutableArray *selectedIndexPath;

@property (assign, nonatomic, getter=isEditorMode) BOOL editorMode;

@end

@implementation DMCourseFilesController

- (void)setCurrentCpirses:(NSMutableArray *)currentCpirses {
    _currentCpirses = currentCpirses;
    
    [self.collectionView reloadData];
}

- (void)setEditorMode:(BOOL)editorMode {
    _editorMode = editorMode;
    self.bottomBar.uploadButton.enabled = !self.isEditorMode;
    if (self.bottomBar.uploadButton.enabled) {
        // 处理
        [self reinstateSelectedCpirses];
        self.rightBarButton.selected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.closeBackgroundView];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBar];
    
    [_closeBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.height.equalTo(64);
        make.width.equalTo(DMScreenWidth*0.5);
    }];
    
    [_backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_navigationBar);
        make.top.equalTo(_navigationBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [_tabBarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_navigationBar);
        make.top.equalTo(_navigationBar.mas_bottom);
        make.height.equalTo(50);
    }];
    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.view);
        make.width.equalTo(_tabBarView);
        make.height.equalTo(50);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(_tabBarView.mas_right).offset(-15);
        make.bottom.equalTo(_bottomBar.mas_top);
        make.top.equalTo(_tabBarView.mas_bottom).offset(15);
    }];
    
#warning 数据请求回来做完判断之后在赋值
    NSString *identifier = [NSString stringWithFormat:@"%@上传的文件", arc4random_uniform(2)%2 ? @"学生" : @"老师"];
    self.tabBarView.titles = @[@"我上传的文件",identifier];
    
    self.currentCpirses = self.identifierCpirsesArray.firstObject;
}

- (void)didTapSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.editorMode = sender.selected;
    [self.collectionView reloadData];
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tabBarView:(DMTabBarView *)tabBarView didTapBarButton:(UIButton *)button{
    self.editorMode = NO;
    self.currentCpirses = self.identifierCpirsesArray[button.tag];
}

- (void)browseCourseController:(DMBrowseCourseController *)browseCourseController deleteIndexPath:(NSIndexPath *)indexPath {
    DMCourseModel *course = self.currentCpirses[indexPath.row];
    [self.currentCpirses removeObject:course];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)botoomBarViewDidTapUpload:(DMBottomBarView *)botoomBarView {
    DMLogFunc
}

- (void)botoomBarViewDidTapSync:(DMBottomBarView *)botoomBarView {
    DMLogFunc
}

- (void)botoomBarViewDidTapDelete:(DMBottomBarView *)botoomBarView {
    DMLogFunc
    
    [self.currentCpirses removeObjectsInArray:self.selectedCpirses];
    [self.collectionView reloadData];
    
    [self resetting];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentCpirses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseFileCellID forIndexPath:indexPath];
    cell.editorMode = self.isEditorMode;
    cell.courseModel = self.currentCpirses[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_editorMode){
//        DMBrowseCourseController *browseCourseVC = [DMBrowseCourseController new];
//        CGFloat width = DMScreenWidth - 80;
//        CGFloat height = DMScreenHeight - 86;
//        browseCourseVC.itemSize = CGSizeMake(width, height);
//        browseCourseVC.courses = self.currentCpirses;
//        browseCourseVC.browseDelegate = self;
//        browseCourseVC.modalPresentationStyle = UIModalPresentationCustom;
//        self.animationHelper.closeAnimate = NO;
//        [self presentViewController:browseCourseVC animated:NO completion:nil];
        
        DMBrowseCourseController *browseCourseVC = [DMBrowseCourseController new];
        CGFloat width = DMScreenWidth * 0.5 - 80;
        CGFloat height = DMScreenHeight - 130;
        browseCourseVC.itemSize = CGSizeMake(width, height);
        browseCourseVC.courses = self.currentCpirses;
        browseCourseVC.browseDelegate = self;
        browseCourseVC.modalPresentationStyle = UIModalPresentationCustom;
        self.animationHelper.coverBackgroundColor = [UIColor clearColor];
        self.animationHelper.closeAnimate = NO;
        browseCourseVC.transitioningDelegate = self.animationHelper;
        [self presentViewController:browseCourseVC animated:NO completion:nil];
        return;
    }
    
    DMCourseFileCell *cell = (DMCourseFileCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectedCpirses containsObject:cell.courseModel]) {
        [self.selectedCpirses removeObject:cell.courseModel];
        [self.selectedIndexPath removeObject:indexPath];
        cell.courseModel.selectedIndex = 0;
        cell.courseModel.isSelected = NO;
        [self reSetSelectedCpirsesIndex];
    } else {
        [self.selectedCpirses addObject:cell.courseModel];
        [self.selectedIndexPath addObject:indexPath];
        cell.courseModel.selectedIndex = self.selectedCpirses.count;
        cell.courseModel.isSelected = YES;
    }
    
    self.bottomBar.syncButton.enabled = self.selectedCpirses.count > 0;
    self.bottomBar.deleteButton.enabled = self.selectedCpirses.count > 0;
    
    cell.courseModel = cell.courseModel;
    [self.collectionView reloadData];
}

- (void)reinstateSelectedCpirses {
    for (int i = 0; i < self.selectedCpirses.count; i++) {
        DMCourseModel *courseModel = self.selectedCpirses[i];
        courseModel.selectedIndex = 0;
        courseModel.isSelected = NO;
    }
    [self resetting];
}

- (void)resetting {
    _selectedCpirses = nil;
    _selectedIndexPath = nil;
    self.bottomBar.syncButton.enabled = NO;
    self.bottomBar.deleteButton.enabled = NO;
}

- (void)reSetSelectedCpirsesIndex {
    for (int i = 0; i < self.selectedCpirses.count; i++) {
        DMCourseModel *courseModel = self.selectedCpirses[i];
        courseModel.selectedIndex = i+1;
    }
}

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [UIView new];
        _navigationBar.backgroundColor = [UIColor blackColor];
//        self.title = @"本课文件";
        
        
        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
//        [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]}];;
    }
    
    return _navigationBar;
}

- (UIButton *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [UIButton new];
        _rightBarButton.titleLabel.font = DMFontPingFang_Thin(16);
        _rightBarButton.frame = CGRectMake(0, 0, 34, 30);
        _rightBarButton.selected = YES;
        [_rightBarButton setTitle:@"选择" forState:UIControlStateNormal];
        [_rightBarButton setTitle:@"取消" forState:UIControlStateSelected];
        [_rightBarButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_rightBarButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightBarButton;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    }
    
    return _backgroundView;
}

- (UIView *)closeBackgroundView{
    if (!_closeBackgroundView) {
        _closeBackgroundView = [UIView new];
        _closeBackgroundView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
        [_closeBackgroundView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _closeBackgroundView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 15;
        CGFloat itemWH = (DMScreenWidth * 0.5 - (kColumns-1) * kColumnSpacing - kLeftMargin - kRightMargin) / kColumns;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _collectionView.prefetchingEnabled = NO;
        
        [_collectionView registerClass:[DMCourseFileCell class] forCellWithReuseIdentifier:kCourseFileCellID];
    }
    
    return _collectionView;
}

- (DMTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [DMTabBarView new];
        _tabBarView.delegate = self;
    }
    
    return _tabBarView;
}

- (DMBottomBarView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [DMBottomBarView new];
        _bottomBar.delegate = self;
    }
    
    return _bottomBar;
}

- (NSMutableArray *)selectedCpirses {
    if (!_selectedCpirses) {
        _selectedCpirses = [NSMutableArray array];
    }
    
    return _selectedCpirses;
}

- (NSMutableArray *)selectedIndexPath {
    if (!_selectedIndexPath) {
        _selectedIndexPath = [NSMutableArray array];
    }
    
    return _selectedIndexPath;
}

- (void)setupData {
    _identifierCpirsesArray = @[[@[[DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new]] mutableCopy],
                                [@[[DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new]] mutableCopy]
                                ];
}

@end
