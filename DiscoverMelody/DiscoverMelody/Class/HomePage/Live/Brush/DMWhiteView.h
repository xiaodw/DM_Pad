#import <UIKit/UIKit.h>


typedef void (^BlockWhiteBrushWidth)(CGFloat width); // 画笔的width

@interface DMWhiteView : UIView

@property(nonatomic,assign) CGFloat lineWidth;//画笔宽度
@property(nonatomic,strong) UIColor* lineColor;//画笔颜色
@property (copy, nonatomic) BlockWhiteBrushWidth brushWidthBlock;

- (void)brushColorHexString:(NSString *)hexString; // 画笔
- (void)clean; // 清除画板
- (void)undo; // 回退上一步
- (void)eraser; // 橡皮擦
- (void)save; // 保存到相册

@end
