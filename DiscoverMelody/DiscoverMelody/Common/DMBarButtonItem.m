#import "DMBarButtonItem.h"

@implementation DMBarButtonItem

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // self
    CGSize selfSize = self.frame.size;
    CGFloat selfHeight = selfSize.height;
    
    // imageView
    CGSize imageViewSize = self.imageView.frame.size;
    CGFloat imageViewWidth = imageViewSize.width;
    CGFloat imageViewHeight = imageViewSize.height;
    
    // titleLabel
    CGSize titleLabelSize = self.titleLabel.frame.size;
    CGFloat titleLabelWidth = titleLabelSize.width;
    CGFloat titleLabelHeight = titleLabelSize.height;
    
    CGFloat titleLabelY = (selfHeight - titleLabelHeight) * 0.5;
    CGFloat titleLabelX = _titleSpacing + imageViewWidth;
    CGFloat imageViewY = (selfHeight - imageViewHeight) * 0.5;
    
    // imageView Frame
    self.imageView.frame = CGRectMake(0 , imageViewY, imageViewWidth, imageViewHeight);
    // titleLabel Frame
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHeight);
}

@end
