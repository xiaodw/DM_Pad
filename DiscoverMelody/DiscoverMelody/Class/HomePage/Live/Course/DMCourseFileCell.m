#import "DMCourseFileCell.h"
#import "DMCourseModel.h"
#import "DMAsset.h"

#define kLndexLabelWH 20

@interface DMCourseFileCell()

@property (strong, nonatomic) UILabel *indexLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation DMCourseFileCell

- (void)setAsset:(DMAsset *)asset {
    _asset = asset;
    self.imageView.image = asset.thumbnail;
}

- (void)setShowBorder:(BOOL)showBorder {
    _showBorder = showBorder;
    
    NSInteger borderWidth = _showBorder ? 2 : 0;
    if (_showBorder) {
        _imageView.layer.borderColor = DMColorBaseMeiRed.CGColor;
    }
    _imageView.layer.borderWidth = borderWidth;
}

- (void)setEditorMode:(BOOL)editorMode {
    _editorMode = editorMode;
    
    self.indexLabel.hidden = !_editorMode;
}

- (void)setCourseModel:(DMCourseModel *)courseModel{
    _courseModel = courseModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:courseModel.url]];
    NSString *indexString = courseModel.selectedIndex == 0 ? @"" : [NSString stringWithFormat:@"%zd", courseModel.selectedIndex];
    if (!_editorMode) return;
    
    self.indexLabel.layer.borderColor = courseModel.isSelected ? DMColorBaseMeiRed.CGColor : [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    _indexLabel.backgroundColor = courseModel.isSelected ? DMColorBaseMeiRed : [[UIColor blackColor] colorWithAlphaComponent:0.25];
    _indexLabel.text = [NSString stringWithFormat:@"%@", indexString];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.indexLabel];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [_indexLabel makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kLndexLabelWH, kLndexLabelWH));
            make.top.equalTo(5);
            make.right.equalTo(self.contentView.mas_right).offset(-5);
        }];
    }
    return self;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        
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

@end
