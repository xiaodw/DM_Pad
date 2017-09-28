//
//  DMConst.h
//  DiscoverMelody
//

#import <UIKit/UIKit.h>


#if LANGUAGE_ENVIRONMENT == 0 //中文
//首页
#define DMHomeViewCellNameLabelWidth  298     //首页Cell 课程名label的宽度
#define DMHomeViewCellStatusLabelWidth 298   //首页Cell 课程状态label的宽度

#elif LANGUAGE_ENVIRONMENT == 1 //英文
//首页
#define DMHomeViewCellNameLabelWidth   (DMScreenWidth/2-80)   //首页Cell 课程名label的宽度
#define DMHomeViewCellStatusLabelWidth (DMScreenWidth/2-100)/3  //首页Cell 课程状态label的宽度

#endif



// DMBottomBarView
UIKIT_EXTERN CGFloat const DMBottomBarViewUploadButtonLeft;
UIKIT_EXTERN CGFloat const DMBottomBarViewUploadButtonWidth;
UIKIT_EXTERN CGFloat const DMBottomBarViewDeleteButtonRight;

<<<<<<< HEAD
//侧滑菜单的Logo
UIKIT_EXTERN NSString * const DMMenu_Logo;

//课程列表右上角的筛选列表
UIKIT_EXTERN CGFloat const DMRightPullDownMenuRectWidth;//列表的宽度
UIKIT_EXTERN CGFloat const DMRightPullDownMenuRectX;    //列表的X
UIKIT_EXTERN CGFloat const DMRightPullDownMenuCellLeft; //cell的左间距
UIKIT_EXTERN CGFloat const DMRightPullDownMenuCellRight;//cell的右间距

//首页
UIKIT_EXTERN CGFloat const DMHomeViewTopViewRightLabelWidth; //右侧label的宽度
UIKIT_EXTERN CGFloat const DMHomeViewTopViewRightLabelRight; //右侧label的右间距
UIKIT_EXTERN CGFloat const DMHomeViewCellTimeLabelLeft;      //首页Cell 课程时间label的左间距















=======
// DMAssetsCollectionView
UIKIT_EXTERN CGFloat const DMAssetsCollectionUploadButtonWidth;

// DMNavigationBar
UIKIT_EXTERN CGFloat const DMNavigationBarLeftButtonWidth;

// DMCourseFilesController
UIKIT_EXTERN CGFloat const DMCourseFilesNavigationLeftButtonWidth;
UIKIT_EXTERN CGFloat const DMCourseFilesNavigationRightButtonRight;
>>>>>>> bf01d6e1f1be75bbbb8b2c1586d52d59980636a3

