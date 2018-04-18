#import "DMCourseFilesController.h"
#import "DMCourseFileCell.h"
#import "DMTabBarView.h"
#import "DMBottomBarView.h"
#import "DMClassFileDataModel.h"
#import "DMBrowseCourseController.h"
#import "DMBrowseView.h"
#import "DMUploadController.h"
#import "DMLiveController.h"
#import "DMLiveVideoManager.h"
#import "DMSendSignalingMsg.h"
#import "DMBarButtonItem.h"
#import "DMNavigationBar.h"

#define kCourseFileCellID @"Courseware"

@interface DMCourseFilesController () <DMBottomBarViewDelegate, DMTabBarViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, DMBrowseCourseControllerDelegate, DMBrowseViewDelegate, DMUploadControllerDelegate>

@property (strong, nonatomic) DMNavigationBar *navigationBar;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *closeBackgroundView;
@property (strong, nonatomic) UIView *notFileView;

@property (strong, nonatomic) DMBrowseView *browseView;
@property (strong, nonatomic) DMTabBarView *tabBarView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DMBottomBarView *bottomBar;

@property (strong, nonatomic) NSArray *identifierCpirsesArray;
@property (strong, nonatomic) NSMutableArray *currentCpirses;
@property (strong, nonatomic) NSMutableArray *selectedCpirses;
@property (strong, nonatomic) NSMutableArray *selectedIndexPath;

@property (assign, nonatomic, getter=isEditorMode) BOOL editorMode;
@property (assign, nonatomic) BOOL isSyncBrowsing;
@property (assign, nonatomic) NSInteger userIdentity;

@end

@implementation DMCourseFilesController

#pragma mark - Set Methods
- (void)setCurrentCpirses:(NSMutableArray *)currentCpirses {
    _currentCpirses = currentCpirses;
    
    _notFileView.hidden = currentCpirses.count;
    [self.collectionView reloadData];
    if (currentCpirses.count == 0) return;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentCpirses.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

- (void)setEditorMode:(BOOL)editorMode {
    _editorMode = editorMode;
    self.bottomBar.uploadButton.enabled = !self.isEditorMode;
    if (self.bottomBar.uploadButton.enabled) {
        // 复原处理
        [self reinstateSelectedCpirses];
        self.navigationBar.rightBarButton.selected = NO;
    }
    
    if (_isSyncBrowsing) {
        _isSyncBrowsing = NO;
        [self.browseView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.equalTo(_navigationBar);
            make.bottom.equalTo(_bottomBar);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutSubviews];
        }];
    }
}

#pragma mark - Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    NSInteger userIdentity = [[DMAccount getUserIdentity] integerValue]; // 当前身份 0: 学生, 1: 老师
    self.userIdentity = userIdentity;
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    
    NSString *identifier = userIdentity ? DMTitleStudentUploadFild : DMTitleTeacherUploadFild;
    self.tabBarView.titles = @[DMTitleMyUploadFild,identifier];
    
    WS(weakSelf)
    [DMActivityView showActivity:self.collectionView];
    [DMApiModel getLessonList:self.lessonID block:^(BOOL result, NSArray *teachers, NSArray *students) {
        [DMActivityView hideActivity];
        NSMutableArray *teacherCourses = [NSMutableArray arrayWithArray:teachers];
        NSMutableArray *studentCourses = [NSMutableArray arrayWithArray:students];
        weakSelf.identifierCpirsesArray = userIdentity ? @[teacherCourses, studentCourses] : @[studentCourses, teacherCourses];
        weakSelf.currentCpirses = weakSelf.identifierCpirsesArray.firstObject;
    }];
}

#pragma mark - Functions
- (void)didTapSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_isSyncBrowsing) {
        _isSyncBrowsing = NO;
        [self.browseView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.equalTo(_navigationBar);
            make.bottom.equalTo(_bottomBar);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutSubviews];
        }];
    }
    self.editorMode = sender.selected;
    [self.collectionView reloadData];
}

