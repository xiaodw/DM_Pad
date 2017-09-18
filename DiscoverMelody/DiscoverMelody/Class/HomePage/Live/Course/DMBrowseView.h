#import <UIKit/UIKit.h>

@class DMBrowseView;

@protocol DMBrowseViewDelegate <NSObject>

@optional
- (void)browseViewDidTapSync:(DMBrowseView *)browseView;

@end

typedef NS_ENUM(NSInteger, DMBrowseViewType) {
    DMBrowseViewTypeSync,
    DMBrowseViewTypeUpload
};

@interface DMBrowseView : UIView

@property (weak, nonatomic) id<DMBrowseViewDelegate> delegate;

@property (strong, nonatomic) NSArray *courses;

@property (assign, nonatomic) DMBrowseViewType browseType;

@end
