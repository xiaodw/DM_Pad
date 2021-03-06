#import "DMAlbumsTableView.h"
#import "DMAlbum.h"
#import "DMNavigationBar.h"
#import "DMAlbumCell.h"

@interface DMAlbumsTableView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DMNavigationBar *navigationBar;
@property (strong, nonatomic) UITableView *albumTableView;

@end

@implementation DMAlbumsTableView

#pragma mark - Set Methods
- (void)setAlbums:(NSMutableArray *)albums {
    _albums = albums;
    [self.albumTableView reloadData];
}

#pragma mark - Lifecycle Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

#pragma mark - AddSubviews
- (void)setupMakeAddSubviews {
    [self addSubview:self.navigationBar];
    [self addSubview:self.albumTableView];
}

#pragma mark - LayoutSubviews
- (void)setupMakeLayoutSubviews {
    [_navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(DMScreenWidth*0.5);
        make.left.top.equalTo(self);
        make.height.equalTo(64);
    }];
    
    [_albumTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBar.mas_bottom);
        make.left.right.equalTo(_navigationBar);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - Functions
- (void)didTapSelect:(UIButton *)sender  {
    if (![self.delegate respondsToSelector:@selector(albumsTableView:didTapRightButton:)]) return;
    
    [self.delegate albumsTableView:self didTapRightButton:sender];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"album"];
    if (!cell) {
        cell = [[DMAlbumCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"album"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.album = self.albums[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.delegate respondsToSelector:@selector(albumsTableView:didTapSelectedIndexPath:)]) return;
    
    [self.delegate albumsTableView:self didTapSelectedIndexPath:indexPath];
}

#pragma mark - Lazy
- (UITableView *)albumTableView {
    if (!_albumTableView) {
        _albumTableView = [UITableView new];
        _albumTableView.delegate = self;
        _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _albumTableView.dataSource = self;
        _albumTableView.rowHeight = 60;
    }
    
    return _albumTableView;
}

- (DMNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [DMNavigationBar new];
        [_navigationBar.leftBarButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
        _navigationBar.titleLabel.text = DMTitleAllPhotos;
        [_navigationBar.rightBarButton setTitle:DMTitleCancel forState:UIControlStateNormal];
        [_navigationBar.rightBarButton setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
        [_navigationBar.rightBarButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _navigationBar;
}

@end
