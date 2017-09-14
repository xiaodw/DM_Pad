#import <UIKit/UIKit.h>

@class DMCourseListCell;

@protocol DMCourseListCellDelegate <NSObject>

@optional
- (void)courseListCellDidTapCoursesFiles:(DMCourseListCell *)courseListCell;
- (void)courseListCellDidTapRelook:(DMCourseListCell *)courseListCell;
- (void)courseListCellDidTapQuestionnaire:(DMCourseListCell *)courseListCell;

@end

@interface DMCourseListCell : UITableViewCell

@property (weak, nonatomic) id<DMCourseListCellDelegate> delegate;

@property (strong, nonatomic) NSObject *model;

@end
