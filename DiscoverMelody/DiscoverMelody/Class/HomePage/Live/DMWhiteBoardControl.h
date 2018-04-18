#import <UIKit/UIKit.h>

@class DMWhiteBoardControl;

@protocol DMWhiteBoardControlDelegate<NSObject>

@optional
- (void)whiteBoardControlDidTapClean:(DMWhiteBoardControl *)whiteBoardControl;
- (void)whiteBoardControlDidTapUndo:(DMWhiteBoardControl *)whiteBoardControl;
- (void)whiteBoardControlDidTapForward:(DMWhiteBoardControl *)whiteBoardControl;
- (void)whiteBoardControl:(DMWhiteBoardControl *)whiteBoardControl didTapBrushButton:(UIButton *)button;
- (void)whiteBoardControl:(DMWhiteBoardControl *)whiteBoardControl didTapColorsButton:(UIButton *)button;
- (void)whiteBoardControlDidTapClose:(DMWhiteBoardControl *)whiteBoardControl;

@end

@interface DMWhiteBoardControl : UIView

@property(nonatomic,assign) CGFloat lineWidth; // 画笔宽度
@property(nonatomic,strong) UIColor* lineColor; // 画笔颜色

@property (weak, nonatomic) id<DMWhiteBoardControlDelegate> delegate;

@end
