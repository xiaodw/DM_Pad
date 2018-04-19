#import <UIKit/UIKit.h>

@class DMSycBrowseView;

@protocol DMSycBrowseViewDelegate<NSObject>

@optional
- (void)sycBrowseViewDidTapWhiteBoard:(DMSycBrowseView *)sycBrowseView;
- (void)sycBrowseView:(DMSycBrowseView *)sycBrowseView didTapIndexPath:(NSIndexPath *)indexPath;

@end

@interface DMSycBrowseView : UIView

@property (strong, nonatomic) NSArray *allCoursewares;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (weak, nonatomic) id<DMSycBrowseViewDelegate> delegate;

@end
