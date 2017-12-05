//
//  DMMenuCell.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/8.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMMenuCell : UITableViewCell
@property (strong, nonatomic) UIView *redView;
- (void)configObj:(NSString *)title imageName:(NSString *)imageName;
@end
