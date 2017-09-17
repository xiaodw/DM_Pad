//
//  DMAlbrmsTableView.h
//  collectuonview
//
//  Created by My mac on 2017/9/17.
//  Copyright © 2017年 My mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMAlbrmsTableView;

@protocol DMAlbrmsTableViewDelegate <NSObject>

@optional
- (void)albrmsTableView:(DMAlbrmsTableView *)albrmsTableView didTapRightButton:(UIButton *)rightButton;

@end

@interface DMAlbrmsTableView : UIView

@property (strong, nonatomic) NSMutableArray *albums;

@property (weak, nonatomic) id<DMAlbrmsTableViewDelegate> delegate;

@end
