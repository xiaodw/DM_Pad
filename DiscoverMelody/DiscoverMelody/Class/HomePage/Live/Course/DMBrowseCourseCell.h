#import <UIKit/UIKit.h>

@class DMClassFileDataModel, DMAsset;

@interface DMBrowseCourseCell : UICollectionViewCell

@property (strong, nonatomic) DMClassFileDataModel *courseModel;
@property (strong, nonatomic) DMAsset *asset;

@property (assign, nonatomic) BOOL isFullScreen;

@end
