#import "DMPhotoController.h"
#import "DMPHCollection.h"
#import "DMCoursewareFallsView.h"

#define kCoursewareCellID @"Courseware"
#define kLeftMargin 15
#define kRightMargin 15
#define kColumnSpacing 15
#define kColumns 3
#define kCellWH ((DMScreenWidth-(kLeftMargin+kRightMargin)-(kColumnSpacing*(kColumns-1)))/kColumns)

@interface DMPhotosController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic)DMPHCollection *collection;
@property (strong, nonatomic) DMCoursewareFallsView *collectionView;

@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation DMPhotosController

- (void)setCollection:(DMPHCollection *)collection {
    _collection = collection;
    
    self.collectionView.datas = collection.assets;
}

- (void)didTapClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        _closeButton.backgroundColor = [UIColor redColor];
        [_closeButton addTarget:self action:@selector(didTapClose) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        
    }
    
    return _closeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
    
    [_collectionView didSelectItemAtIndexPath:^(NSIndexPath *indexPath, DMItemsOperation iOt, DMCoursewareFallsCellEventType type) {
        if (type == DMCoursewareFallsCellEventType_Preview) {
            //预览
            
        } else if (type == DMCoursewareFallsCellEventType_Select) {
            //选择
            if (iOt == DMItemsOperation_Add) {
                
            } else if (iOt == DMItemsOperation_Remove) {
                
            }
        }
    }];
    
//    [_bottomView didDelete:^{
//        
//    }];
//    
//    [_bottomView didUpload:^{
//        
//    }];
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closeButton];
    
}

- (void)setupMakeLayoutSubviews {
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.view);
        make.size.equalTo(CGSizeMake(100, 100));
    }];
}

- (DMCoursewareFallsView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[DMCoursewareFallsView alloc] initWithFrame:CGRectZero columns:kColumns lineSpacing:kColumnSpacing columnSpacing:kColumnSpacing leftMargin:kLeftMargin rightMargin:kRightMargin];
        
//        self.bottomView = [[DMCoursewareBottom alloc] initWithFrame:CGRectMake(0, DMScreenHeight-64-50, DMScreenWidth, 50)];
//        _bottomView.backgroundColor = [UIColor whiteColor];
//        _bottomView.synBtn.hidden = YES;
//        [self.view addSubview:_bottomView];
    }
    
    return _collectionView;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

@interface DMPhotoController ()

@end

@implementation DMPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DMPhotosController *photosVC = [DMPhotosController new];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:photosVC];
    photosVC.collection = self.collection;
    [self addChildViewController:navigationVC];
    [self.view addSubview:navigationVC.view];
}

@end
