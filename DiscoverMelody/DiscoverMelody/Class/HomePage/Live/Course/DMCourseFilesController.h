#import "DMBaseMoreController.h"

@class DMLiveController;
@interface DMCourseFilesController : DMBaseMoreController

@property (strong, nonatomic) NSString *lessonID;
@property (strong, nonatomic) NSString *classroomID;
@property (weak, nonatomic) DMLiveController *liveVC;
@property (assign, nonatomic) BOOL isFullScreen;
@property (assign, nonatomic) NSInteger columns;
@property (assign, nonatomic) NSInteger rightMargin;
@property (assign, nonatomic) NSInteger leftMargin;
@property (assign, nonatomic) NSInteger columnSpacing;

@end
