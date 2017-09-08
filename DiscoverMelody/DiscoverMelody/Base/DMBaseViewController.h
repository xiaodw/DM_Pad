//
//  DMBaseViewController.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/4.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMBaseViewController : UIViewController

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *userLabel;

//导航透明
- (void)setNavigationBarTransparence;

//导航条左侧菜单点击
- (void)clickMenuBtn:(id)sender;

//设置导航条右边按钮
- (void)setRigthBtn:(CGRect)frame
              title:(NSString *)title
        titileColor:(UIColor *)titleColor
          imageName:(NSString *)imageName
               font:(UIFont *)font;

//更新导航条用户信息
- (void)updateUserInfo;

@end
