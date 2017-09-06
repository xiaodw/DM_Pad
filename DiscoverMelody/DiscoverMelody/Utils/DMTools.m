//
//  DMTools.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMTools.h"

@implementation DMTools
    
+ (BOOL)isHaveFont:(NSString *)postScriptName{
    UIFont *font = [UIFont fontWithName:postScriptName size:12.0];
    if (font && ([font.fontName compare:postScriptName] == NSOrderedSame || [font.familyName compare:postScriptName] == NSOrderedSame)) {
        return YES;
    }
    return NO;
}
    
@end
