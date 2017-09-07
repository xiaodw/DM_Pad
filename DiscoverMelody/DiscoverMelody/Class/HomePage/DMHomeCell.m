//
//  DMHomeCell.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/6.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMHomeCell.h"

@implementation DMHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
   
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];

    _bottomView.layer.shadowColor = UIColorFromRGB(0xf6087a).CGColor;//shadowColor阴影颜色
    _bottomView.layer.shadowOffset = CGSizeMake(1,3);//shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
    _bottomView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    _bottomView.layer.shadowRadius = 8;//阴影半径，默认3
    
    self.redView = [[UIView alloc] init];
    self.redView.backgroundColor = UIColorFromRGB(0xf6087a);
    [self.bottomView addSubview:self.redView];
    self.redView.hidden = YES;
    
    self.nameLabel = [self createLabel:NSTextAlignmentLeft];
    [self.bottomView addSubview:self.nameLabel];
    
    self.timeLabel = [self createLabel:NSTextAlignmentCenter];
    [self.bottomView addSubview:self.timeLabel];
    
    self.statusLabel = [self createLabel:NSTextAlignmentRight];
    [self.bottomView addSubview:self.statusLabel];
    
    [self setLayoutCellSubViews];
}

- (UILabel *)createLabel:(NSTextAlignment)ali {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x000333);
    label.font = DMFontPingFang_UltraLight(16);
    label.textAlignment = ali;
    return label;
}

- (void)isSelectedCell:(BOOL)isSelected {
    self.redView.hidden = YES;
    self.bottomView.layer.shadowOpacity = 0;
    UIColor *color = UIColorFromRGB(0x000333);
    UIFont *font = DMFontPingFang_UltraLight(16);
    if (isSelected) {
        color = UIColorFromRGB(0xf6087a);
        font = DMFontPingFang_Light(16);
        self.redView.hidden = NO;
        self.bottomView.layer.shadowOpacity = 0.2;
    }
    _nameLabel.textColor = color;
    _timeLabel.textColor = color;
    _statusLabel.textColor = color;
    
    _nameLabel.font = font;
    _timeLabel.font = font;
    _statusLabel.font = font;
}

- (void)setLayoutCellSubViews {
    
    [_bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.bottom.equalTo(-6);
        make.centerX.equalTo(self);
    }];
    
    [_redView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top).offset(0);
        make.left.equalTo(_bottomView.mas_left).offset(0);
        make.bottom.equalTo(_bottomView.mas_bottom).offset(0);
        make.width.equalTo(4);
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top).offset(0);
        make.left.equalTo(_bottomView.mas_left).offset(50);
        make.bottom.equalTo(_bottomView.mas_bottom).offset(0);
        make.width.equalTo(298);
    }];
    
    [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top).offset(0);
        make.right.equalTo(_bottomView.mas_right).offset(-50);
        make.bottom.equalTo(_bottomView.mas_bottom).offset(0);
        make.width.equalTo(298);
    }];
    
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top).offset(0);
        make.left.equalTo(_nameLabel.mas_right).offset(0);
        make.right.equalTo(_statusLabel.mas_left).offset(0);
        make.bottom.equalTo(_bottomView.mas_bottom).offset(0);
    }];
    
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
