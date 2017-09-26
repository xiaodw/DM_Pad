#import <UIKit/UIKit.h>

@interface DMActivityView : UIView
/**  显示活动指示器 */
+ (void)showActivity:(UIView *)supperView;
/**  关闭活动指示器 */
+ (void)hideActivity;

- (void)showInView:(UIView *)supperView;
- (void)hide;

@end
