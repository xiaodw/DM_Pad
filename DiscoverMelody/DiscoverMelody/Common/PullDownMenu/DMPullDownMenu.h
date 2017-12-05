//
//  DMPullDownMenu.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMPullDownMenu;

@protocol DMPullDownMenuDelegate <NSObject>

@optional

- (void)pulldownMenuWillShow:(DMPullDownMenu *)menu;    // 当下拉菜单将要显示时调用
- (void)pulldownMenuDidShow:(DMPullDownMenu *)menu;     // 当下拉菜单已经显示时调用
- (void)pulldownMenuWillHidden:(DMPullDownMenu *)menu;  // 当下拉菜单将要收起时调用
- (void)pulldownMenuDidHidden:(DMPullDownMenu *)menu;   // 当下拉菜单已经收起时调用

- (void)pulldownMenu:(DMPullDownMenu *)menu selectedCellNumber:(NSInteger)number; // 当选择某个选项时调用

@end

@interface DMPullDownMenu : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton * mainBtn;  // 主按钮 可以自定义样式 可在.m文件中修改默认的一些属性

@property (nonatomic, assign) id <DMPullDownMenuDelegate>delegate;


- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight;  // 设置下拉菜单控件样式
- (void)clickMainBtn:(UIButton *)button;
- (void)showPullDown; // 显示下拉菜单
- (void)hidePullDown; // 隐藏下拉菜单

@end
