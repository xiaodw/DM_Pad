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
    [self addSubview:self.textLabel];
    [self addSubview:self.textSubView];
    self.textField.hidden = YES;
    self.textLabel.hidden = YES;
    self.textSubView.hidden = NO
    ;
    
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [self.textSubView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(0);
    }];
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

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = DMColorWithRGBA(102, 102, 102, 1);
        _textLabel.font = DMFontPingFang_Light(14);
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.lineBreakMode = NSLineBreakByClipping;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UITextView *)textSubView {
    if (!_textSubView) {
        _textSubView = [[SKTextView alloc] init];//WithFrame:CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height)
        _textSubView.textColor = DMColorWithRGBA(102, 102, 102, 1);
        _textSubView.font = DMFontPingFang_Light(14);
        _textSubView.textAlignment = NSTextAlignmentLeft;
        _textSubView.placeHold = @"请填写";
        _textSubView.backgroundColor = [UIColor clearColor];
        _textSubView.textContainerInset = UIEdgeInsetsMake(17.5, 0, 0, 0);
        _textSubView.scrollEnabled = NO;
        
    }
    return _textSubView;
}
@end
