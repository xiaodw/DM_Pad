//
//  DMAlbrmsTableView.m
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import "DMAlbrmsTableView.h"
#import "DMAlbum.h"
#import "DMNavigationBar.h"

@interface DMAlbrmsTableView() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DMNavigationBar *navigationBar;
@property (strong, nonatomic) UITableView *albumTableView;

@end

@implementation DMAlbrmsTableView

- (void)setAlbums:(NSMutableArray *)albums {
    _albums = albums;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.navigationBar];
    [self addSubview:self.albumTableView];
}

- (void)setupMakeLayoutSubviews {
    [_navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(64);
    }];
    
    [_albumTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_navigationBar.mas_bottom);
        make.left.right.equalTo(_navigationBar);
        make.bottom.equalTo(self);
    }];
}

- (void)didTapSelect:(UIButton *)sender  {
    if (![self.delegate respondsToSelector:@selector(albrmsTableView:didTapRightButton:)]) return;
    
    [self.delegate albrmsTableView:self didTapRightButton:sender];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"123"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DMAlbum *album = self.albums[indexPath.row];
//    cell.textLabel.text = collection.name;
    cell.textLabel.text = album.name;
    return cell;
}

- (UITableView *)albumTableView {
    if (!_albumTableView) {
        _albumTableView = [UITableView new];
        _albumTableView.delegate = self;
        _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _albumTableView.dataSource = self;
    }
    
    return _albumTableView;
}


- (DMNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [DMNavigationBar new];
        
        _navigationBar.leftBarButton.hidden = YES;
        
        _navigationBar.titleLabel.text = @"所有照片";
        
        [_navigationBar.rightBarButton setTitle:@"取消" forState:UIControlStateNormal];
        [_navigationBar.rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navigationBar.rightBarButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _navigationBar;
}


@end
