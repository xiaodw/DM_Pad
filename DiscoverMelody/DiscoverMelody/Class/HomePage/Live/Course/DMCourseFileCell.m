#import "DMCourseFileCell.h"
#import "DMClassFileDataModel.h"
#import "DMAsset.h"
#import "DMAssetInfo.h"
#import "DMAssetTIFF.h"
#import "NSString+Extension.h"

#define kLndexLabelWH 20

@interface DMCourseFileCell()

@property (strong, nonatomic) UILabel *indexLabel;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DMCourseFileCell

- (void)setAsset:(DMAsset *)asset {
    _asset = asset;

    self.imageView.image = asset.thumbnail;
    
    NSString *indexString = asset.selectedIndex == 0 ? @"" : [NSString stringWithFormat:@"%zd", asset.selectedIndex];
    if (!_editorMode) return;
    
    _indexLabel.hidden = asset.status != DMAssetStatusNormal;
    
    _statusImageView.hidden = (asset.status == DMAssetStatusNormal || asset.status == DMAssetStatusUploading);
    _statusImageView.image = asset.status == DMAssetStatusSuccess ? [UIImage imageNamed:@"icon_success"] : [UIImage imageNamed:@"icon_fail"];
    asset.status == DMAssetStatusUploading ? [_activityIndicatorView startAnimating] : [_activityIndicatorView stopAnimating];
    
    self.indexLabel.layer.borderColor = asset.isSelected ? DMColorBaseMeiRed.CGColor : DMColorWithHexString(@"#999999").CGColor;
    _indexLabel.backgroundColor = asset.isSelected ? DMColorBaseMeiRed : [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _indexLabel.text = [NSString stringWithFormat:@"%@", indexString];
}

- (void)setCourseModel:(DMClassFileDataModel *)courseModel{
    _courseModel = courseModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[courseModel.img_thumb trim]] placeholderImage:[UIImage imageNamed:@"image_placeholder_280"]];
    NSString *indexString = courseModel.selectedIndex == 0 ? @"" : [NSString stringWithFormat:@"%zd", courseModel.selectedIndex];
    if (!_editorMode) return;
    
    self.indexLabel.layer.borderColor = courseModel.isSelected ? DMColorBaseMeiRed.CGColor : DMColorWithHexString(@"#999999").CGColor;
    _indexLabel.backgroundColor = courseModel.isSelected ? DMColorBaseMeiRed : [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _indexLabel.text = [NSString stringWithFormat:@"%@", indexString];
}

- (void)setShowBorder:(BOOL)showBorder {
    _showBorder = showBorder;
    
    NSInteger borderWidth = _showBorder ? 1.5 : 0;
    if (_showBorder) {
        _imageView.layer.borderColor = DMColorBaseMeiRed.CGColor;
    }
    _imageView.layer.borderWidth = borderWidth;
}

- (void)setEditorMode:(BOOL)editorMode {
    _editorMode = editorMode;
    
    self.indexLabel.hidden = !_editorMode;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.statusImageView];
        [self.contentView addSubview:self.activityIndicatorView];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [_indexLabel makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kLndexLabelWH, kLndexLabelWH));
            make.top.equalTo(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
        }];
        
        [_activityIndicatorView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_indexLabel);
        }];
        
        [_statusImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_indexLabel);
        }];
    }
    return self;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [UIImageView new];
        _statusImageView.hidden = YES;
    }
    
    return _statusImageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [UILabel new];
        _indexLabel.clipsToBounds = YES;
        _indexLabel.font = DMFontPingFang_Light(14);
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.layer.cornerRadius = kLndexLabelWH * 0.5;
        _indexLabel.layer.borderWidth = 1;
    }
    
    return _indexLabel;
}

- activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    return _activityIndicatorView;
}

@end
