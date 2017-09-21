#import "DMBaseMoreController.h"

@class DMLiveController, DMCourseFilesController;

@protocol DMCourseFilesControllerDelegate <NSObject>

@optional
- (void)courseFilesController:(DMCourseFilesController *)courseFilesController syncCourses:(NSArray *)syncCourses;

@end

@interface DMCourseFilesController : DMBaseMoreController

@property (strong, nonatomic) NSString *lessonID;
@property (strong, nonatomic) NSString *classroomID;
@property (weak, nonatomic) DMLiveController *liveVC;
@property (assign, nonatomic) BOOL isFullScreen;
@property (assign, nonatomic) NSInteger columns;
@property (assign, nonatomic) NSInteger rightMargin;
@property (assign, nonatomic) NSInteger leftMargin;
@property (assign, nonatomic) NSInteger columnSpacing;

@property (weak, nonatomic) id<DMCourseFilesControllerDelegate> delegate;

@end
