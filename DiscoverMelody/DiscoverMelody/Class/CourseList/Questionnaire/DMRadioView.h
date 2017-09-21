//
//  DMRadioView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRadioView : UIView
//@property (nonatomic, strong) UIButton *yesButton;
//@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIButton *selButton;
- (void)updateButtonTitle:(NSString *)title;
@end
