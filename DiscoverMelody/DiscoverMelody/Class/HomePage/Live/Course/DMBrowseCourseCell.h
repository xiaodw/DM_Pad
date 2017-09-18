#import <UIKit/UIKit.h>

@class DMCourseModel, DMAsset;

@interface DMBrowseCourseCell : UICollectionViewCell

@property (strong, nonatomic) DMCourseModel *courseModel;
@property (strong, nonatomic) DMAsset *asset;

@property (assign, nonatomic) BOOL isFullScreen;

@end
