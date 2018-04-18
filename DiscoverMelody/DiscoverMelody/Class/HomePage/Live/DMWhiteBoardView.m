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
@property (strong, nonatomic) NSMutableArray *removeUUIDs; // 所有被删除的UUID
@property (strong, nonatomic) NSMutableArray *sendUUIDs; // 发送的所有包UUID

@property (strong, nonatomic) NSMutableArray *pathPoints; // 当前包的点个数
@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager;
@property (strong, nonatomic) dispatch_source_t timer; // n秒中同步画布
@property (assign, nonatomic) NSUInteger secondsNum; // 画布同步时间间隔
@property (strong, nonatomic) NSString *currentUUID; // 当前最后路径的索引值

@end

@implementation DMWhiteBoardView

- (void)setLineWidth:(CGFloat)lineWidth {
    [self sendSignalingControlCode:8 sourceData:[@[@(lineWidth)] mutableCopy] success:^{
        _lineWidth = lineWidth;
    }];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WS(weakSelf)
//        [self.liveVideoManager onSignalingWhiteMessageReceive:^(NSString *account, NSString *msg) {
//            if (STR_IS_NIL(msg)) { return ;}
//            DMSignalingMsgData *responseDataModel = [DMSignalingMsgData mj_objectWithKeyValues:msg];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (responseDataModel.code == 0) { // 画笔
//                    if ([self.removeUUIDs containsObject:responseDataModel.uuid]) return;
//                    // 一个包屏蔽多次接收
//                    if ([self.sendUUIDs containsObject:responseDataModel.sendUUID]) return;
//
//                    [self.sendUUIDs addObject:responseDataModel.sendUUID];
//                    DMBezierPath *path = self.paths[responseDataModel.uuid][kSourceKey];
//                    if (!path) {
//                        path = [self setupInitBezierPath];
//                        self.paths[responseDataModel.uuid] = @{kSourceKey: path, kIndexKey: @(self.paths.count+1)};
//                    }
//                    CGSize reScreenSize = CGSizeFromString(responseDataModel.size);
//                    CGFloat reScreenWidth = reScreenSize.width;
//                    CGFloat reScreenHeight = reScreenSize.height;
//                    NSArray *points = responseDataModel.sourceData;
//                    for (int i = 0; i < points.count; i++) {
//                        NSString *pointStr = points[i];
//                        CGPoint point = CGPointFromString(pointStr);
//                        CGFloat wScale = point.x / reScreenWidth;
//                        CGFloat hScale = point.y / reScreenHeight;
//                        CGFloat pointX = DMScreenWidth * wScale;
//                        CGFloat pointY = DMScreenHeight * hScale;
//                        point = CGPointMake(pointX, pointY);
//                        if (i == 0 && path.empty) { [path moveToPoint:point]; }
//                        [path addLineToPoint:point];
//                    }
//                    [weakSelf setNeedsDisplay];
//                    // NSLog(@"response: pointCount: %d , index:%d, lastIndex:%@", (int)points.count, (int)self.paths.count, responseDataModel.uuid);
//                    return ;
//                }
//                if (responseDataModel.code == 3) {
//                    // 清除
//                    [weakSelf cleanSignalingControl];
//                    return ;
//                }
//                if (responseDataModel.code == 4) {
//                    // 回退
//                    //                    NSLog(@"回退: %@", responseDataModel.uuid);
//                    [self.removeUUIDs addObject:responseDataModel.uuid];
//                    [weakSelf undoSignalingControl:responseDataModel.uuid];
//                    return ;
//                }
//                if (responseDataModel.code == 7) {
//                    // 画笔
//                    NSArray *colors = responseDataModel.sourceData;
//                    NSString *colorString = colors.firstObject;
//                    if (OBJ_IS_NIL(colorString)) colorString = @"#FF0000";
//                    [weakSelf brushSignalingControlHexString:colorString];
//                    return ;
//                }
//
//                if (responseDataModel.code == 8) {
//                    // width
//                    NSArray *colors = responseDataModel.sourceData;
//                    CGFloat width = [colors.firstObject floatValue];
//                    if (width < 1) width = 1;
//                    _lineWidth = width;
//                    if (weakSelf.brushWidthBlock)  {
//                        weakSelf.brushWidthBlock(width);
//                    }
//                    return ;
//                }
//            });
//        }];
    }
    return self;
}