- (void)dismissController {
    [self.liveVC.presentVCs removeObject:self];
    self.liveVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapBack {
    if (_isSyncBrowsing) {
        [self.browseView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.equalTo(_navigationBar);
            make.bottom.equalTo(_bottomBar);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutSubviews];
        } completion:^(BOOL finished) {
            [self dismissController];
        }];
        return;
    }
    [self dismissController];
}

#pragma mark - DMTabBarViewDelegate
- (void)tabBarView:(DMTabBarView *)tabBarView didTapBarButton:(UIButton *)button{
    self.editorMode = NO;
    self.bottomBar.syncButton.hidden = _isFullScreen || !self.userIdentity;
    self.navigationBar.rightBarButton.hidden = button.tag && (!self.userIdentity || _isFullScreen);
    self.bottomBar.deleteButton.hidden = button.tag;
    self.bottomBar.uploadButton.hidden = button.tag;
    self.bottomBar.hidden = NO;
    CGFloat bottom = 0;
    if ((!self.userIdentity || self.isFullScreen) && button.tag) {
        bottom = 50;
    }
    [_bottomBar remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(_tabBarView);
        make.height.equalTo(50);
        make.bottom.equalTo(self.view.mas_bottom).offset(bottom);
    }];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        self.bottomBar.hidden = !self.userIdentity && button.tag;
    }];
    if (self.identifierCpirsesArray.count == 0) return;
    self.currentCpirses = self.identifierCpirsesArray[button.tag];
}

#pragma mark - DMBrowseCourseControllerDelegate
- (void)browseCourseController:(DMBrowseCourseController *)browseCourseController deleteIndexPath:(NSIndexPath *)indexPath {
    DMClassFileDataModel *course = self.currentCpirses[indexPath.row];
    [self.currentCpirses removeObject:course];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - DMBottomBarViewDelegate
// 上传
- (void)botoomBarViewDidTapUpload:(DMBottomBarView *)botoomBarView {
    DMLogFunc
    
    DMUploadController *assetsVC = [DMUploadController new];
    assetsVC.lessonID = self.lessonID;
    assetsVC.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:assetsVC];
    [assetsVC view];
    self.animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
    self.animationHelper.coverBackgroundColor = _isFullScreen ? [[UIColor blackColor] colorWithAlphaComponent:0.6] : [UIColor clearColor];
    nvc.transitioningDelegate = self.animationHelper;
    nvc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nvc animated:YES completion:nil];
    
    assetsVC.liveVC = self.liveVC;
    [self.liveVC.presentVCs addObject:assetsVC];
}

// 同步
- (void)botoomBarViewDidTapSync:(DMBottomBarView *)botoomBarView {
    DMLogFunc
    self.isSyncBrowsing = YES;
    
    [self.browseView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabBarView.mas_right);
        make.right.top.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutSubviews];
    }];
    
    self.bottomBar.syncButton.enabled = NO;
    self.bottomBar.deleteButton.enabled = NO;
    self.browseView.isFirst = YES;
    self.browseView.courses = self.selectedCpirses;
}

// 删除
- (void)botoomBarViewDidTapDelete:(DMBottomBarView *)botoomBarView {
    DMLogFunc
    WS(weakSelf)
    DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:DMTitleDeletedPhotos message:DMTitleDeletedPhotosMessage preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleCancel otherTitle:DMTitleOK, nil];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index == 1) { // 右侧
            [DMActivityView showActivityCover:weakSelf.view];
            NSMutableString *fileIDs = [NSMutableString string];
            for (int i = 0; i < weakSelf.selectedCpirses.count; i++) {
                DMClassFileDataModel *fileDataModel = weakSelf.selectedCpirses[i];
                [fileIDs appendString:fileDataModel.ID];
                if (i != weakSelf.selectedCpirses.count-1) [fileIDs appendString:@","];
            }
            
            [DMApiModel removeLessonFiles:weakSelf.lessonID fileIds:fileIDs block:^(BOOL result) {
                [DMActivityView hideActivity];
                if (!result) return;
                [weakSelf.currentCpirses removeObjectsInArray:weakSelf.selectedCpirses];
                [weakSelf didTapSelect:weakSelf.navigationBar.rightBarButton];
                weakSelf.notFileView.hidden = weakSelf.currentCpirses.count;
            }];
            
        }
    }]; 
}

