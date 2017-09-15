//
//  DMCourseFileCell.h
//  DiscoverMelody
//
//  Created by My mac on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMCourseModel;

@interface DMCourseFileCell : UICollectionViewCell

@property (assign, nonatomic, getter=isEditorMode) BOOL editorMode;
@property (strong, nonatomic) DMCourseModel *courseModel;

@end
