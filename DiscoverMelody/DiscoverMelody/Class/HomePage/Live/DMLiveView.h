#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMLiveViewMode) {
    DMLiveViewSmall, // 本地
    DMLiveViewBalanceTB, // 上下
    DMLiveViewBalanceLR, // 左右
    DMLiveViewFull // 远端
};

@interface DMLiveView : UIView

@property (strong, nonatomic, readonly) UIView *view;
@property (assign, nonatomic) CGFloat voiceValue;
@property (assign, nonatomic) DMLiveViewMode mode;
@property (strong, nonatomic) UIImage *placeholderImage;
@property (assign, nonatomic) BOOL showPlaceholder;

@end
