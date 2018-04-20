#import <UIKit/UIKit.h>

@class DMLiveCoursewareView;

@protocol DMLiveCoursewareViewDelegate <NSObject>

@optional
- (void)liveCoursewareViewDidTapClose:(DMLiveCoursewareView *)liveCoursewareView;

@end

@interface DMLiveCoursewareView : UIView

@property (weak, nonatomic) id<DMLiveCoursewareViewDelegate> delegate;

@property (strong, nonatomic) NSArray *allCoursewares;

- (void)resetWhiteBoard;

@end
