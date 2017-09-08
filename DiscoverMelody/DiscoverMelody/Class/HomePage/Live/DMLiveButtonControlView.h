#import <Foundation/Foundation.h>

@class DMLiveButtonControlView;

@protocol DMLiveButtonControlViewDelegate <NSObject>

@optional
- (void)liveButtonControlViewDidTapLeave:(DMLiveButtonControlView *)liveButtonControlView;
- (void)liveButtonControlViewDidTapSwichCamera:(DMLiveButtonControlView *)liveButtonControlView;
- (void)liveButtonControlViewDidTapSwichLayout :(DMLiveButtonControlView *)liveButtonControlView;
- (void)liveButtonControlViewDidTapCourseFiles:(DMLiveButtonControlView *)liveButtonControlView;

@end

@interface DMLiveButtonControlView : UIView

@property (weak, nonatomic) id<DMLiveButtonControlViewDelegate> delegate;

@end
