#import "DMWhiteBoardView.h"
#import "DMBezierPath.h"
#import "DMLiveVideoManager.h"
#import "DMSendSignalingMsg.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "DMSignalingMsgData.h"

#define kMaxPoint 50  // 多少个点一个包
#define kMaxSeconds 10 // 画的点不足一个包时, 间隔多少秒发一个包

#define kSourceKey @"source"
#define kIndexKey  @"index"

@interface DMWhiteBoardView()

@property (strong, nonatomic) NSMutableDictionary *paths; // 画布呈现路径
@property (strong, nonatomic) NSMutableArray *pathPoints; // 当前包的点个数
@property (assign, nonatomic) NSInteger sendIndex;

@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager;
@property (strong, nonatomic) dispatch_source_t timer; // n秒中同步画布
@property (assign, nonatomic) NSUInteger secondsNum; // 画布实时时间间隔
@property (strong, nonatomic) NSString *currentIndex; // 当前最后路径的索引值

@end

@implementation DMWhiteBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WS(weakSelf)
        _sendIndex = 0;
        // 设置路径的宽度
        self.lineWidth = 3;
        // 设置路径的颜色
        self.hexString = @"ff0000";
    }
    return self;
}

// 清除
- (void)clean {
    
}

// 回退
- (void)undo {
    
}

// 前进
- (void)forward {
    
}


// 创建一条路径
- (DMBezierPath *)setupInitBezierPath {
    DMBezierPath *path = [DMBezierPath bezierPath];
    if (_lineWidth > 0) path.lineWidth = _lineWidth;
    if (_hexString.length) path.lineColor = DMColorWithHexString(self.hexString);
    return path;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self timer];
    _sendIndex++;
    // 获取触摸对象
    UITouch *touch = [touches anyObject];
    // 获取手指的位置
    CGPoint point = [touch locationInView:touch.view];

    //当手指按下的时候就创建一条路径
    DMBezierPath *path = [self setupInitBezierPath];

    //设置起点
    [path moveToPoint:point];
    [path addLineToPoint:point];

    // 把每一次新创建的路径 添加到数组当中
    self.paths[@(_sendIndex)] = @{kSourceKey: path, kIndexKey: @(self.paths.count+1)};

    NSString *pointString = NSStringFromCGPoint(point);
    [self.pathPoints addObject:pointString];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point = [touch locationInView:touch.view];

    NSString *pointString = NSStringFromCGPoint(point);
    [self.pathPoints addObject:pointString];

    if (self.pathPoints.count % kMaxPoint == 0) {
//        [self sendSignalingControlCode:0 sourceData:self.pathPoints success:nil];
        _pathPoints = nil;
        _secondsNum = 0;
    }

    // 连线的点
    DMBezierPath *path = self.paths[@(_sendIndex)][kSourceKey];
    [path addLineToPoint:point];
    // 重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.pathPoints = nil;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (NSString *uuid in self.paths) {
        DMBezierPath *path = self.paths[uuid][kSourceKey];
        //设置颜色
        [path.lineColor set];
        //渲染
        [path stroke];
    }
}

//#pragma mark - Lazy
//- (DMLiveVideoManager *)liveVideoManager {
//    if (!_liveVideoManager) {
//        _liveVideoManager = [DMLiveVideoManager shareInstance];
//    }
//
//    return _liveVideoManager;
//}

-(NSMutableDictionary *)paths{
    if(!_paths){
        _paths = [NSMutableDictionary dictionary];
    }
    return _paths;
}

- (NSMutableArray *)pathPoints {
    if (!_pathPoints) {
        _pathPoints = [NSMutableArray array];
    }

    return _pathPoints;
}
//
//- (NSMutableArray *)removeUUIDs {
//    if (!_removeUUIDs) {
//        _removeUUIDs = [NSMutableArray array];
//    }
//
//    return _removeUUIDs;
//}

//- (NSMutableArray *)sendUUIDs {
//    if (!_sendUUIDs) {
//        _sendUUIDs = [NSMutableArray array];
//    }
//
//    return _sendUUIDs;
//}

@end
