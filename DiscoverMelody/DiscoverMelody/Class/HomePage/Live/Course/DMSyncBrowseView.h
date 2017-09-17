#import <UIKit/UIKit.h>

@class DMSyncBrowseView;

@protocol DMSyncBrowseViewDelegate <NSObject>

@optional
- (void)syncBrowseViewDidTapSync:(DMSyncBrowseView *)syncBrowseView;

@end

@interface DMSyncBrowseView : UIView

@property (weak, nonatomic) id<DMSyncBrowseViewDelegate> delegate;

@property (strong, nonatomic) NSArray *syncCourses;

@end
