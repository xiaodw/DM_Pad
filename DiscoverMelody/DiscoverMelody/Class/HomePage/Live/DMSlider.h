#import <UIKit/UIKit.h>

@interface DMSlider : UISlider

typedef NS_OPTIONS(NSUInteger, DMControlEvents) {
    DMControlEventTouchUpInside                                    = 1 <<  0
};

- (void)dm_addTarget:(nullable id)target action:(SEL _Nonnull )action forControlEvents:(DMControlEvents)controlEvents;

@end
