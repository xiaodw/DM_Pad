#import "DMTabBarView.h"
#import "DMButton.h"

#define kSeparaterWidth 0.5
#define kSeparaterHeight 30
#define kSelfHeight 50

@interface DMTabBarView()

@property (strong, nonatomic) UIView *slippageView;

@property (strong, nonatomic) NSMutableArray *buttons;

@property (strong, nonatomic) UIButton *selectedButton;

@property (strong, nonatomic) UIView *separaterView;

@end

@implementation DMTabBarView

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self setupMakeAddSubviewsAndLayout];
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    _selectedButton.selected = NO;
    _selectedButton = selectedButton;
    _selectedButton.selected = YES;
    
    CGPoint slippagePoint = self.slippageView.center;
    slippagePoint.x = selectedButton.center.x;
    [UIView animateWithDuration:0.15 animations:^{
        self.slippageView.center = slippagePoint;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didTapButton:(UIButton *)sender {
    if (self.selectedButton == sender) return;
    self.selectedButton = sender;
    
    if (![self.delegate respondsToSelector:@selector(tabBarView:didTapBarButton:)]) return;
    [self.delegate tabBarView:self didTapBarButton:sender];
}

- (void)setupMakeAddSubviewsAndLayout {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat selfWidth = _isFullScreen ? DMScreenWidth : DMScreenWidth * 0.5;
    CGFloat width = (selfWidth - (self.titles.count - 1) * kSeparaterWidth) / self.titles.count;
    CGFloat height = kSelfHeight;
    self.buttons = [NSMutableArray array];
    
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = [self setupButtonWithTitle:self.titles[i]];
        button.tag = i;
        [self.buttons addObject:button];
        UIView *separaterView = [self setupView];
        
        x = i * (kSeparaterWidth + width);
        button.frame = CGRectMake(x, y, width, height);
        CGFloat separaterY = (height - kSeparaterHeight) * 0.5;
        separaterView.frame = CGRectMake(width+x, separaterY, kSeparaterWidth, kSeparaterHeight);
        [self addSubview:button];
        if (i == _titles.count-1) break;
        [self addSubview:separaterView];
        
    }
    [self didTapButton:self.buttons.firstObject];
    [self addSubview:self.slippageView];
    [self addSubview:self.separaterView];
    _separaterView.frame = CGRectMake(0, kSelfHeight-0.5, DMScreenWidth*0.5, 0.5);
}

- (UIButton *)setupButtonWithTitle:(NSString *)title {
    UIButton *button = [DMNotHighlightedButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:DMColorWithRGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    [button setTitleColor:DMColorBaseMeiRed forState:UIControlStateSelected];
    [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)setupView {
    UIView *separater = [UIView new];
    separater.backgroundColor = DMColorWithRGBA(221, 221, 221, 1);
    return separater;
}

- (UIView *)slippageView {
    if (!_slippageView) {
        _slippageView = [UIView new];
        _slippageView.backgroundColor = DMColorBaseMeiRed;
        _slippageView.frame = CGRectMake(0, kSelfHeight - 3, 60, 3);
    }
    
    return _slippageView;
}

- (UIView *)separaterView {
    if (!_separaterView) {
        _separaterView = [UIView new];
        _separaterView.backgroundColor = DMColorWithRGBA(233, 233, 233, 1);
    }
    
    return _separaterView;
}

@end
