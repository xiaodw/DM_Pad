#import <UIKit/UIKit.h>

@class DMTabBarView;

@protocol DMTabBarViewDelegate <NSObject>

@optional
- (void)tabBarView:(DMTabBarView *)tabBarView didTapBarButton:(UIButton *)button;

@end

@interface DMTabBarView : UIView

@property (weak, nonatomic) id<DMTabBarViewDelegate> delegate;
@property (strong, nonatomic) NSArray *titles;
@property (assign, nonatomic) BOOL isFullScreen;

@end
