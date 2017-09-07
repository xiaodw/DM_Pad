//
//  DMMacros.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/5.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#pragma mark - Font

#define DMFontPingFang_Light(fontSize) [UIFont fontWithName:@"PingFangSC-Light" size:fontSize]
#define DMFontPingFang_UltraLight(fontSize) [UIFont fontWithName:@"PingFangSC-UltraLight" size:fontSize]
#define DMFontPingFang_Medium(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]

#pragma mark - Color

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((((rgbValue) & 0xFF0000) >> 16))/255.f \
green:((((rgbValue) & 0xFF00) >> 8))/255.f \
blue:(((rgbValue) & 0xFF))/255.f alpha:1.0]
#define DMColorWithRGBA(red,green,blue,alpha) [UIColor colorWithR:red g:green b:blue a:alpha]
#define DMColorWithHexString(hex) [UIColor colorWithHexString:hex]


#pragma mark - Other
#define DMNotificationCenter [NSNotificationCenter defaultCenter]

#define DMScreenHeight [UIScreen mainScreen].bounds.size.height
#define DMScreenWidth [UIScreen mainScreen].bounds.size.width
