//
//  SKTextView.m
//  SKMobileProject
//
//  Created by  on 16/5/6.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import "SKTextView.h"

@implementation SKTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChage:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (UILabel*)placeHoldLab
{
    if (_placeHoldLab==nil) {
        _placeHoldLab = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.origin.x+5,self.frame.origin.y+5, 200, self.frame.size.height-10)];
        _placeHoldLab.textColor = DMColorWithRGBA(204, 204, 204, 1);
        _placeHoldLab.numberOfLines = 0;
        _placeHoldLab.font = [UIFont systemFontOfSize:14];
        _placeHoldLab.text = _placeHold;
        [self.superview addSubview:_placeHoldLab];
        
    }
    return _placeHoldLab;
}

- (void)setPlaceHold:(NSString *)placeHold {
    _placeHold = placeHold;
}

- (void)textChage:(NSNotification*)noti {
    NSInteger textNum = self.text.length;
    if (textNum>0) {
        self.placeHoldLab.hidden = YES;
    }else
    {
        self.placeHoldLab.hidden =NO;
    }
}

- (void)layoutSubviews {
    [self placeHoldLab];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
