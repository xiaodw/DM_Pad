#import "DMButton.h"

@interface DMButton()

@property (nonatomic, strong) UIPanGestureRecognizer *panGuestureRecognizer;

@end

@implementation DMButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleAlignment = DMTitleButtonTypeLeft;
    }
    return self;
}

- (void)setHiddenPanGuesture:(BOOL)hiddenPanGuesture {
    _hiddenPanGuesture = hiddenPanGuesture;
    if (!hiddenPanGuesture) return;
    
    [self addGestureRecognizer:self.panGuestureRecognizer];
}

- (UIPanGestureRecognizer *)panGuestureRecognizer {
    if (!_panGuestureRecognizer) {
        _panGuestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanGuestureRecognizer:)];
    }
    
    return _panGuestureRecognizer;
}

- (void)didPanGuestureRecognizer:(UIPanGestureRecognizer *)pan {
    UIView *view = pan.view;
    CGPoint translation = [pan translationInView:view.superview];
    [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
    [pan setTranslation:CGPointZero inView:view.superview];
    
    return;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // self
    CGSize selfSize = self.frame.size;
    CGFloat selfWidth = selfSize.width;
    CGFloat selfHeight = selfSize.height;
    
    // imageView
    CGSize imageViewSize = self.imageView.frame.size;
    CGFloat imageViewWidth = imageViewSize.width;
    CGFloat imageViewHeight = imageViewSize.height;
    
    // titleLabel
    CGSize titleLabelSize = self.titleLabel.frame.size;
    CGFloat titleLabelWidth = titleLabelSize.width;
    CGFloat titleLabelHeight = titleLabelSize.height;
    
    // 水平 总宽度
    CGFloat totalWidth = imageViewWidth + self.spacing + titleLabelWidth;
    // 水平 左间距
    CGFloat horizontalLeftMargin = (selfWidth - totalWidth) * 0.5;
    
    // 垂直 总高度
    CGFloat totalHeight = imageViewHeight + self.spacing + titleLabelHeight;
    // 垂直 上间距
    CGFloat verticalTopMargin = (selfHeight - totalHeight) * 0.5;
    
    // titleLabel X位置
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = 0;
    // titleLabel Y位置
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    
    // titleLabel 左边
    if (self.titleAlignment == DMTitleButtonTypeLeft) {
        titleLabelY = (selfHeight - titleLabelHeight) * 0.5;
        titleLabelX = horizontalLeftMargin;
        
        imageViewX = horizontalLeftMargin + titleLabelWidth + self.spacing;
        imageViewY = (selfHeight - imageViewHeight) * 0.5;
    }
    // titleLabel 右边
    if (self.titleAlignment == DMTitleButtonTypeRight) {
        imageViewX = horizontalLeftMargin;
        imageViewY = (selfHeight - imageViewHeight) * 0.5;
        
        titleLabelY = (selfHeight - titleLabelHeight) * 0.5;
        titleLabelX = horizontalLeftMargin + imageViewWidth + self.spacing;
    }
    // titleLabel 上边
    if (self.titleAlignment == DMTitleButtonTypeTop) {
        titleLabelY = verticalTopMargin;
        titleLabelX = (selfWidth - titleLabelWidth) * 0.5;
        
        imageViewY = verticalTopMargin + titleLabelHeight + self.spacing;
        imageViewX = (selfWidth - imageViewWidth) * 0.5;
    }
    // titleLabel 下边
    if (self.titleAlignment == DMTitleButtonTypeBottom) {
        imageViewX = (selfWidth - imageViewWidth) * 0.5;
        imageViewY = verticalTopMargin;
        
        titleLabelX = (selfWidth - titleLabelWidth) * 0.5;
        titleLabelY = verticalTopMargin + imageViewHeight + self.spacing;
    }
    
    // titleLabel Frame
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHeight);
    
    // imageView Frame
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
}

@end

@implementation DMNotHighlightedButton

- (void)setHighlighted:(BOOL)highlighted {}

@end
