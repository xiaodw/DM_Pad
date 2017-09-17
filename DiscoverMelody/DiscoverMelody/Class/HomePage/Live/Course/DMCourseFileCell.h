#import <UIKit/UIKit.h>

@class DMCourseModel, DMAsset;

@interface DMCourseFileCell : UICollectionViewCell

@property (assign, nonatomic, getter=isEditorMode) BOOL editorMode;
@property (strong, nonatomic) DMCourseModel *courseModel;
@property (assign, nonatomic) BOOL showBorder;

@property (strong, nonatomic) DMAsset *asset;

@end
