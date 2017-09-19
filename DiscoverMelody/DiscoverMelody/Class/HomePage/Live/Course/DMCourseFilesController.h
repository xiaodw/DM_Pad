#import "DMBaseMoreController.h"

@class DMLiveController;
@interface DMCourseFilesController : DMBaseMoreController

@property (strong, nonatomic) NSString *lessonID;
@property (strong, nonatomic) NSString *classroomID;
@property (weak, nonatomic) DMLiveController *liveVC;

@end
