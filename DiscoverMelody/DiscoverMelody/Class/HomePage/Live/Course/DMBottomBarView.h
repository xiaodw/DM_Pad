#import <UIKit/UIKit.h>

@class DMBottomBarView;

@protocol DMBottomBarViewDelegate <NSObject>

@optional
- (void)botoomBarViewDidTapUpload:(DMBottomBarView *)botoomBarView;
- (void)botoomBarViewDidTapSync:(DMBottomBarView *)botoomBarView;
- (void)botoomBarViewDidTapDelete:(DMBottomBarView *)botoomBarView;

@end

@interface DMBottomBarView : UIView

@property (weak, nonatomic) id<DMBottomBarViewDelegate> delegate;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIButton *syncButton;
@property (strong, nonatomic) UIButton *deleteButton;

@end
