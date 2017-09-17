#import <UIKit/UIKit.h>

@class DMCourseModel;

@interface DMBrowseCourseCell : UICollectionViewCell

@property (strong, nonatomic) DMCourseModel *courseModel;

@property (assign, nonatomic) BOOL isFullScreen;

@end
