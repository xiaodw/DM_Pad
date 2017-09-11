//
//  DMCustomerCell.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCustomerPhoneCell.h"

@implementation DMCustomerPhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.infoView = [[DMCustomerInfoView alloc] initWithFrame:self.bounds isTap:NO];
    [self addSubview:self.infoView];
    
    [self.infoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (void)configObj:(id)obj {
    [self.infoView updateSubViewsObj:obj];
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
