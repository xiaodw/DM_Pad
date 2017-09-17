#import "DMMicrophoneView.h"

@interface DMMicrophoneView ()

@property (strong, nonatomic) UIImage *voiceImage;

@end

@implementation DMMicrophoneView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setVoiceValue:(CGFloat)voiceValue {
    _voiceValue = voiceValue;
    [self setNeedsDisplay];
}

- (UIImage *)voiceImage {
    if (!_voiceImage) {
        _voiceImage = [UIImage imageNamed:@"icon_microphone_0"];
    }
    
    return _voiceImage;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize imageSize = self.voiceImage.size;
    CGFloat lineWidth = imageSize.width - 8;
    CGFloat r = lineWidth * 0.5;
    CGFloat x = imageSize.width * 0.5;
    CGFloat y = 1;
    CGFloat height = 16;
    
    CGFloat rectY = y - 0.5;
    CGFloat rectHeight = (y + height + 0.5) * (1 - self.voiceValue);
    
    [self.voiceImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    CGContextRef ref = UIGraphicsGetCurrentContext(); // 拿到当前画板，在这个画板上画就是在视图上画
    
    // 椭圆
    CGContextBeginPath(ref); // 开始绘画
    CGContextMoveToPoint(ref, x-r-0.5, y+r); // 0.5为了让底层裁剪部分扩充这样周围没有虚线
    CGContextAddLineToPoint(ref, x-r-0.5, height+y-r);
    CGContextAddArc(ref, x, height+y-r, r+0.5, M_PI, 0, YES);
    CGContextAddLineToPoint(ref, x+r+0.5, y+r);
    CGContextAddArc(ref, x, y+r, r+0.5, 0, M_PI, YES);
    CGContextClosePath(ref);
    CGContextClip(ref); // 加上就不显示
    CGContextFillPath(ref);
    
    CGContextBeginPath(ref); // 开始绘画
    CGContextMoveToPoint(ref, x-r, y+r);
    CGContextAddLineToPoint(ref, x-r, height+y-r);
    CGContextAddArc(ref, x, height+y-r, r, M_PI, 0, YES);
    CGContextAddLineToPoint(ref, x+r, y+r);
    CGContextAddArc(ref, x, y+r, r, 0, M_PI, YES);
    CGContextClosePath(ref);
    UIColor *redColor = [UIColor redColor];
    [redColor setFill];
    CGContextFillPath(ref);
    
    // 矩形
    CGContextBeginPath(ref); // 开始绘画
    CGContextMoveToPoint(ref, x, rectY); // 画线
    CGContextAddLineToPoint(ref, x, rectHeight);
    CGContextSetLineWidth(ref, lineWidth);
    CGContextSetLineCap(ref, kCGLineCapButt);
    UIColor *whiteColor = [UIColor whiteColor];
    CGContextSetStrokeColorWithColor(ref, whiteColor.CGColor);
    CGContextStrokePath(ref); // 对移动的路径画线
    
}


/**
 
 //    CGContextMoveToPoint(ref, x, y+r); // 画线
 //    CGContextAddLineToPoint(ref, x, height+y-r);
 //    CGContextSetLineWidth(ref, lineWidth);
 //    CGContextSetLineCap(ref, kCGLineCapRound);
 UIColor *redColor = [UIColor redColor];
 
 CGContextSetFillColorWithColor(ref, redColor.CGColor);
 CGContextStrokePath(ref); // 对移动的路径画线
 
 
 */

@end
