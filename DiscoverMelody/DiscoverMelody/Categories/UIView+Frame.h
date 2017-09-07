#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGFloat)dm_x;
- (void)setDm_x:(CGFloat)x;
- (CGFloat)dm_y;
- (void)setDm_y:(CGFloat)y;
- (CGPoint)dm_origin;
- (void)setDm_origin:(CGPoint)origin;
- (CGFloat)dm_width;
- (void)setDm_width:(CGFloat)width;
- (CGFloat)dm_height;
- (void)setDm_height:(CGFloat)height;
- (CGSize)dm_size;
- (void)setDm_size:(CGSize)size;
- (CGFloat)dm_maxX;
- (CGFloat)dm_maxY;
- (CGFloat)dm_right;
- (CGFloat)dm_bottom;

@end
