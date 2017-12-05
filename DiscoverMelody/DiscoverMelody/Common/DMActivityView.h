#import <UIKit/UIKit.h>

@interface DMActivityView : UIView

/** 面向全局, 例如: loading data */
// 背景颜色透明
+ (void)showActivity:(UIView *)supperView;
// 背景颜色: 黑色, 透明: 0.6
+ (void)showActivityCover:(UIView *)supperView;
// 自定义 背景颜色, 透明
+ (void)showActivity:(UIView *)supperView hudColor:(UIColor *)backgroundColor;
// 隐藏全局
+ (void)hideActivity;

/** 面向局部, 例如: cell内部 */
- (void)showInView:(UIView *)supperView;
- (void)hide;

@end
