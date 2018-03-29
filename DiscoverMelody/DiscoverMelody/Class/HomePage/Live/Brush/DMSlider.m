//
//  DMSlider.m
//  画板
//
//  Created by My mac on 2018/3/13.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import "DMSlider.h"
#import <objc/runtime.h>

@interface DMSlider() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation DMSlider {
    id _tt_target;
    SEL _tt_action;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit {
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)dm_addTarget:(nullable id)target action:(SEL)action forControlEvents:(DMControlEvents)controlEvents {
    _tt_target = target;
    _tt_action = action;
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGRect frame = self.frame;
    CGPoint touchPoint = [sender locationInView:self];
    CGFloat value = touchPoint.x / frame.size.width * (self.maximumValue - self.minimumValue) + self.minimumValue;
    [self setValue:value animated:YES];
    
    if (![_tt_target respondsToSelector:_tt_action]) return;
    [_tt_target performSelector:_tt_action withObject:self];
}

@end
