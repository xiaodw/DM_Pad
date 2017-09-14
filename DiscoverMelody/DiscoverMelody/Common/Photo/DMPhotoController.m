#import "DMPhotoController.h"
#import "DMPHCollection.h"
#import "DMCoursewareFallsView.h"
#import <Photos/Photos.h>
#import "DMCollectionListController.h"

#define kCoursewareCellID @"Courseware"
#define kLeftMargin 15
#define kRightMargin 15
#define kColumnSpacing 15
#define kColumns 3
#define kCellWH ((DMScreenWidth-(kLeftMargin+kRightMargin)-(kColumnSpacing*(kColumns-1)))/kColumns)

@interface DMPhotosController ()

//@property (strong, nonatomic)DMPHCollection *collection;
//@property (strong, nonatomic) DMCoursewareFallsView *collectionView;

@end

@implementation DMPhotosController

- (void)setCollection:(DMPHCollection *)collection {
    _collection = collection;
    
//    self.collectionView.datas = collection.assets;
}

- (void)didTapLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.dm_width = DMScreenWidth * 0.5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLeft)];
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        NSString *appName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"];
        NSString *tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许 %@ 访问你的手机相册", appName];
        
        // 展示提示语
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权警告" message:tipTextWhenNoPhotosAuthorization delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
//    [self.view addSubview:self.collectionView];
//    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
//    [_collectionView didSelectItemAtIndexPath:^(NSIndexPath *indexPath, DMItemsOperation iOt, DMCoursewareFallsCellEventType type) {
//        if (type == DMCoursewareFallsCellEventType_Preview) {
//            //预览
//            NSLog(@"%@", indexPath);
//        } else if (type == DMCoursewareFallsCellEventType_Select) {
//            //选择
//            NSLog(@"%@", indexPath);
//            if (iOt == DMItemsOperation_Add) {
//                NSLog(@"%@", indexPath);
//            } else if (iOt == DMItemsOperation_Remove) {
//                NSLog(@"%@", indexPath);
//            }
//        }
//    }];
    
//    [_bottomView didDelete:^{
//        
//    }];
//    
//    [_bottomView didUpload:^{
//        
//    }];
}

//- (DMCoursewareFallsView *)collectionView {
//    if (!_collectionView) {
//        _collectionView = [[DMCoursewareFallsView alloc] initWithFrame:CGRectZero columns:kColumns lineSpacing:kColumnSpacing columnSpacing:kColumnSpacing leftMargin:kLeftMargin rightMargin:kRightMargin];
//        
////        self.bottomView = [[DMCoursewareBottom alloc] initWithFrame:CGRectMake(0, DMScreenHeight-64-50, DMScreenWidth, 50)];
////        _bottomView.backgroundColor = [UIColor whiteColor];
////        _bottomView.synBtn.hidden = YES;
////        [self.view addSubview:_bottomView];
//    }
//    
//    return _collectionView;
//}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@implementation DMPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    DMCollectionListController *photosVC = [DMCollectionListController new];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:photosVC];
    [self addChildViewController:navigationVC];
    [self.view addSubview:navigationVC.view];
}

@end
