//
//  DMTitleView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMTitleView.h"

@implementation DMTitleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    [self addSubview:self.numberLabel];
    [self addSubview:self.contentLabel];
}

@end
