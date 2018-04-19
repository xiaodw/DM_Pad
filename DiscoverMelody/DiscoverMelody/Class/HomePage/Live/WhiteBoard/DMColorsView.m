//
//  DMColorsView.m
//  DiscoverMelody
//
//  Created by My mac on 2018/4/17.
//  Copyright © 2018年 Discover Melody. All rights reserved.
//

#import "DMColorsView.h"

#define kColorButtonWidth 30

@interface DMColorsView()

@property (strong, nonatomic) NSMutableArray *colorViews;
@property (strong, nonatomic) UIView *selectedView;

@end

@implementation DMColorsView

- (void)setColors:(NSArray *)colors {
    _colors = colors;
    _colorViews = nil;
    if (colors.count == 0) return;
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
}

- (void)setSelectedView:(UIView *)selectedView {
    _selectedView.layer.borderWidth = 0;
    _selectedView = selectedView;
    _selectedView.layer.borderWidth = 2.5;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)didTapColor:(UIButton *)button {
    if (![self.delegate respondsToSelector:@selector(colorsView:didTapColr:strHex:)]) return;
    self.selectedView = button;
    [self.delegate colorsView:self didTapColr:button.backgroundColor strHex:_colors[button.tag]];
}

- (UIButton *)setupButtons {
    UIButton *button = [UIButton new];
    button.layer.cornerRadius = kColorButtonWidth * 0.5;
    button.layer.borderColor = DMColorWithRGBA(220, 220, 220, 1).CGColor;
    [button addTarget:self action:@selector(didTapColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorViews addObject:button];
    
    return button;
}

- (void)setupMakeAddSubviews {
    for (int i = 0; i < _colors.count; i++) {
        UIButton *button = [self setupButtons];
        button.tag = i;
        button.backgroundColor = DMColorWithHexString(_colors[i]);
        [self addSubview:button];
        if (!_selectedView) self.selectedView = button;
    }
}

- (void)setupMakeLayoutSubviews {
    CGFloat margin = 12;
    for (int i = 0; i < self.colorViews.count; i++) {
        UIButton *button = _colorViews[i];
        CGFloat top = (kColorButtonWidth + margin)*i + margin;
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kColorButtonWidth, kColorButtonWidth));
            make.top.equalTo(top);
            make.centerX.equalTo(self);
        }];
    }
}

- (NSMutableArray *)colorViews {
    if (!_colorViews) {
        _colorViews = [NSMutableArray array];
    }
    
    return _colorViews;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
