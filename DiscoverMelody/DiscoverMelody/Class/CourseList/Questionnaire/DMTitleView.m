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
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 12, 50)];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.font = DMFontPingFang_Light(15);
        _numberLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
    }
    return _numberLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, DMScreenWidth-60, 50)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = DMFontPingFang_Light(15);
        _contentLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
    }
    return _contentLabel;
}

- (void)updateInfo:(NSInteger)index content:(NSString *)content {
    self.numberLabel.text = [NSString stringWithFormat:@"%ld.", index];
    self.contentLabel.text = content;
}

@end
