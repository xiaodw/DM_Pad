//
//  DMTextView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTextView.h"
@interface DMTextView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) SKTextView *textSubView;
@end
