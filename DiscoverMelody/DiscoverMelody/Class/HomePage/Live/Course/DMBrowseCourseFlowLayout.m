#import "DMBrowseCourseFlowLayout.h"

@implementation DMBrowseCourseFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.collectionView.contentOffset = self.contentOffset;
}

@end
