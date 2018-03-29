#import "DMBrushViewController.h"
#import "DMWhiteView.h"
#import "DMNavigationBar.h"
#import "DMSlider.h"

@interface DMBrushViewController ()

@property (strong, nonatomic) DMNavigationBar *navigationBar;
@property (strong, nonatomic) DMWhiteView *drawView;
@property (strong, nonatomic) UIView *controlView;
@property (strong, nonatomic) DMSlider *lineWidthSlider;
@property (strong, nonatomic) UIView *colorsView;

@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) NSArray *texts;
@property (strong, nonatomic) UIButton *selectedButton;

@end

@implementation DMBrushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setupMakeAddSubviews];
    [self setupMakeLayoutSubviews];
}

- (UIButton *)setupColorsButton:(NSInteger)index {
    UIButton *button = [UIButton new];
    if (index == 0) {
        self.selectedButton = button;
    }
    button.tag = index;
    NSString *colorString = self.colors[index];
    button.backgroundColor = [UIColor colorWithHexString:colorString];
    [button addTarget:self action:@selector(didTapColor:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didTapColor:(UIButton *)button {
    self.selectedButton = button;
    NSString *colorString = self.colors[button.tag];
    [_drawView brushColorHexString:colorString];
    _drawView.lineColor = [UIColor colorWithHexString:colorString];
}

- (void)didTapLineWidth:(DMSlider *)slider {
    _drawView.lineWidth = slider.value;
}

- (void)didTapAction:(DMSlider *)slider {
    [self didTapLineWidth:slider];
}

- (void)didTapBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapControl:(UIButton *)button {
    if (button.tag == 0) {
        NSString *colorString = self.colors[self.selectedButton.tag];
        [_drawView brushColorHexString:colorString];
        _drawView.lineColor = [UIColor colorWithHexString:colorString];
        return;
    }
    
    if (button.tag == 1) {
        [_drawView clean];
        return;
    }
    
    if (button.tag == 2) {
        [_drawView undo];
        return;
    }
    
    if (button.tag == 3) {
        [_drawView eraser];
        return;
    }
    
    if (button.tag == 4) {
        [_drawView save];
        return;
    }
}

- (void)setupMakeAddSubviews {
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.lineWidthSlider];
    [self.view addSubview:self.colorsView];
}

- (void)setupMakeLayoutSubviews {
    [_navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.height.equalTo(64);
        CGFloat width = DMScreenWidth;
        make.width.equalTo(width);
    }];
    
    [_colorsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    
    [_lineWidthSlider makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(21);
        make.bottom.equalTo(_colorsView.mas_top).offset(-10);
    }];
    
    [_controlView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(30);
        make.bottom.equalTo(_lineWidthSlider.mas_top).offset(-10);
    }];
    [_drawView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(64);
        make.bottom.equalTo(_controlView.mas_top).offset(-10);
    }];
}

- (NSArray *)colors {
    if (!_colors) {
        NSString *redString = @"#FF0000";
        NSString *blueString = @"#0000FF";
        NSString *whiteString = @"#FFFFFF";
        NSString *blackString = @"#000000";
        NSString *grayString = @"#808080";
        NSString *greenString = @"#00FF00";
        NSString *cyanString = @"#00FFFF";
        NSString *yellowString = @"#FFFF00";
        NSString *orangeString = @"#FF8001";
        NSString *purpleString = @"#800080";
        _colors = @[redString, blueString, whiteString, blackString, grayString,
                    greenString, cyanString, yellowString, orangeString, purpleString];
    }
    
    return _colors;
}

- (NSArray *)texts {
    if (!_texts) {
        _texts = @[@"🖌", @"清除", @"回退", @"橡皮擦", @"保存"];
    }
    
    return _texts;
}

- (DMWhiteView *)drawView {
    if (!_drawView) {
        _drawView = [DMWhiteView new];
        _drawView.backgroundColor = [UIColor grayColor];
        //设置画笔颜色
        NSString *colorString = self.colors.firstObject;
        _drawView.lineColor = [UIColor colorWithHexString:colorString];
        WS(weakSelf)
        [_drawView setBrushWidthBlock:^(CGFloat width) {
            weakSelf.lineWidthSlider.value = width;
        }];
    }
    
    return _drawView;
}

- (UIView *)controlView {
    if (!_controlView) {
        _controlView = [UIView new];
        _controlView.backgroundColor = [UIColor whiteColor];
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = DMScreenWidth * 0.2;
        CGFloat height = 30;
        
        for (int i = 0; i < self.texts.count; i++) {
            UIButton *button = [self setupTextsButton:i];
            x = i * width;
            button.backgroundColor = [UIColor grayColor];
            button.frame = CGRectMake(x, y, width-1, height);
            [self.controlView addSubview:button];
        }
    }
    
    return _controlView;
}

- (UIButton *)setupTextsButton:(NSInteger)index {
    UIButton *button = [UIButton new];
    button.tag = index;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:self.texts[index] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTapControl:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UISlider *)lineWidthSlider {
    if (!_lineWidthSlider) {
        _lineWidthSlider = [DMSlider new];
        _lineWidthSlider.minimumValue = 1;
        _lineWidthSlider.maximumValue = 5;
        _lineWidthSlider.value = 3;
        _lineWidthSlider.continuous = YES;
        [_lineWidthSlider addTarget:self action:@selector(didTapLineWidth:) forControlEvents:UIControlEventTouchUpInside];
        [_lineWidthSlider dm_addTarget:self action:@selector(didTapAction:) forControlEvents:DMControlEventTouchUpInside];
    }
    
    return _lineWidthSlider;
}

- (UIView *)colorsView {
    if (!_colorsView) {
        _colorsView = [UIView new];
        _colorsView.backgroundColor = [UIColor whiteColor];
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = DMScreenWidth * 0.1;
        CGFloat height = 30;
        
        for (int i = 0; i < self.colors.count; i++) {
            UIButton *button = [self setupColorsButton:i];
            x = i * width;
            button.frame = CGRectMake(x, y, width, height);
            [self.colorsView addSubview:button];
        }
    }
    
    return _colorsView;
}

- (DMNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [DMNavigationBar new];
        [_navigationBar.leftBarButton addTarget:self action:@selector(didTapBack) forControlEvents:UIControlEventTouchUpInside];
        _navigationBar.titleLabel.text = @"白板绘图";
        _navigationBar.rightBarButton.hidden = YES;
    }
    
    return _navigationBar;
}

@end
