#import "DMBrowseCourseCell.h"
#import "DMCourseModel.h"

@interface DMBrowseCourseCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation DMBrowseCourseCell

- (void)setCourseModel:(DMCourseModel *)courseModel{
    _courseModel = courseModel;
    
    if (!_isFullScreen) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:courseModel.url]];
        return;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

@end