- (void)sendSignalingControlCode:(NSInteger)code sourceData:(NSMutableArray *)array success:(void(^)())success {
    //    NSLog(@"send: pointCount: %d , index:%d, lastIndex:%@", (int)array.count, (int)self.paths.count, self.currentUUID);
//    NSString *msg = [DMSendSignalingMsg getSignalingStruct:code sourceData:array sourceIndex:self.paths.count uuid:self.currentUUID];
//    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
//        // NSLog(@"success");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (success) success();
//        });
//    } faile:^(NSString *messageID, AgoraEcode ecode) {
//        // NSLog(@"faile ");
//    }];
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
    self.paths = nil;
    self.removeUUIDs = nil;
    self.sendUUIDs = nil;
    //重绘
    [self setNeedsDisplay];
}

//清除
- (void)clean{
    if (self.paths.count == 0) return;
    [self sendSignalingControlCode:3 sourceData:nil success:^{
        [self cleanSignalingControl];
    }];
}

- (NSString *)getLastUUIDInPaths {
    NSString *lastUUID = @"";
    NSInteger lastIndex = 0;
    for (NSString *uuidKey in self.paths) {
        NSDictionary *dict = self.paths[uuidKey];
        NSInteger index = [dict[kIndexKey] integerValue];
        if (index <= lastIndex) continue;
        lastIndex = index;
        lastUUID = uuidKey;
    }
    self.currentUUID = lastUUID;
    return lastUUID;
}

//回退
- (void)undoSignalingControl:(NSString *)uuid{
    [self.paths removeObjectForKey:uuid];
    [self setNeedsDisplay];
}
//回退
- (void)undo{
    if (self.paths.count == 0) return;
    NSString *lastUUID = [self getLastUUIDInPaths];
    if(lastUUID.length == 0) return;
    [self sendSignalingControlCode:4 success:^{
        [self undoSignalingControl:lastUUID];
    }];
}

- (void)forward {
    
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
    UITouch *touch = [touches anyObject];
    // 获取手指的位置
    CGPoint point = [touch locationInView:touch.view];
    
    //当手指按下的时候就创建一条路径
    DMBezierPath *path = [self setupInitBezierPath];
    
    //设置起点
    [path moveToPoint:point];
    [path addLineToPoint:point];
    
    // 把每一次新创建的路径 添加到数组当中
    self.currentUUID = [NSUUID UUID].UUIDString;
    self.paths[self.currentUUID] = @{kSourceKey: path, kIndexKey: @(self.paths.count+1)};
    
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
        [self sendSignalingControlCode:0 sourceData:self.pathPoints success:nil];
        _pathPoints = nil;
        _secondsNum = 0;
    }
    
    // 连线的点
    DMBezierPath *path = self.paths[self.currentUUID][kSourceKey];
    [path addLineToPoint:point];
    // 重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.pathPoints.count > 0) {
        [self sendSignalingControlCode:0 sourceData:self.pathPoints success:nil];
    }
    
    self.pathPoints = nil;
    [self invalidate];
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

#pragma mark - Lazy
- (DMLiveVideoManager *)liveVideoManager {
    if (!_liveVideoManager) {
        _liveVideoManager = [DMLiveVideoManager shareInstance];
    }
    
    return _liveVideoManager;
}

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

- (NSMutableArray *)removeUUIDs {
    if (!_removeUUIDs) {
        _removeUUIDs = [NSMutableArray array];
    }
    
    return _removeUUIDs;
}

- (NSMutableArray *)sendUUIDs {
    if (!_sendUUIDs) {
        _sendUUIDs = [NSMutableArray array];
    }
    
    return _sendUUIDs;
}

- (void)invalidate {
    if (!_timer) return;
    dispatch_source_cancel(_timer);
    _timer = nil;
    _secondsNum = 0;
}

- (void)computTime {
    _secondsNum += 1;
    if (_secondsNum % kMaxSeconds == 0) {
        if (self.pathPoints.count == 0) return;
        [self sendSignalingControlCode:0 sourceData:self.pathPoints success:nil];
        _pathPoints = nil;
        _secondsNum = 0;
    }
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
