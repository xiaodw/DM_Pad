#import <UIKit/UIKit.h>

@class DMClassFileDataModel, DMAsset;

@interface DMCourseFileCell : UICollectionViewCell

@property (assign, nonatomic, getter=isEditorMode) BOOL editorMode;
@property (strong, nonatomic) DMClassFileDataModel *courseModel;
@property (assign, nonatomic) BOOL showBorder;

@property (strong, nonatomic) DMAsset *asset;

@end
