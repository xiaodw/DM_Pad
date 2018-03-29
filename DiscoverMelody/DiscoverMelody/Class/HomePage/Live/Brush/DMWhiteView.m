#import "DMWhiteView.h"
#import "DMBezierPath.h"
#import "DMLiveVideoManager.h"
#import "DMSendSignalingMsg.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "DMSignalingMsgData.h"

#define kMaxPoint 50
#define kMaxSeconds 10

@interface DMWhiteView()
@property(nonatomic,strong) NSMutableArray *paths;//此数组用来管理画板上所有的路径
@property (strong, nonatomic) DMBezierPath *lastPath;
@property (strong, nonatomic) NSMutableArray *pathPoints;
@property (strong, nonatomic) NSMutableArray *totalPathPoints;
@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager;
@property (strong, nonatomic) dispatch_source_t timer; // 1秒中更新一次时间UI
@property (assign, nonatomic) NSInteger secondsNum;

@end

@implementation DMWhiteView

- (void)setLineWidth:(CGFloat)lineWidth {
    [self sendSignalingControlCode:8 sourceData:[@[@(lineWidth)] mutableCopy] success:^{
        _lineWidth = lineWidth;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _secondsNum = 0;
        WS(weakSelf)
        [self.liveVideoManager onSignalingWhiteMessageReceive:^(NSString *account, NSString *msg) {
            if (!STR_IS_NIL(msg)) {
                DMSignalingMsgData *responseDataModel = [DMSignalingMsgData mj_objectWithKeyValues:msg];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (responseDataModel.code == 0) {
                        DMBezierPath *path = _lastPath;
                        BOOL flag = NO;
                        if (!path) {
                            flag = YES;
                            path = [weakSelf setupInitBezierPath];
                            _lastPath = path;
                            [weakSelf.paths addObject:path];
                        }
                        NSArray *points = responseDataModel.sourceData;
                        NSLog(@"一部分包 count: %ld", points.count);
                        for (int i = 0; i < points.count; i++) {
                            NSString *pointStr = points[i];
                            CGPoint point = CGPointFromString(pointStr);
                            if (i == 0 && flag) { [path moveToPoint:point]; }
                            [path addLineToPoint:point];
                        }
                        [weakSelf setNeedsDisplay];
                        return ;
                    }
                    
                    if (responseDataModel.code == 1) {
                        DMBezierPath *path = _lastPath;
                        BOOL flag = NO;
                        if (!path) {
                            flag = YES;
                            path = [weakSelf setupInitBezierPath];
                            _lastPath = path;
                            [weakSelf.paths addObject:path];
                        }
                        NSArray *points = responseDataModel.sourceData;
                        NSLog(@"一部分path其他包 count: %ld", points.count);
                        for (int i = 0; i < points.count; i++) {
                            NSString *pointStr = points[i];
                            CGPoint point = CGPointFromString(pointStr);
                            if (i == 0 && flag) {
                                [path moveToPoint:point];
                            }
                            [path addLineToPoint:point];
                        }
                        [weakSelf setNeedsDisplay];
                        _lastPath = nil;
                        return ;
                    }
                    if (responseDataModel.code == 2) {
                        DMBezierPath *path = [weakSelf setupInitBezierPath];
                        [weakSelf.paths addObject:path];
                        NSArray *points = responseDataModel.sourceData;
                        NSLog(@"一个完整包 count: %ld", points.count);
                        for (int i = 0; i < points.count; i++) {
                            NSString *pointStr = points[i];
                            CGPoint point = CGPointFromString(pointStr);
                            if (i == 0) {
                                [path moveToPoint:point];
                            }
                            [path addLineToPoint:point];
                        }
                        [weakSelf setNeedsDisplay];
                        return ;
                    }
                    if (responseDataModel.code == 3) {
                        // 清除
                        [weakSelf cleanSignalingControl];
                        return ;
                    }
                    if (responseDataModel.code == 4) {
                        // 回退
                        [weakSelf undoSignalingControl];
                        return ;
                    }
                    if (responseDataModel.code == 5) {
                        // 橡皮擦
                        [weakSelf eraserSignalingControl];
                        return ;
                    }
                    if (responseDataModel.code == 6) {
                        // 保存
                        [weakSelf saveSignalingControl];
                        return ;
                    }
                    if (responseDataModel.code == 7) {
                        // 画笔
                        NSArray *colors = responseDataModel.sourceData;
                        NSString *colorString = colors.firstObject;
                        if (OBJ_IS_NIL(colorString)) colorString = @"#FF0000";
                        [weakSelf brushSignalingControlHexString:colorString];
                        return ;
                    }
                    
                    if (responseDataModel.code == 8) {
                        // width
                        NSArray *colors = responseDataModel.sourceData;
                        CGFloat width = [colors.firstObject floatValue];
                        if (width < 1) width = 1;
                        _lineWidth = width;
                        if (weakSelf.brushWidthBlock)  {
                            weakSelf.brushWidthBlock(width);
                        }
                        return ;
                    }
                });
            }
        }];
    }
    return self;
}

- (void)sendSignalingControlCode:(NSInteger)code sourceData:(NSMutableArray *)array success:(void(^)())success {
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:code sourceData:array];
    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
        NSLog(@"success");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success();
        });
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        NSLog(@"faile ");
    }];
}

