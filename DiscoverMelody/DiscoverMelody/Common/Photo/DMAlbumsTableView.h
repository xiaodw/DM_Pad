#import <UIKit/UIKit.h>

@class DMAlbumsTableView;

@protocol DMAlbumsTableViewDelegate <NSObject>

@optional
- (void)albumsTableView:(DMAlbumsTableView *)albumsTableView didTapRightButton:(UIButton *)rightButton;
- (void)albumsTableView:(DMAlbumsTableView *)albumsTableView didTapSelectedIndexPath:(NSIndexPath *)indexPath;

@end

@interface DMAlbumsTableView : UIView

@property (strong, nonatomic) NSMutableArray *albums;

@property (weak, nonatomic) id<DMAlbumsTableViewDelegate> delegate;

@end
