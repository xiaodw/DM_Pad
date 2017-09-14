
//
//  DMCourseFilesController.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCourseFilesController.h"
#import "DMCoursewareFallsView.h"
#import "DMTabBarView.h"

#define kCoursewareCellID @"Courseware"
#define kLeftMargin 15
#define kRightMargin 15
#define kColumnSpacing 15
#define kColumns 3

@interface DMCourseFilesController ()

@property (strong, nonatomic) UIButton *rightBarButton;

@property (assign, nonatomic) BOOL isSelectMode;

@property (strong, nonatomic) DMTabBarView *tabBarView;
@property (strong, nonatomic) DMCoursewareFallsView *collectionView;

@property (strong, nonatomic) NSArray *identifierCpirsesArray;
@property (strong, nonatomic) NSArray *currentCpirses;

@end

@implementation DMCourseFilesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本课文件";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]}];;
    
//    self.view.backgroundColor = [UIColor greenColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tabBarView];
    [_tabBarView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(64);
        make.height.equalTo(50);
    }];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_tabBarView.mas_bottom);
    }];

//    _collectionView.datas = [@[@"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=25056172,979055862&fm=173&s=CF024F8D60A1AEF05CB0313D03009042&w=218&h=146&img.JPEG",
//                               @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1316902281,1296122404&fm=173&s=ED1A4D9952121FC21628D509030070D0&w=218&h=146&img.JPEG",
//                               @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1316902281,1296122404&fm=173&s=ED1A4D9952121FC21628D509030070D0&w=218&h=146&img.JPEG",
//                               @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1316902281,1296122404&fm=173&s=ED1A4D9952121FC21628D509030070D0&w=218&h=146&img.JPEG",
//                               @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1316902281,1296122404&fm=173&s=ED1A4D9952121FC21628D509030070D0&w=218&h=146&img.JPEG",
//                               @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1316902281,1296122404&fm=173&s=ED1A4D9952121FC21628D509030070D0&w=218&h=146&img.JPEG"] mutableCopy];
    
    _collectionView.datas = [@[@"1", @"2"] mutableCopy];
    
    self.tabBarView.titles = @[@"老师上传的文件",@"学生上传的文件"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView.collectionView reloadData];
}

- (void)didTapSelect:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        // 处理
    }
    [self.collectionView updateCollectionViewStatus:self.isSelectMode];
}

- (void)didTapBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [UIButton new];
        [_rightBarButton setTitle:@"选择" forState:UIControlStateNormal];
        [_rightBarButton setTitle:@"取消" forState:UIControlStateSelected];
        _rightBarButton.titleLabel.font = DMFontPingFang_Thin(16);
        [_rightBarButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        _rightBarButton.frame = CGRectMake(0, 0, 34, 30);
        [_rightBarButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightBarButton;
}

- (DMCoursewareFallsView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[DMCoursewareFallsView alloc] initWithFrame:CGRectZero columns:kColumns lineSpacing:kColumnSpacing columnSpacing:kColumnSpacing leftMargin:kLeftMargin rightMargin:kRightMargin];
        _collectionView.backgroundColor = [UIColor randomColor];
    }
    
    return _collectionView;
}

- (DMTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [DMTabBarView new];
    }
    
    return _tabBarView;
}

@end
