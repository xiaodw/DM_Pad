#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGFloat)stringWidthWithFont:(UIFont *)font maxHeight:(CGFloat)height {
    CGSize stringMaxSize = CGSizeMake(MAXFLOAT, height);
    return [self stringSizeWithFont:font maxSize:stringMaxSize].width;
}


- (CGFloat)stringHeightWithFont:(UIFont *)font maxWidth:(CGFloat)width {
    CGSize stringMaxSize = CGSizeMake(width, MAXFLOAT);
    return [self stringSizeWithFont:font maxSize:stringMaxSize].height;
}

- (CGSize)stringSizeWithFont:(UIFont *)font maxSize:(CGSize)size {
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (instancetype)stringByPaddingLeftWithString:(NSString *)padString total:(NSInteger)total {
    if (self.length >= total) return self;
    NSMutableString *fullString = [NSMutableString stringWithString:@""];
    for (int i = 0; i < total-self.length; i++) {
        [fullString appendString:padString];
    }
    [fullString appendString:self];
    return fullString;
}
- (instancetype)stringByPaddingRightWithString:(NSString *)padString total:(NSInteger)total {
    if (self.length >= total) return self;
    NSMutableString *fullString = [NSMutableString stringWithString:self];
    for (int i = 0; i < total-self.length; i++) {
        [fullString appendString:padString];
    }
    return fullString;
}

@end