// 同步接口
#pragma mark - DMBrowseViewDelegate
- (void)browseViewDidTapSync:(DMBrowseView *)browseView{
    self.liveVC.isRemoteUserOnline = YES;
    if (!self.liveVC.isRemoteUserOnline) {
        DMAlertMananger *alert = [[DMAlertMananger shareManager] creatAlertWithTitle:DMAlertTitleNotSync message:@"" preferredStyle:UIAlertControllerStyleAlert cancelTitle:DMTitleOK otherTitle: nil];
        [alert showWithViewController:self IndexBlock:^(NSInteger index) { }];
        return;
    }
    
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:DMSignalingCode_Start_Syn sourceData:self.selectedCpirses index:0];
    WS(weakSelf)
    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
        if (![weakSelf.delegate respondsToSelector:@selector(courseFilesController:syncCourses:)]){
            [weakSelf dismissController];
            return;
        }
        
        [weakSelf.liveVC.presentVCs removeObject:weakSelf];
        weakSelf.liveVC = nil;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [weakSelf.delegate courseFilesController:weakSelf syncCourses:weakSelf.selectedCpirses];
        }];
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        
    }];
}

#pragma mark - DMUploadControllerDelegate
- (void)uploadController:(DMUploadController *)uploadController successAsset:(NSArray *)assets {
    [self.currentCpirses addObjectsFromArray:assets];
    self.currentCpirses = self.currentCpirses;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentCpirses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DMCourseFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseFileCellID forIndexPath:indexPath];
    cell.editorMode = self.isEditorMode;
    cell.courseModel = self.currentCpirses[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_editorMode){
        if(_isFullScreen) {
            DMBrowseCourseController *browseCourseVC = [DMBrowseCourseController new];
            browseCourseVC.isNotSelf = [self.identifierCpirsesArray indexOfObject:self.currentCpirses];
            browseCourseVC.lessonID = self.lessonID;
            CGFloat width = DMScreenWidth;
            CGFloat height = DMScreenHeight - 50;
            browseCourseVC.itemSize = CGSizeMake(width, height);
            browseCourseVC.browseDelegate = self;
            browseCourseVC.currentIndexPath = indexPath;
            browseCourseVC.courses = self.currentCpirses;
            browseCourseVC.modalPresentationStyle = UIModalPresentationCustom;
            
            self.animationHelper.coverBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            self.animationHelper.closeAnimate = NO;
            browseCourseVC.transitioningDelegate = self.animationHelper;
            [self presentViewController:browseCourseVC animated:NO completion:nil];
            return;
        }
        
        DMBrowseCourseController *browseCourseVC = [DMBrowseCourseController new];
        browseCourseVC.isNotSelf = [self.identifierCpirsesArray indexOfObject:self.currentCpirses];
        browseCourseVC.lessonID = self.lessonID;
        CGFloat width = DMScreenWidth * 0.5;
        CGFloat height = DMScreenHeight - 50;
        browseCourseVC.itemSize = CGSizeMake(width, height);
        browseCourseVC.browseDelegate = self;
        browseCourseVC.currentIndexPath = indexPath;
        browseCourseVC.courses = self.currentCpirses;
        browseCourseVC.modalPresentationStyle = UIModalPresentationCustom;
        
        self.animationHelper.coverBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.animationHelper.closeAnimate = NO;
        self.animationHelper.presentFrame = CGRectMake(0, 0, DMScreenWidth * 0.5, DMScreenHeight);
        browseCourseVC.transitioningDelegate = self.animationHelper;
        
        browseCourseVC.liveVC = self.liveVC;
        [self.liveVC.presentVCs addObject:browseCourseVC];
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
    
    self.bottomBar.syncButton.enabled = self.selectedCpirses.count > 0 && !_isSyncBrowsing;
    self.bottomBar.deleteButton.enabled = self.bottomBar.syncButton.enabled;
    
    cell.courseModel = cell.courseModel;
    [self.collectionView reloadData];
    self.browseView.isFirst = NO;
    
    if (self.selectedCpirses.count == 0) {
        _isSyncBrowsing = NO;
        [self.browseView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.equalTo(_navigationBar);
            make.bottom.equalTo(_bottomBar);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutSubviews];
        } completion:^(BOOL finished) {
            self.browseView.courses = self.selectedCpirses;
        }];
        return;
    }
    self.browseView.courses = self.selectedCpirses;
}

