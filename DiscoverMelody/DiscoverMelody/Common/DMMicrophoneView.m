#import "DMMicrophoneView.h"
#define kCircleMargin 4
#define kCircleWidth 1
#define kCircleAdjust 0.25
#define kEllipseStemHeight 16

@interface DMMicrophoneView ()

@property (strong, nonatomic) UIImage *voiceImage;

@end

@implementation DMMicrophoneView

- (void)setVoiceValue:(CGFloat)voiceValue {
    _voiceValue = voiceValue;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // 图片
    // 17 * 25
    CGSize imageSize = self.voiceImage.size;
    CGFloat imageWidth = imageSize.width;
    
    // 圆
    CGFloat y = kCircleWidth;
    CGFloat circleCenterX = imageWidth * 0.5 + kCircleAdjust; // 圆心X = 图片总width * 0.5
    CGFloat diametral = imageWidth - kCircleMargin * 2; // 圆心直径 = 图片总width - 左右间距(4*2)
    CGFloat radius = diametral * 0.5; // 圆心半径 = 圆心直径 * 0.5
    CGFloat circleStartY = y + radius; // 圆起始位置Y = 外侧圆边框的width + 半径
    CGFloat ellipseStemHeight = kEllipseStemHeight - diametral; // 椭圆的长度 = 椭圆的茎高 - 直径
    
    // 矩形
    CGFloat rectHeight = y+kEllipseStemHeight+kCircleAdjust;
    CGFloat rectTopY = rectHeight * (1 - self.voiceValue);
    CGFloat lineStartX = circleCenterX - radius; // 矩形的起始位置X
    
    // 画图片
    [self.voiceImage drawInRect:CGRectMake(0, 0, imageWidth, imageSize.height)];
    CGContextRef ref = UIGraphicsGetCurrentContext(); // 拿到当前画板，在这个画板上画就是在视图上画
    
    // 画椭圆
    CGContextBeginPath(ref); // 开始绘画
    CGContextMoveToPoint(ref, lineStartX, y);
    CGContextAddLineToPoint(ref, lineStartX, circleStartY+ellipseStemHeight);
    CGContextAddArc(ref, circleCenterX, circleStartY+ellipseStemHeight, radius, M_PI, 0, YES);
    CGContextAddLineToPoint(ref, lineStartX+diametral, circleStartY);
    CGContextAddArc(ref, circleCenterX, circleStartY, radius, 0, M_PI, YES);
    CGContextClosePath(ref);
    [[UIColor clearColor] setFill];
    CGContextClip(ref); // 裁剪
    CGContextFillPath(ref);
    
    // 画矩形
    CGContextBeginPath(ref); // 开始绘画
    CGContextMoveToPoint(ref, lineStartX+radius, rectTopY); // 画线
    CGContextAddLineToPoint(ref, lineStartX+radius, rectHeight);
    CGContextSetLineWidth(ref, diametral);
    CGContextSetStrokeColorWithColor(ref, DMColorBaseMeiRed.CGColor);
    CGContextStrokePath(ref);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImage *)voiceImage {
    if (!_voiceImage) {
        _voiceImage = [UIImage imageNamed:@"icon_microphone_0"];
    }
    
    return _voiceImage;
}

@end

