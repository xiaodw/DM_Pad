//
//  DMCustomerPhoneCell.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMCustomerInfoView.h"
@interface DMCustomerPhoneCell : UITableViewCell
@property (nonatomic, strong) DMCustomerInfoView *infoView;

- (void)configObj:(id)obj;
@end
