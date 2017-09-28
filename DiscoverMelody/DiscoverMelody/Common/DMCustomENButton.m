//
//  DMCustomENButton.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/28.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCustomENButton.h"

@interface DMCustomENButton ()
@property (nonatomic, assign) CGRect rect;
@end

@implementation DMCustomENButton
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-21-24/2, (self.frame.size.height-6)/2, 24/2, 12/2)];
    btnImageView.image = [UIImage imageNamed:@"btn_menu_arrow_bottom"];
    [self addSubview:btnImageView];
    
    UILabel *titleBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnImageView.frame.origin.x, self.frame.size.height)];
    titleBtnLabel.textColor = DMColorWithRGBA(246, 246, 246, 1);
    titleBtnLabel.font = DMFontPingFang_Thin(14);
    titleBtnLabel.text = @"";
    titleBtnLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleBtnLabel];
    
    self.enTitleLabel = titleBtnLabel;
    self.enImgeView = btnImageView;
    
}



@end
