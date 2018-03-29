//
//  DMSlider.h
//  画板
//
//  Created by My mac on 2018/3/13.
//  Copyright © 2018年 My mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMSlider : UISlider

typedef NS_OPTIONS(NSUInteger, DMControlEvents) {
    DMControlEventTouchUpInside                                    = 1 <<  0
};

- (void)dm_addTarget:(nullable id)target action:(SEL _Nonnull )action forControlEvents:(DMControlEvents)controlEvents;

@end
