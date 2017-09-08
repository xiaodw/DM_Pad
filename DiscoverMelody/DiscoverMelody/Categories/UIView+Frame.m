#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)dm_x {
    return self.frame.origin.x;
}

- (void)setDm_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)dm_y {
    return self.frame.origin.y;
}

- (void)setDm_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGPoint)dm_origin {
    return self.frame.origin;
}

- (void)setDm_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)dm_width {
    return self.frame.size.width;
}

- (void)setDm_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)dm_height {
    return self.frame.size.height;
}

- (void)setDm_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)dm_size {
    return self.frame.size;
}

- (void)setDm_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)dm_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)dm_maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)dm_right {
    
    return self.superview.dm_width - self.dm_maxX;
}

- (CGFloat)dm_bottom {
    return self.superview.dm_height - self.dm_maxY;
}

@end
