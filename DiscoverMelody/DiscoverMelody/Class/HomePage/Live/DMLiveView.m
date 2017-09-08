#import "DMLiveView.h"

@interface DMLiveView()

@property (strong, nonatomic) NSArray *animationImages;

@end

@implementation DMLiveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMakeAddSubviews];
        [self setupMakeLayoutSubviews];
    }
    return self;
}

- (void)setupMakeAddSubviews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.speakingImageView];
}

- (void)setupMakeLayoutSubviews {
    [_speakingImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.size.equalTo(CGSizeMake(21, 29));
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_speakingImageView);
        make.right.equalTo(_speakingImageView.mas_left).offset(-7);
    }];
}

- (NSArray *)animationImages {
    if (!_animationImages) {
        NSMutableArray *images = [NSMutableArray array];
        NSString *iconName = @"icon_microphone_%dpng";
        for (int i = 0; i < 5; i++) {
            NSString *resource = [NSString stringWithFormat:iconName,i];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:nil];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
            [images addObject:image];
        }
        
        _animationImages = images;
    }
    
    return _animationImages;
}
- (UIImageView *)speakingImageView {
    if (!_speakingImageView) {
        _speakingImageView = [UIImageView new];
        _speakingImageView.animationImages = self.animationImages;
    }
    
    return _speakingImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = DMFontPingFang_Light(14);
    }
    
    return _nameLabel;
}

- (void)dealloc {
    DMLogFunc
}

@end
