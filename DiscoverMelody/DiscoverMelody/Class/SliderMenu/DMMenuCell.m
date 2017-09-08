//
//  DMMenuCell.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMMenuCell.h"

@interface DMMenuCell ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *tipImageView;
@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) UILabel *lineLabel;
@end

@implementation DMMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        //self.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    
    self.tipImageView = [[UIImageView alloc] init];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = DMFontPingFang_Light(14);
    self.nameLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.redView = [[UIView alloc] init];
    self.redView.hidden = YES;
    self.redView.backgroundColor = UIColorFromRGB(0xf6087a);
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = UIColorFromRGB(0xdddddd);
    
    [self addSubview:self.tipImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.redView];
    
    [_tipImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(34);
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(34, 31));
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipImageView.mas_bottom).offset(16);
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(self.frame.size.width, 13));
    }];
    
    [_redView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self).offset(0);
        make.width.equalTo(3);
    }];

    [_lineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(0.5);
    }];
}

- (void)configObj:(NSString *)title imageName:(NSString *)imageName {
    self.tipImageView.image = [UIImage imageNamed:imageName];
    self.nameLabel.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
