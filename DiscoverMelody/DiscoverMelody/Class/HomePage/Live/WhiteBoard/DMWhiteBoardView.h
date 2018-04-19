#import <UIKit/UIKit.h>

@interface DMWhiteBoardView : UIView

@property(nonatomic,assign) CGFloat lineWidth; // 画笔宽度
@property(nonatomic,copy) NSString* hexString; // 画笔颜色 16进制
- (void)clean; // 清除
- (void)undo; // 回退
- (void)forward; // 前进

@end
