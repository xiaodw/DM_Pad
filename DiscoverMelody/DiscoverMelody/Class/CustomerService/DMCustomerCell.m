//
//  DMCustomerCell.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCustomerCell.h"
#import "DMCustomerDataModel.h"
@interface DMCustomerCell ()
@property (nonatomic, strong) UILabel *teachLabel;
//@property (nonatomic, strong) UILabel *wecatAccountLabel;
@property (nonatomic, strong) UIImageView *bgCodeImageView;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UILabel *lineLabel;
@end

@implementation DMCustomerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = DMColorWithRGBA(240, 240, 240, 1);
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    
    self.teachLabel = [[UILabel alloc] init];
    self.teachLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
    self.teachLabel.font = DMFontPingFang_Thin(16);
    self.teachLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.teachLabel];
    
//    self.wecatAccountLabel = [[UILabel alloc] init];
//    self.wecatAccountLabel.textColor = DMColorWithRGBA(153, 153, 153, 1);
//    self.wecatAccountLabel.font = DMFontPingFang_Thin(12);
//    self.wecatAccountLabel.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.wecatAccountLabel];
//
    self.bgCodeImageView = [[UIImageView alloc] init];
    [self addSubview:self.bgCodeImageView];
    
    self.codeImageView = [[UIImageView alloc] init];
    [self addSubview:self.codeImageView];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = DMColorWithRGBA(221, 221, 221, 1);
    [self addSubview:self.lineLabel];
    
    [self.teachLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(33);
        make.top.equalTo(self).offset(0);//20
        make.width.equalTo(DMScreenWidth/2);
        //make.height.equalTo(18);
        make.bottom.equalTo(self);
    }];
    
//    [self.wecatAccountLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(33);
//        make.top.equalTo(self.teachLabel.mas_bottom).offset(6);
//        make.width.equalTo(DMScreenWidth/3);
//        make.height.equalTo(12);
//
//    }];
    
    [self.bgCodeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18);
        make.top.equalTo(self).offset(14);
        make.width.height.equalTo(42);
        make.centerY.equalTo(self);
    }];
    
    [self.codeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgCodeImageView.mas_right).offset(-3.5);
        make.top.equalTo(self.bgCodeImageView.mas_top).offset(3.5);
        make.width.height.equalTo(35);
        make.centerY.equalTo(self);
    }];
    
    [self.lineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self).offset(0);
        make.height.equalTo(0.5);
    }];
}

- (void)configObj:(id)obj {
    DMCustomerTeacherInfo *infoObj = (DMCustomerTeacherInfo *)obj;
    self.teachLabel.text = infoObj.name;
    //self.wecatAccountLabel.text = [NSString stringWithFormat:DMStringWeChatNumber, infoObj.webchat];
    self.bgCodeImageView.image = [UIImage imageNamed:@"customer_code"];
    [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:infoObj.img_url] placeholderImage:[UIImage imageNamed:@""]];
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
