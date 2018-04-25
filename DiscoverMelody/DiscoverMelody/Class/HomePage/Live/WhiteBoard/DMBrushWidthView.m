#import "DMBrushWidthView.h"
#import "UIView+Frame.h"

@interface DMBrushWidthView()

@property (strong, nonatomic) UIImageView *minView;
@property (strong, nonatomic) UIImageView *maxView;
@property (strong, nonatomic) UIView *maxViewView;

@end

@implementation DMBrushWidthView

- (void)setValue:(CGFloat)value {
    _value = value;
    self.maxViewView.dm_height = self.maxView.dm_height * value;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _value = 0.5;
        [self addSubview:self.minView];
        [self addSubview:self.maxViewView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.minView.frame = CGRectMake(0, 0, self.dm_width, self.dm_height);
    self.maxView.frame = CGRectMake(0, 0, self.dm_width, self.dm_height);
    self.maxViewView.frame = CGRectMake(0, 0, self.dm_width, self.maxView.dm_height * _value);
}

- (UIImageView *)minView {
    if (!_minView) {
        _minView = [UIImageView new];
        _minView.image = [UIImage imageNamed:@"icon_slider_min"];
    }
    
    return _minView;
}

- (UIImageView *)maxView {
    if (!_maxView) {
        _maxView = [UIImageView new];
        _maxView.image = [UIImage imageNamed:@"icon_slider_max"];
    }
    
    return _maxView;
}

- (UIView *)maxViewView {
    if (!_maxViewView) {
        _maxViewView = [UIView new];
        _maxViewView.clipsToBounds = YES;
        [_maxViewView addSubview:self.maxView];
        
    }
    
    return _maxViewView;
}

- (void)dealloc {
    DMLogFunc
}

@end
