//
//  DMTitleView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMTitleView.h"

@implementation DMTitleView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[DMTools imageWithColor:[UIColor whiteColor] size:self.bounds.size alpha:1]];
    
    [self addSubview:self.numberLabel];
    [self addSubview:self.contentLabel];
    self.numberLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.backgroundColor = [UIColor clearColor];
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (self.bounds.size.height-21)/2, 24, 21)];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.font = DMFontPingFang_Light(15);
        _numberLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
    }
    return _numberLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, _numberLabel.frame.origin.y, Content_Label_W, 21)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = DMFontPingFang_Light(15);
        _contentLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _contentLabel;
}

- (void)updateInfo:(NSInteger)index content:(NSString *)content {
    self.numberLabel.text = [NSString stringWithFormat:@"%ld.", index];
    self.contentLabel.text = content;
    
    CGFloat h = [DMTools getContactHeight:content font:DMFontPingFang_Light(15) width:Content_Label_W];
    if (h > 21) {
        _contentLabel.frame = CGRectMake(44, _numberLabel.frame.origin.y, Content_Label_W, h);
        self.frame = CGRectMake(0, 0, self.bounds.size.width, 50+(h-21));
    }
    
                        
}

@end
