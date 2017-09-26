#import "DMBrowseCourseCell.h"
#import "DMClassFileDataModel.h"
#import "DMAsset.h"
#import "NSString+Extension.h"
#import "DMActivityView.h"

@interface DMBrowseCourseCell()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) DMActivityView *activityView;

@end

@implementation DMBrowseCourseCell

- (void)setAsset:(DMAsset *)asset {
    _asset = asset;
    self.imageView.image = asset.compressionImage;
}

- (void)setCourseModel:(DMClassFileDataModel *)courseModel{
    _courseModel = courseModel;
    _activityView.hidden = NO;
    [self.activityView showInView:self.imageView];
    if (!_isFullScreen) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[courseModel.img trim]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.activityView hide];
        }];
        return;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.activityView];
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

- (DMActivityView *)activityView {
    if (!_activityView) {
        _activityView = [DMActivityView new];
        _activityView.hidden = YES;
    }
    
    return _activityView;
}

@end
