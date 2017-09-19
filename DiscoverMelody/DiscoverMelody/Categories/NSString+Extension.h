#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (instancetype)trim;
- (CGFloat)stringHeightWithFont:(UIFont *)font maxWidth:(CGFloat)width;
- (CGFloat)stringWidthWithFont:(UIFont *)font maxHeight:(CGFloat)height;
- (instancetype)stringByPaddingLeftWithString:(NSString *)padString total:(NSInteger)total;
- (instancetype)stringByPaddingRightWithString:(NSString *)padString total:(NSInteger)total;

+ (instancetype)stringWithTimeToHHmmss:(NSInteger)second;

@end
