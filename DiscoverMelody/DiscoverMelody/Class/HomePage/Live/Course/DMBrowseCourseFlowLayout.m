#import "DMBrowseCourseFlowLayout.h"

@implementation DMBrowseCourseFlowLayout

// 定位到某一个cell
- (void)prepareLayout {
    [super prepareLayout];
    
    self.collectionView.contentOffset = self.contentOffset;
}

@end
