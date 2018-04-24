#import <UIKit/UIKit.h>

@interface DMWhiteBoardView : UIView

typedef void (^BlockTouchesBeganWhiteBoardView)(void); // 画笔的width


@property(nonatomic,assign) CGFloat lineWidth; // 画笔宽度
@property(nonatomic,copy) NSString* hexString; // 画笔颜色 16进制
@property (copy, nonatomic) BlockTouchesBeganWhiteBoardView touchesBeganBlock;

- (void)clean; // 清除
- (void)undo; // 回退
- (void)forward; // 前进

@end