#pragma mark - Other
- (void)reinstateSelectedCpirses {
    for (int i = 0; i < self.selectedCpirses.count; i++) {
        DMClassFileDataModel *courseModel = self.selectedCpirses[i];
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
        DMClassFileDataModel *courseModel = self.selectedCpirses[i];
        courseModel.selectedIndex = i+1;
    }
}

#pragma mark - AddSubviews
- (void)setupMakeAddSubviews {
    [self.view addSubview:self.closeBackgroundView];
    [self.view addSubview:self.browseView];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.notFileView];
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:self.bottomBar];
}

#pragma mark - LayoutSubviews
- (void)setupMakeLayoutSubviews {
    [_closeBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.height.equalTo(64);
        CGFloat width = DMScreenWidth*0.5;
        if (_isFullScreen) width = DMScreenWidth;
        make.width.equalTo(width);
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
        make.top.equalTo(_tabBarView.mas_bottom);
    }];
    
    [_browseView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(_navigationBar);
        make.bottom.equalTo(_bottomBar);
    }];
    
    [_notFileView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.centerX.equalTo(self.collectionView);
        make.size.equalTo(CGSizeMake(134, 170));
    }];
}

#pragma mark - Lazy
- (DMNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [DMNavigationBar new];
        
        [_navigationBar.leftBarButton addTarget:self action:@selector(didTapBack) forControlEvents:UIControlEventTouchUpInside];
        _navigationBar.titleLabel.text = DMTextThisClassFile;
        _navigationBar.rightBarButton.selected = YES;
        [_navigationBar.rightBarButton setTitle:DMTitleSelected forState:UIControlStateNormal];
        [_navigationBar.rightBarButton setTitle:DMTitleCancel forState:UIControlStateSelected];
        [_navigationBar.rightBarButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_navigationBar.rightBarButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _navigationBar;
}

- (DMBrowseView *)browseView {
    if (!_browseView) {
        _browseView = [DMBrowseView new];
        _browseView.delegate = self;
    }
    
    return _browseView;
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
        CGFloat width = DMScreenWidth * 0.5;
        if (self.isFullScreen) width = DMScreenWidth;
        CGFloat itemWH = (width - (_columns-1) * _columnSpacing - _leftMargin - _rightMargin) / _columns;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[DMCourseFileCell class] forCellWithReuseIdentifier:kCourseFileCellID];
    }
    
    return _collectionView;
}

- (DMTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [DMTabBarView new];
        _tabBarView.delegate = self;
        _tabBarView.isFullScreen = self.isFullScreen;
        _tabBarView.layer.shadowColor = [UIColor blackColor].CGColor;
        _tabBarView.layer.shadowOffset = CGSizeMake(-3,7);
        _tabBarView.layer.shadowOpacity = 0.07;
        _tabBarView.layer.shadowRadius = 7;
    }
    
    return _tabBarView;
}

- (DMBottomBarView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [DMBottomBarView new];
        _bottomBar.delegate = self;
        _bottomBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomBar.layer.shadowOffset = CGSizeMake(-3,-7);
        _bottomBar.layer.shadowOpacity = 0.03;
        _bottomBar.layer.shadowRadius = 7;
    }
    
    return _bottomBar;
}

- (UIView *)notFileView {
    if (!_notFileView) {
        _notFileView = [UIView new];
        _notFileView.hidden = YES;
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:@"quest_no_teacher_com"];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = DMTextNotCourse;
        titleLabel.font = DMFontPingFang_Light(20);
        titleLabel.textColor = DMColorWithRGBA(204, 204, 204, 1);
        
        [_notFileView addSubview:iconImageView];
        [_notFileView addSubview:titleLabel];
        
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(_notFileView);
            make.size.equalTo(CGSizeMake(134, 118));
        }];
        
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(15);
            make.centerX.equalTo(iconImageView);
        }];
    }
    
    return _notFileView;
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

- (void)dealloc { DMLogFunc }

@end