- (void)sendSignalingControlCode:(NSInteger)code success:(void(^)())success {
    [self sendSignalingControlCode:code sourceData:nil success:success];
}

- (void)brushSignalingControlHexString:(NSString *)hexString {
    _lineColor = [UIColor colorWithHexString:hexString];
}

- (void)brushColorHexString:(NSString *)hexString {
    [self sendSignalingControlCode:7 sourceData:[@[hexString] mutableCopy] success:^{
        [self brushSignalingControlHexString:hexString];
    }];
}

- (void)cleanSignalingControl{
    NSLog(@"%@", [NSThread currentThread]);
    [self.paths removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

//清除
- (void)clean{
    [self sendSignalingControlCode:3 success:^{
        [self cleanSignalingControl];
    }];
}

//回退
- (void)undoSignalingControl{
    [self.paths removeLastObject];
    //重绘
    [self setNeedsDisplay];
}

- (void)undo{
    [self sendSignalingControlCode:4 success:^{
        [self undoSignalingControl];
    }];
}

//橡皮擦
- (void)eraserSignalingControl{
    _lineColor = self.backgroundColor;
}

//橡皮擦
- (void)eraser{
    [self sendSignalingControlCode:5 success:^{
        [self eraserSignalingControl];
    }];
}

//橡皮擦
- (void)saveSignalingControl{
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //截屏
    [self.layer renderInContext:context];
    //获取图片
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//保存
- (void)save{
    [self sendSignalingControlCode:6 success:^{
        [self saveSignalingControl];
    }];
}

//保存图片的回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else{
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

// 创建一条路径
- (DMBezierPath *)setupInitBezierPath {
    DMBezierPath *path = [DMBezierPath bezierPath];
    if (_lineWidth > 0) path.lineWidth = _lineWidth;
    if (_lineColor) path.lineColor = _lineColor;
    return path;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self timer];
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    
    //当手指按下的时候就创建一条路径
    DMBezierPath *path = [self setupInitBezierPath];
    //设置起点
    [path moveToPoint:point];
    [path addLineToPoint:point];
    // 把每一次新创建的路径 添加到数组当中
    [self.paths addObject:path];
    
    NSString *pointString = NSStringFromCGPoint(point);
    [self.pathPoints addObject:pointString];
    [self.totalPathPoints addObject:pointString];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point = [touch locationInView:touch.view];
    
    NSString *pointString = NSStringFromCGPoint(point);
    [self.pathPoints addObject:pointString];
    [self.totalPathPoints addObject:pointString];
    
    if (self.pathPoints.count % kMaxPoint == 0) {
        NSLog(@"发送一个path部分包 count: %ld", self.pathPoints.count);
        [self sendSignalingControlCode:0 sourceData:self.pathPoints success:^{
            NSLog(@"success");
        }];
        _pathPoints = nil;
        _secondsNum = 0;
    }
    
    // 连线的点
    [[self.paths lastObject] addLineToPoint:point];
    // 重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *log = @"发送一个path包";
    NSInteger index = 2;
    if(self.totalPathPoints.count >= kMaxPoint) {
        index = 1;
        log = @"发送一个path最后部分包";
    }
    NSLog(@"%@ count: %ld", log, self.pathPoints.count);
    [self sendSignalingControlCode:index sourceData:self.pathPoints success:^{
        NSLog(@"success");
    }];
    [self.pathPoints removeAllObjects];
    [self.totalPathPoints removeAllObjects];
    [self invalidate];
    
    [self setNeedsDisplay];
}

- (void)invalidate {
    if (!_timer) return;
    dispatch_source_cancel(_timer);
    _timer = nil;
}


/**
- (void)sendSignalingControlCode:(NSInteger)code sourceData:(NSMutableArray *)array success:(void(^)())success {
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:code sourceData:array];
    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
        NSLog(@"success");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) success();
        });
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        NSLog(@"faile ");
    }];
}
 */

- (void)computTime {
    _secondsNum += 1;
    if (_secondsNum >= kMaxSeconds) {
        NSLog(@"发送一个path部分包 count: %ld", self.pathPoints.count);
        [self sendSignalingControlCode:0 sourceData:self.pathPoints success:^{
            NSLog(@"success");
        }];
        _pathPoints = nil;
        _secondsNum = 0;
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (DMBezierPath *path in self.paths) {
        //设置颜色
        [path.lineColor set];
        //渲染
        [path stroke];
    }
}

#pragma mark - Lazy
- (DMLiveVideoManager *)liveVideoManager {
    if (!_liveVideoManager) {
        _liveVideoManager = [DMLiveVideoManager shareInstance];
    }
    
    return _liveVideoManager;
}

-(NSArray *)paths{
    if(!_paths){
        _paths=[NSMutableArray array];
    }
    return _paths;
}

- (NSMutableArray *)pathPoints {
    if (!_pathPoints) {
        _pathPoints = [NSMutableArray array];
    }
    
    return _pathPoints;
}

- (NSMutableArray *)totalPathPoints {
    if (!_totalPathPoints) {
        _totalPathPoints = [NSMutableArray array];
    }
    
    return _totalPathPoints;
}

- (dispatch_source_t)timer {
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
        dispatch_source_set_timer(_timer, start, interval, 0);
        
        // 设置回调
        WS(weakSelf)
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf computTime];
            });
        });
        dispatch_resume(_timer);
    }
    return _timer;
}

@end
