#import <UIKit/UIKit.h>


typedef void (^BlockWhiteBrushWidth)(CGFloat width); // 画笔的width

@interface DMWhiteBoardView : UIView

@property(nonatomic,assign) CGFloat lineWidth; // 画笔宽度
@property(nonatomic,strong) UIColor* lineColor; // 画笔颜色
@property (copy, nonatomic) BlockWhiteBrushWidth brushWidthBlock;

- (void)brushColorHexString:(NSString *)hexString; // 画笔
- (void)clean; // 清除
- (void)undo; // 回退
- (void)forward; // 前进

@end
