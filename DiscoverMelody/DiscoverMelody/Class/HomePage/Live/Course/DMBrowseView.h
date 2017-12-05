#import <UIKit/UIKit.h>

@class DMBrowseView, DMAsset;

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

@property (assign, nonatomic) BOOL isFirst;

@property (assign, nonatomic) DMBrowseViewType browseType;

- (void)refrenshAssetStatus:(DMAsset *)asset;

@end
