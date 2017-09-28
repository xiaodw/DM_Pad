//
//  DMConst.h
//  DiscoverMelody
//

#import "DMLayoutContst.h"

#if LANGUAGE_ENVIRONMENT == 0 //中文
CGFloat const DMBottomBarViewUploadButtonLeft = 15;
CGFloat const DMBottomBarViewUploadButtonWidth = 55;
CGFloat const DMBottomBarViewDeleteButtonRight = -15;

#elif LANGUAGE_ENVIRONMENT == 1 //英文
CGFloat const DMBottomBarViewUploadButtonLeft = 0;
CGFloat const DMBottomBarViewUploadButtonWidth = 95;
CGFloat const DMBottomBarViewDeleteButtonRight = 0;

#endif

