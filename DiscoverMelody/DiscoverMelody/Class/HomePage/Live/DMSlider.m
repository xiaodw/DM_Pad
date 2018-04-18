#import "DMSlider.h"
#import <objc/runtime.h>

@interface DMSlider() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation DMSlider {
    id _dm_target;
    SEL _dm_action;
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
    _dm_target = target;
    _dm_action = action;
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    if (![_dm_target respondsToSelector:_dm_action]) return;
    
    CGRect frame = self.frame;
    CGPoint touchPoint = [sender locationInView:self];
    CGFloat value = touchPoint.x / frame.size.height * (self.maximumValue - self.minimumValue) + self.minimumValue;
    [self setValue:value animated:YES];
    [_dm_target performSelector:_dm_action withObject:self];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
