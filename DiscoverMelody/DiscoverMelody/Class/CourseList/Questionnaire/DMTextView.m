//
//  DMTextView.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMTextView.h"

@implementation DMTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    [self addSubview:self.textField];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height)];
        _textField.placeholder = DMTextPlaceholderMustFill;
        _textField.textColor = DMColorWithRGBA(102, 102, 102, 1);
        _textField.font = DMFontPingFang_Light(14);
        _textField.textAlignment = NSTextAlignmentLeft;
        
        [_textField setValue:DMColorWithRGBA(204, 204, 204, 1) forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:DMFontPingFang_Light(14) forKeyPath:@"_placeholderLabel.font"];
    }
    return _textField;
}

@end
