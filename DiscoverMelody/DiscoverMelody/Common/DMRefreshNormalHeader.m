//
//  DMRefreshNormalHeader.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/27.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMRefreshNormalHeader.h"

const CGFloat DMRefreshHeaderHeight = 60;
const CGFloat DMRefreshHeaderTitleHeight = 15;
const CGFloat DMRefreshHeaderTitleTopAndBottom = 13;

@implementation DMRefreshNormalHeader

- (void)prepare
{
    [super prepare];
    
    // 设置key
    self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
    
    // 设置高度
    self.mj_h = DMRefreshHeaderHeight;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        if (noConstrainsOnStatusLabel) self.stateLabel.frame = self.bounds;
        return;
    }
    
    // 状态
    if (noConstrainsOnStatusLabel) {
        self.stateLabel.mj_x = 0;
        self.stateLabel.mj_y = DMRefreshHeaderTitleTopAndBottom;
        self.stateLabel.mj_w = self.mj_w;
        self.stateLabel.mj_h = DMRefreshHeaderTitleHeight;
    }
    
    // 更新时间
    if (self.lastUpdatedTimeLabel.constraints.count == 0) {
        self.lastUpdatedTimeLabel.mj_x = 0;
        self.lastUpdatedTimeLabel.mj_w = self.mj_w;
        self.lastUpdatedTimeLabel.mj_h = DMRefreshHeaderTitleHeight;
        self.lastUpdatedTimeLabel.mj_y = self.mj_h - DMRefreshHeaderTitleTopAndBottom - self.lastUpdatedTimeLabel.mj_h;
    }
}

@end
