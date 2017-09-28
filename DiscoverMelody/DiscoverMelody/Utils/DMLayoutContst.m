//
//  DMConst.h
//  DiscoverMelody
//

#import "DMLayoutContst.h"

#if LANGUAGE_ENVIRONMENT == 0 //中文
// DMBottomBarView
CGFloat const DMBottomBarViewUploadButtonLeft = 15;
CGFloat const DMBottomBarViewUploadButtonWidth = 55;
CGFloat const DMBottomBarViewDeleteButtonRight = -15;

// DMAssetsCollectionView
CGFloat const DMAssetsCollectionUploadButtonWidth = 94;

// DMNavigationBar
CGFloat const DMNavigationBarLeftButtonWidth = 54;

// DMCourseFilesController
CGFloat const DMCourseFilesNavigationLeftButtonWidth = 44;
CGFloat const DMCourseFilesNavigationRightButtonRight = -5;

// DMCourseListCell
CGFloat const DMCourseListCellStatusButtonWidth = 63;

#elif LANGUAGE_ENVIRONMENT == 1 //英文
// DMBottomBarView
CGFloat const DMBottomBarViewUploadButtonLeft = 0;
CGFloat const DMBottomBarViewUploadButtonWidth = 95;
CGFloat const DMBottomBarViewDeleteButtonRight = 0;

// DMAssetsCollectionView
CGFloat const DMAssetsCollectionUploadButtonWidth = 120;

// DMNavigationBar
CGFloat const DMNavigationBarLeftButtonWidth = 90;

// DMCourseFilesController
CGFloat const DMCourseFilesNavigationLeftButtonWidth = 54;
CGFloat const DMCourseFilesNavigationRightButtonRight = -16;

// DMCourseListCell
CGFloat const DMCourseListCellStatusButtonWidth = 73;

#endif

