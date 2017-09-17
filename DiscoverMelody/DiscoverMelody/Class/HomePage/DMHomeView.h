//
//  DMHomeView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/6.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMHomeVCDelegate <NSObject>
- (void)clickCourseFiles;
- (void)clickClassRoom;
- (void)clickReload;
- (void)selectedCourse:(NSString *)lessonID;
@end

@interface DMHomeView : UIView
@property (nonatomic, weak)id <DMHomeVCDelegate>delegate;
@property (nonatomic, strong) NSArray *datas;
- (id)initWithFrame:(CGRect)frame delegate:(id<DMHomeVCDelegate>) delegate;
- (void)reloadHomeTableView;
- (void)disPlayNoCourseView:(BOOL)display isError:(BOOL)error;
@end
