//
//  DMBrowseCourseView.h
//  DiscoverMelody
//
//  Created by My mac on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMBrowseCourseView;

@protocol DMBrowseCourseViewDelegate <NSObject>

@optional
- (void)rowseCourseView:(DMBrowseCourseView *)rowseCourseView deleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface DMBrowseCourseView : UIView

@property (weak, nonatomic) id<DMBrowseCourseViewDelegate> delegate;

@end
