//
//  DMClassFilesViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMClassFilesViewController.h"
#import "DMCoursewareFallsView.h"
@interface DMClassFilesViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;//服务器获取的本课文件数据
@property (nonatomic, strong) DMCoursewareFallsView *cfView;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation DMClassFilesViewController

- (void)leftOneAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"本课文件";
    self.view.backgroundColor = DMColorWithRGBA(240, 240, 240, 1);
    [self setNavigationBarNoTransparence];
    
    [self setRigthBtn:CGRectMake(0, 0, 44, 44)
                title:@"选择"
          titileColor:DMColorWithRGBA(246, 8, 122, 1)
            imageName:@""
                 font:DMFontPingFang_Light(16)];
    
    [self setLeftBtn:CGRectMake(0, 0, 44, 44) title:@"" titileColor:nil imageName:@"back_icon" font:nil];
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    [self loadUI];
    
    [_cfView didSelectItemAtIndexPath:^(NSIndexPath *indexPath, DMCoursewareFallsCellEventType type) {
        if (type == DMCoursewareFallsCellEventType_Preview) {
            //预览
            
        } else if (type == DMCoursewareFallsCellEventType_Select) {
            //选择
        }
    }];
    
    _cfView.datas = self.dataArray;
    [_cfView.collectionView reloadData];
}

- (void)loadUI {

    _cfView = [[DMCoursewareFallsView alloc]
               initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)
               columns:6
               lineSpacing:20
               columnSpacing:25
               leftMargin:30
               rightMargin:30];
    [self.view addSubview:_cfView];
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, DMScreenHeight-64-50, DMScreenWidth, 50)];
    bottomV.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomV];
}

- (void)rightOneAction:(id)sender {
    //点击选择
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        [self updateRightBtnTitle:@"取消"];
    } else {
        [self updateRightBtnTitle:@"选择"];
    }
    
    [_cfView updateCollectionViewStatus:self.isEdit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


