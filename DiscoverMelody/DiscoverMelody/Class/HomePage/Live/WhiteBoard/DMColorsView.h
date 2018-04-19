#import <UIKit/UIKit.h>

@class DMColorsView;

@protocol DMColorsViewDelegate<NSObject>

@optional
- (void)colorsView:(DMColorsView *)colorsView didTapColr:(UIColor *)color strHex:(NSString *)strHex;

@end

@interface DMColorsView : UIView

@property (strong, nonatomic) NSArray *colors;

@property (weak, nonatomic) id<DMColorsViewDelegate> delegate;

@end
