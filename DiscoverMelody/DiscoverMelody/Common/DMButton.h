#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMTitleButtonType) {
    DMTitleButtonTypeTop,
    DMTitleButtonTypeLeft,
    DMTitleButtonTypeBottom,
    DMTitleButtonTypeRight
};

@interface DMButton : UIButton

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) DMTitleButtonType titleAlignment;
@property (nonatomic, assign, getter=isHiddenPanGuesture) BOOL hiddenPanGuesture;

@end


@interface DMNotHighlightedButton : DMButton

@end
