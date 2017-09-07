//
//  NSString+Extension.h
//  DiscoverMelody
//
//  Created by My mac on 2017/9/7.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGFloat)stringHeightWithFont:(UIFont *)font maxWidth:(CGFloat)width;
- (CGFloat)stringWidthWithFont:(UIFont *)font maxHeight:(CGFloat)height;

@end
