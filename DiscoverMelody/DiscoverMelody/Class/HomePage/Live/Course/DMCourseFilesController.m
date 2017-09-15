
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
#import "DMBrowseCourseView.h"

#define kCourseFileCellID @"Courseware"
#define kLeftMargin 15
#define kRightMargin 15
#define kColumnSpacing 15
#define kColumns 3

@interface DMCourseFilesController () <DMBottomBarViewDelegate, DMTabBarViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, DMBrowseCourseViewDelegate>

@property (strong, nonatomic) UIButton *rightBarButton;

@property (strong, nonatomic) DMTabBarView *tabBarView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DMBottomBarView *bottomBar;
@property (strong, nonatomic) DMBrowseCourseView *browseCourseView;

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
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    
    self.title = @"本课文件";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]}];;
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBar];
    
    [_tabBarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(64);
        make.height.equalTo(50);
    }];
    
    [_bottomBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
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

- (void)didTapBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tabBarView:(DMTabBarView *)tabBarView didTapBarButton:(UIButton *)button{
    self.editorMode = NO;
    self.currentCpirses = self.identifierCpirsesArray[button.tag];
}

- (void)rowseCourseView:(DMBrowseCourseView *)rowseCourseView deleteIndexPath:(NSIndexPath *)indexPath {
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
    _selectedCpirses = nil;
    _selectedIndexPath = nil;
    self.bottomBar.syncButton.enabled = NO;
    self.bottomBar.deleteButton.enabled = NO;
    self.rightBarButton.selected = NO;
}

- (void)reSetSelectedCpirsesIndex {
    for (int i = 0; i < self.selectedCpirses.count; i++) {
        DMCourseModel *courseModel = self.selectedCpirses[i];
        courseModel.selectedIndex = i+1;
    }
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
        _collectionView.backgroundColor = self.view.backgroundColor;
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

- (DMBrowseCourseView *)browseCourseView {
    if (!_browseCourseView) {
        _browseCourseView = [DMBrowseCourseView new];
        _browseCourseView.delegate = self;
    }
    
    return _browseCourseView;
}

- (void)setupData {
    _identifierCpirsesArray = @[@[[DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
                                  [DMCourseModel new]],
                                @[[DMCourseModel new], [DMCourseModel new], [DMCourseModel new], [DMCourseModel new],
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
                                  [DMCourseModel new], [DMCourseModel new]]
                                ];
}

@end
