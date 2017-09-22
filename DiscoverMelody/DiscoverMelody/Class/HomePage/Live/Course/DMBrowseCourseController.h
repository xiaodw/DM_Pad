#import <UIKit/UIKit.h>
#import "DMBaseMoreController.h"

@class DMBrowseCourseController, DMLiveController;

@protocol DMBrowseCourseControllerDelegate <NSObject>

@optional
- (void)browseCourseController:(DMBrowseCourseController *)browseCourseController deleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface DMBrowseCourseController : DMBaseMoreController


@property (weak, nonatomic) id<DMBrowseCourseControllerDelegate> browseDelegate;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) NSMutableArray *courses;
@property (strong, nonatomic) NSString *lessonID;

@property (assign, nonatomic) CGSize itemSize;
@property (weak, nonatomic) DMLiveController *liveVC;

@end
