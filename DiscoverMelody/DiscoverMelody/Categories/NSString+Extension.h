#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGFloat)stringHeightWithFont:(UIFont *)font maxWidth:(CGFloat)width;
- (CGFloat)stringWidthWithFont:(UIFont *)font maxHeight:(CGFloat)height;

@end
