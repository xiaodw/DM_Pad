#import <UIKit/UIKit.h>

@class DMLiveView;

@protocol DMLiveViewDelegate

@optional
- (void)liveViewShouldSmallDidTapView:(DMLiveView *)view;

@end

typedef NS_ENUM(NSInteger, DMLiveViewMode) {
    DMLiveViewSmall, // 本地
    DMLiveViewBalance, //
    DMLiveViewFull // 远端
};

@interface DMLiveView : UIView

@property (weak, nonatomic) id<DMLiveViewDelegate> delegate;

@property (assign, nonatomic) CGFloat voiceValue;
@property (assign, nonatomic) DMLiveViewMode mode;

@end
