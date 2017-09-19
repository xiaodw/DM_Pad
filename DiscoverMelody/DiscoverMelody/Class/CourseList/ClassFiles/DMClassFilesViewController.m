//
//  DMClassFilesViewController.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMClassFilesViewController.h"
#import "DMCoursewareFallsView.h"
#import "DMCoursewareBottom.h"
@interface DMClassFilesViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;//服务器获取的本课文件数据
@property (nonatomic, strong) DMCoursewareFallsView *cfView;
@property (nonatomic, strong) DMCoursewareBottom *bottomView;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation DMClassFilesViewController

- (void)leftOneAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DMTextThisClassFile;
    self.view.backgroundColor = [UIColor redColor];//DMColorWithRGBA(240, 240, 240, 1);
    [self setNavigationBarNoTransparence];
    
    [self setRigthBtn:CGRectMake(0, 0, 44, 44)
                title:DMTitleSelected
          titileColor:DMColorWithRGBA(246, 8, 122, 1)
            imageName:@""
                 font:DMFontPingFang_Light(16)];
    
    [self setLeftBtn:CGRectMake(0, 0, 44, 44) title:@"" titileColor:nil imageName:@"back_icon" font:nil];
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    [self loadUI];
    _cfView.datas = self.dataArray;
    [_cfView.collectionView reloadData];
    
    [DMApiModel getLessonList:@"1" block:^(BOOL result, NSArray *teachers, NSArray *students) {
        
    }];
    
    [_cfView didSelectItemAtIndexPath:^(NSIndexPath *indexPath, DMItemsOperation iOt, DMCoursewareFallsCellEventType type) {
        if (type == DMCoursewareFallsCellEventType_Preview) {
            //预览
            
        } else if (type == DMCoursewareFallsCellEventType_Select) {
            //选择
            if (iOt == DMItemsOperation_Add) {
                
            } else if (iOt == DMItemsOperation_Remove) {
            
            }
        }
    }];
    
    [_bottomView didDelete:^{
        
    }];
    
    [_bottomView didUpload:^{
        
    }];

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
    
    self.bottomView = [[DMCoursewareBottom alloc] initWithFrame:CGRectMake(0, DMScreenHeight-64-50, DMScreenWidth, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.synBtn.hidden = YES;
    [self.view addSubview:_bottomView];
}


- (void)rightOneAction:(id)sender {
    //点击选择
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        [self updateRightBtnTitle:DMTitleCancel];
    } else {
        [self updateRightBtnTitle:DMTitleSelected];
    }
    
    [_cfView updateCollectionViewStatus:self.isEdit];
}

@end



