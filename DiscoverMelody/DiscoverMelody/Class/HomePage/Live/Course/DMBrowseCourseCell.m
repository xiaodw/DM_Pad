#import "DMBrowseCourseCell.h"
#import "DMClassFileDataModel.h"
#import "DMAsset.h"
#import "NSString+Extension.h"

@interface DMBrowseCourseCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation DMBrowseCourseCell

- (void)setAsset:(DMAsset *)asset {
    _asset = asset;
    self.imageView.image = asset.thumbnail;
}

- (void)setCourseModel:(DMClassFileDataModel *)courseModel{
    _courseModel = courseModel;
    
    if (!_isFullScreen) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[courseModel.img_thumb trim]] placeholderImage:[UIImage imageNamed:@"image_placeholder_280"]];
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
