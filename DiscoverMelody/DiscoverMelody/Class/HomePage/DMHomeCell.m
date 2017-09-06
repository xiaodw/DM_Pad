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
    
    self.bottomView.layer.shadowColor = UIColorFromRGB(0xf6087a).CGColor;//shadowColor阴影颜色
    self.bottomView.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.bottomView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.bottomView.layer.shadowRadius = 4;//阴影半径，默认3

    _bottomView.layer.shadowColor = UIColorFromRGB(0xf6087a).CGColor;//shadowColor阴影颜色
    _bottomView.layer.shadowOffset = CGSizeMake(1,2);//shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
    _bottomView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    _bottomView.layer.shadowRadius = 8;//阴影半径，默认3
    
    self.redView = [[UIView alloc] init];
    self.redView.backgroundColor = UIColorFromRGB(0xf6087a);
    [self.bottomView addSubview:self.redView];
    self.redView.hidden = YES;
    
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
