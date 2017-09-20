//
//  DMBrowseCourseFlowLayout.m
//  DiscoverMelody
//
//  Created by My mac on 2017/9/19.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBrowseCourseFlowLayout.h"

@implementation DMBrowseCourseFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.collectionView.contentOffset = self.contentOffset;
}

@end
