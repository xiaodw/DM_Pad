#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMLiveViewMode) {
    DMLiveViewRemote, // 远端
    DMLiveViewlocal //
};

@interface DMLiveView : UIView

@property (assign, nonatomic) CGFloat voiceValue;
@property (assign, nonatomic) DMLiveViewMode mode;

@end
