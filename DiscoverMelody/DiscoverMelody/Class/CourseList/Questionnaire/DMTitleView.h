//
//  DMTitleView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/14.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Content_Label_W DMScreenWidth-64
@interface DMTitleView : UITableViewHeaderFooterView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *contentLabel;
- (void)updateInfo:(NSInteger)index content:(NSString *)content;
@end
