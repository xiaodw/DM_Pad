//
//  DMAlbumCell.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/19.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMAlbumCell.h"
#import "DMAlbum.h"
#import "DMAsset.h"

@interface DMAlbumCell()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIView *separatorView;

@end

@implementation DMAlbumCell

- (void)setAlbum:(DMAlbum *)album {
    _album = album;
    UIImage *image = [UIImage imageNamed:@"image_placeholder_97x74"];
    if (album.assets.count) {
        DMAsset *asset = album.assets.firstObject;
       image = asset.thumbnail;
    }
    _iconImageView.image = image;
    _nameLabel.text = album.name;
    _countLabel.text = [NSString stringWithFormat:@"(%zd)", album.assets.count];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.separatorView];
}

- (void)setupMakeLayoutSubviews {
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.size.equalTo(CGSizeMake(48, 37));
        make.centerY.equalTo(self.contentView);
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(15);
        make.centerY.equalTo(_iconImageView);
        
    }];
    
    [_countLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(10);
        make.centerY.equalTo(_nameLabel);
    }];
    
    [_arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(16);
        make.size.equalTo(CGSizeMake(6, 12));
        make.centerY.equalTo(_countLabel);
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(0.5);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
        _nameLabel.font = DMFontPingFang_Light(16);
    }
    
    return _nameLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.textColor = DMColorWithRGBA(153, 153, 153, 1);
        _countLabel.font = DMFontPingFang_Light(16);
    }
    
    return _countLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"btn_arrow_right_red"];
    }
    
    return _arrowImageView;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = DMColorWithRGBA(221, 221, 221, 1);
    }
    
    return _separatorView;
}

@end
