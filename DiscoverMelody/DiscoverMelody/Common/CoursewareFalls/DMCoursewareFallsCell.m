//
//  DMCoursewareFallsCell.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCoursewareFallsCell.h"

@implementation DMCoursewareFallsCell

- (UIImageView *)courseImageView {
    if (!_courseImageView) {
        _courseImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _courseImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _courseImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_courseImageView.layer setMasksToBounds:YES];
    }
    return _courseImageView;
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-25, 5, 20, 20)];
        [_statusView.layer setMasksToBounds:YES];
        _statusView.backgroundColor = [UIColor blackColor];
        _statusView.alpha = 0.2;
        _statusView.layer.cornerRadius = 20/2;

        _statusView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;//[UIColor colorWithWhite:1 alpha:0.4].CGColor;
        _statusView.layer.borderWidth = 1;
        _statusView.hidden = YES;
    }
    return _statusView;
}


- (UILabel *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width-25, 5, 20, 20)];
        [_selectedView.layer setMasksToBounds:YES];
        _selectedView.font = DMFontPingFang_Light(14);
        _selectedView.textAlignment = NSTextAlignmentCenter;
        _selectedView.backgroundColor = DMColorWithRGBA(246, 8, 122, 1);
        _selectedView.layer.cornerRadius = 20/2;
        _selectedView.hidden = YES;
        _selectedView.textColor = [UIColor whiteColor];
    }
    return _selectedView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DMColorWithRGBA(240, 240, 240, 1);
        self.contentView.backgroundColor = DMColorWithRGBA(240, 240, 240, 1);
        [self.contentView addSubview:self.courseImageView];
        [self.contentView addSubview:self.statusView];
        [self.contentView addSubview:self.selectedView];
    }
    return self;
}

- (void)displayEditStatus:(BOOL)isDisplay {
    if (isDisplay) {
        _statusView.hidden = NO;
        
    } else {
        _statusView.hidden = YES;
        _selectedView.hidden = YES;
    }
}

- (void)displaySelected:(BOOL)isDisplay number:(NSInteger)i {
    if (isDisplay) {
        _selectedView.hidden = NO;
        _selectedView.text = (i==0) ? @"" : [NSString stringWithFormat:@"%ld", (long)i];
    } else {
        _selectedView.hidden = YES;
        _selectedView.text = @"";
    }
}

@end






