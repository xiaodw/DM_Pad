//
//  DMCustomerInfoView.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/11.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockTapEvent)();

@interface DMCustomerInfoView : UITableViewHeaderFooterView

@property (nonatomic, strong) BlockTapEvent blockTapEvent;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame
                     isTap:(BOOL)tap
                blockTapEvent:(BlockTapEvent)blockTapEvent;

- (id)initWithFrame:(CGRect)frame isTap:(BOOL)tap;

- (void)updateSubViewsObj:(id)obj;

- (void)updateSubViewsObj:(id)obj isFurled: (BOOL)isFurled;

@end
