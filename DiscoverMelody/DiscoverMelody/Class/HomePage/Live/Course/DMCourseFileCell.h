#import <UIKit/UIKit.h>

@class DMCourseModel;

@interface DMCourseFileCell : UICollectionViewCell

@property (assign, nonatomic, getter=isEditorMode) BOOL editorMode;
@property (strong, nonatomic) DMCourseModel *courseModel;
@property (assign, nonatomic) BOOL showBorder;

@end
