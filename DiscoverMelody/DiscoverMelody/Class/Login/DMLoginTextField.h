#import <UIKit/UIKit.h>

@interface DMLoginTextField : UIView

@property (strong, nonatomic) id<UITextFieldDelegate> delegate;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) BOOL secureTextEntry;
@property (strong, nonatomic, readonly) NSString *text;
@property (strong, nonatomic) NSString *placeholder;
@property (strong, nonatomic) UIColor *placeholderColor;


- (void)becomeFirstResponder;
- (void)addTarget:(nullable id)target action:(SEL _Nullable )action forControlEvents:(UIControlEvents)controlEvents;

@end
