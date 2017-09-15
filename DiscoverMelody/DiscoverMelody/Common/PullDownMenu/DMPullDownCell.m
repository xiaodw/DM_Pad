//
//  DMPullDownCell.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMPullDownCell.h"

@implementation DMPullDownCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.textLabel.font          = DMFontPingFang_UltraLight(14);
    self.textLabel.textColor     = DMColorBaseMeiRed;
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 35 - 0.5, self.frame.size.width-20, 0.5)];
    _lineView.backgroundColor = DMColorBaseMeiRed;
    [self addSubview:_lineView];
    
    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
        make.height.equalTo(0.5);
    }];
}


@end
