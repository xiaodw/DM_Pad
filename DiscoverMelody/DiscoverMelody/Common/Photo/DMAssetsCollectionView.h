#import <UIKit/UIKit.h>

@class DMAssetsCollectionView, DMAlbum;

@protocol DMAssetsCollectionViewDelegate <NSObject>

@optional
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapRightButton:(UIButton *)rightButton;
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapLeftButton:(UIButton *)leftButton;
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView success:(NSArray *)courses;

@end

@interface DMAssetsCollectionView : UIView

@property (strong, nonatomic) DMAlbum *album;

@property (weak, nonatomic) id<DMAssetsCollectionViewDelegate> delegate;
@property (strong, nonatomic) NSString *lessonID;

@end
