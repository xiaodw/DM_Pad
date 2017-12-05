#import "DMLiveCoursewareCell.h"
#import <UIView+WebCache.h>
#import "DMClassFileDataModel.h"
#define kColor33 DMColorWithRGBA(33, 33, 33, 1)

@interface DMLiveCoursewareCell()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSArray *array;

@end

@implementation DMLiveCoursewareCell

- (void)setModel:(DMClassFileDataModel *)model {
    _model = model;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
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
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = kColor33;
    }
    
    return _imageView;
}

- (void)dealloc {
    DMLogFunc
}

@end
