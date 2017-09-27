//
//  DMHomeView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/6.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMHomeVCDelegate <NSObject>
- (void)clickCourseFiles:(id)sender;
- (void)clickClassRoom:(id)sender;
- (void)clickReload:(id)sender;
- (void)selectedCourse:(DMCourseDatasModel *)courseObj;
@end

@interface DMHomeView : UIView
@property (nonatomic, weak)id <DMHomeVCDelegate>delegate;
@property (nonatomic, strong) NSArray *datas;
- (id)initWithFrame:(CGRect)frame delegate:(id<DMHomeVCDelegate>) delegate;
- (void)reloadHomeTableView;
- (void)disPlayNoCourseView:(BOOL)display isError:(BOOL)error;
- (void)initSelectedIndexPath;
@end
