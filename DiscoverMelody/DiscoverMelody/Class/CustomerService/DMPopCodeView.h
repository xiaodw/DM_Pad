//
//  DMPopCodeView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMPopCodeView : UIView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)messge imageName:(NSString *)imageName;
-(void)show;

@end
