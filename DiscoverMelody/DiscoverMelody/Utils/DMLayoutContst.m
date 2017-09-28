//
//  DMConst.h
//  DiscoverMelody
//

#import "DMLayoutContst.h"
#import "DMMacros.h"


#if LANGUAGE_ENVIRONMENT == 0 //中文
<<<<<<< HEAD


=======
// DMBottomBarView
>>>>>>> bf01d6e1f1be75bbbb8b2c1586d52d59980636a3
CGFloat const DMBottomBarViewUploadButtonLeft = 15;
CGFloat const DMBottomBarViewUploadButtonWidth = 55;
CGFloat const DMBottomBarViewDeleteButtonRight = -15;

<<<<<<< HEAD

//侧滑菜单的LOGO
NSString * const DMMenu_Logo = @"DM_LOGO";

//课程列表右上角的筛选列表
CGFloat const DMRightPullDownMenuRectWidth = 135;
CGFloat const DMRightPullDownMenuRectX = 0;
CGFloat const DMRightPullDownMenuCellLeft = 20;
CGFloat const DMRightPullDownMenuCellRight = -15;

//首页
CGFloat const DMHomeViewTopViewRightLabelWidth = 70;
CGFloat const DMHomeViewTopViewRightLabelRight = -46;
CGFloat const DMHomeViewCellTimeLabelLeft = 0;      //首页Cell 课程时间label的左间距

#elif LANGUAGE_ENVIRONMENT == 1 //英文


=======
// DMAssetsCollectionView
CGFloat const DMAssetsCollectionUploadButtonWidth = 94;

// DMNavigationBar
CGFloat const DMNavigationBarLeftButtonWidth = 54;

// DMCourseFilesController
CGFloat const DMCourseFilesNavigationLeftButtonWidth = 44;
CGFloat const DMCourseFilesNavigationRightButtonRight = -5;

#elif LANGUAGE_ENVIRONMENT == 1 //英文
// DMBottomBarView
>>>>>>> bf01d6e1f1be75bbbb8b2c1586d52d59980636a3
CGFloat const DMBottomBarViewUploadButtonLeft = 0;
CGFloat const DMBottomBarViewUploadButtonWidth = 95;
CGFloat const DMBottomBarViewDeleteButtonRight = 0;

<<<<<<< HEAD

//侧滑菜单的LOGO
NSString * const DMMenu_Logo = @"DM_LOGO_EN";

//课程列表右上角的筛选列表
CGFloat const DMRightPullDownMenuRectWidth = 135+45;
CGFloat const DMRightPullDownMenuRectX = 45;
CGFloat const DMRightPullDownMenuCellLeft = 5;
CGFloat const DMRightPullDownMenuCellRight = -33;

//首页
CGFloat const DMHomeViewTopViewRightLabelWidth = 162;
CGFloat const DMHomeViewTopViewRightLabelRight = 0;
CGFloat const DMHomeViewCellTimeLabelLeft = 45;      //首页Cell 课程时间label的左间距

=======
// DMAssetsCollectionView
CGFloat const DMAssetsCollectionUploadButtonWidth = 120;

// DMNavigationBar
CGFloat const DMNavigationBarLeftButtonWidth = 90;

// DMCourseFilesController
CGFloat const DMCourseFilesNavigationLeftButtonWidth = 54;
CGFloat const DMCourseFilesNavigationRightButtonRight = -16;
>>>>>>> bf01d6e1f1be75bbbb8b2c1586d52d59980636a3

#endif

