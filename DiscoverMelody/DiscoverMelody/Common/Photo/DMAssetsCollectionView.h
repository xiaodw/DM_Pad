//
//  DMAssetsCollectionView.h
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMAssetsCollectionView, DMAlbum;

@protocol DMAssetsCollectionViewDelegate <NSObject>

@optional
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapRightButton:(UIButton *)rightButton;
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapLeftButton:(UIButton *)leftButton;
- (void)albrmsCollectionView:(DMAssetsCollectionView *)albrmsCollectionView didTapUploadButton:(UIButton *)uploadButton;

@end

@interface DMAssetsCollectionView : UIView

@property (strong, nonatomic) DMAlbum *album;

@property (weak, nonatomic) id<DMAssetsCollectionViewDelegate> delegate;

@end
