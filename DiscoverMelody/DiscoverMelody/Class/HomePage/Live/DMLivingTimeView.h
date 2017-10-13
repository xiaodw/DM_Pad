#import <UIKit/UIKit.h>
@class DMButton;

@interface DMLivingTimeView : UIView

@property (strong, nonatomic) NSString *alreadyTime;
@property (strong, nonatomic, readonly) DMButton *timeButton; // 底部时间条: 图标
@property (strong, nonatomic) UIColor *alreadyTimeColor;
@property (strong, nonatomic) NSString *describeTime;

@end
