#import "DMCollectionListController.h"
#import <Photos/Photos.h>
#import "DMPHCollection.h"
#import "DMPhotoController.h"

@interface DMCollectionListController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *assetCollections;

@end

@implementation DMCollectionListController

- (void)setAssetCollections:(NSArray *)assetCollections {
    
//    DMPhotoController *photosVC = [DMPhotoController new];
//    photosVC.
//    self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSMutableArray *collections = [NSMutableArray array];
    // 获取所有相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHAssetCollection *assetCollection = smartAlbums[i];
        if (![assetCollection isKindOfClass:[PHAssetCollection class]]) { return; }
        DMPHCollection *collection = [[DMPHCollection alloc] initWithCollection:assetCollection];
        if (collection.collectionName.length == 0) continue;
        [collections addObject:collection];
    }
    self.assetCollections = collections;
}

//相册变化回调
//- (void)photoLibraryDidChange:(PHChange *)changeInstance {
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"currentThreed:%@, changeInstance%@", [NSThread currentThread], changeInstance);
//    });
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"123"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DMPHCollection *collection = self.assetCollections[indexPath.row];
    cell.textLabel.text = collection.collectionName;
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

@end
