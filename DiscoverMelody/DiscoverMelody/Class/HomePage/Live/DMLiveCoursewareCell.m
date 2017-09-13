#import "DMLiveCoursewareCell.h"
#import <UIView+WebCache.h>


@interface DMLiveCoursewareCell()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSArray *array;

@end

@implementation DMLiveCoursewareCell

- (void)setModel:(NSObject *)model {
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self.contentView addSubview:self.imageView];
}

- (void)setupMakeLayoutSubviews {
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        [_imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_imageView sd_setShowActivityIndicatorView:YES];
    }
    
    return _imageView;
}

- (void)dealloc {
    DMLogFunc
}

@end
