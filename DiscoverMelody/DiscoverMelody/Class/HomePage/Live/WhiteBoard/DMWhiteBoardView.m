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
#define kFlag      @"flag"


@interface DMWhiteBoardView()

@property (strong, nonatomic) NSMutableDictionary *paths; // 画布呈现路径
// 回退的路径, 再次开始画paths内会删除removeKeys, 并且清空
@property (strong, nonatomic) NSMutableArray *removeKeys;
@property (strong, nonatomic) NSMutableArray *sendUUIDs; // 发送的所有包UUID
@property (strong, nonatomic) NSMutableArray *pathPoints; // 当前包的点个数
@property (assign, nonatomic) NSInteger sendIndex; // 发送的path索引

@property (strong, nonatomic) DMLiveVideoManager *liveVideoManager;
@property (strong, nonatomic) dispatch_source_t timer; // n秒中同步画布
@property (assign, nonatomic) NSUInteger secondsNum; // 画布实时时间间隔

@end

@implementation DMWhiteBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _sendIndex = 0;
        // 设置路径的宽度
        self.lineWidth = 5;
        // 设置路径的颜色
        self.hexString = @"ff0000";
        
        WS(weakSelf)
        [self.liveVideoManager onSignalingMessageReceiveWhiteBoard:^(NSString *account, DMSignalingMsgData *responseDataModel) {
            if (responseDataModel.code == DMSignalingWhiteBoardCodeBrush) { // 同步笔触点
                if (weakSelf.removeKeys.count) {
                    [weakSelf.paths removeObjectsForKeys:weakSelf.removeKeys];
                    NSLog(@"a r paths.count:%d", (int)weakSelf.paths.count);
                    weakSelf.removeKeys = nil;
                }
                // 一个包屏蔽多次接收
                if ([weakSelf.sendUUIDs containsObject:responseDataModel.packetUID]) return;
                
                [weakSelf.sendUUIDs addObject:responseDataModel.packetUID];
                DMBezierPath *path = weakSelf.paths[@(responseDataModel.indexID)][kSourceKey];
                if (!path) {
                    path = [weakSelf setupInitBezierPath];
                    path.lineWidth = responseDataModel.lineWidth;
                    path.lineColor = DMColorWithHexString(responseDataModel.colorHex);
                    weakSelf.paths[@(responseDataModel.indexID)] = [@{kSourceKey: path, kFlag:@(1)} mutableCopy];
                }
                CGSize reScreenSize = CGSizeFromString(responseDataModel.size);
                CGFloat reScreenWidth = reScreenSize.width;
                CGFloat reScreenHeight = reScreenSize.height;
                NSArray *points = responseDataModel.data.listPoint;
                for (int i = 0; i < points.count; i++) {
                    NSString *pointStr = points[i];
                    CGPoint point = CGPointFromString(pointStr);
                    CGFloat wScale = point.x / reScreenWidth;
                    CGFloat hScale = point.y / reScreenHeight;
                    CGFloat pointX = weakSelf.dm_width * wScale;
                    CGFloat pointY = weakSelf.dm_height * hScale;
                    point = CGPointMake(pointX, pointY);
                    if (path.empty) { [path moveToPoint:point]; }
                    [path addLineToPoint:point];
                }
                [weakSelf setNeedsDisplay];
                return ;
            }
            
            if (responseDataModel.code == DMSignalingWhiteBoardCodeClean) {
                [weakSelf cleanSignaling];
                return;
            }
            
            if (responseDataModel.code == DMSignalingWhiteBoardCodeUndo) {
                [weakSelf undoSignaling:responseDataModel.indexID];
                return;
            }
            
            if (responseDataModel.code == DMSignalingWhiteBoardCodeForward) {
                [weakSelf forwardSignaling:responseDataModel.indexID];
                return;
            }
        }];
    }
    return self;
}

- (void)cleanSignaling {
    _paths = nil;
    _sendUUIDs = nil;
    _removeKeys = nil;
    _pathPoints = nil;
    _secondsNum = 0;
    //重绘
    [self setNeedsDisplay];
}

// 清除
- (void)clean {
    if (self.paths.count == 0) return;
    [self cleanSignaling];
    [self sendSignalingControlCode:DMSignalingWhiteBoardCodeClean success:^(NSString *messageID) {
        NSLog(@"sendSignalingControlCode: success");
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        NSLog(@"sendSignalingControlCode: faile");
    }];
}

//回退
- (void)undoSignaling:(NSInteger)index{
    NSMutableDictionary *dict = self.paths[@(index)];
    dict[kFlag] = @(0);
    [self.removeKeys addObject:@(index)];
    NSLog(@"re paths.count:%d", (int)self.paths.count);
    
    BOOL isFirst = self.removeKeys.count == self.paths.count;
    [DMNotificationCenter postNotificationName:DMNotificationWhiteBoardUndoStatusKey object:@(isFirst)];
    
    [self setNeedsDisplay];
}

// 回退
- (void)undo {
    if (self.paths.count == 0) return;
    NSInteger lastIndex = [self undoLastPath];
    if(lastIndex == 0) return;
    [self undoSignaling:lastIndex];
    
    [self sendSignalingControlCode:DMSignalingWhiteBoardCodeUndo
                       removeIndex:lastIndex
                           success:^(NSString *messageID) {}
                             faile:^(NSString *messageID, AgoraEcode ecode) {}];
}

- (void)forwardSignaling:(NSInteger)index{
    NSMutableDictionary *dict = self.paths[@(index)];
    dict[kFlag] = @(1);
    [self.removeKeys removeObject:@(index)];
    NSLog(@"f paths.count:%d", (int)self.paths.count);
    
    BOOL isLast = self.removeKeys.count == 0;
    [DMNotificationCenter postNotificationName:DMNotificationWhiteBoardForwardStatusKey object:@(isLast)];
    
    [self setNeedsDisplay];
}

// 前进
- (void)forward {
    if (self.removeKeys.count == 0) return;
    NSInteger firstIndex = [self forwardFirstPath];
    [self forwardSignaling:firstIndex];
    
    [self sendSignalingControlCode:DMSignalingWhiteBoardCodeForward
                       removeIndex:firstIndex
                           success:^(NSString *messageID) {}
                             faile:^(NSString *messageID, AgoraEcode ecode) {}];
}

- (NSInteger)forwardFirstPath {
    NSInteger firstIndex = [self.removeKeys.lastObject integerValue];
    for (NSString *indexKey in self.removeKeys) {
        NSInteger index = indexKey.integerValue;
        if (index < firstIndex ) {
            firstIndex = index;
        }
    }
    return firstIndex;
}

- (NSInteger)undoLastPath {
    NSInteger lastIndex = 0;
    for (NSString *indexKey in self.paths) {
        NSMutableDictionary *dict = self.paths[indexKey];
        if (![dict[kFlag] boolValue]) continue ;
        NSInteger index = indexKey.integerValue;
        if (lastIndex >= index) continue;
        lastIndex = index;
    }
    return lastIndex;
}

// 创建一条路径
- (DMBezierPath *)setupInitBezierPath {
    DMBezierPath *path = [DMBezierPath bezierPath];
    if (_lineWidth > 0) path.lineWidth = _lineWidth;
    if (_hexString.length) path.lineColor = DMColorWithHexString(self.hexString);
    return path;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self timer];
    if (_touchesBeganBlock) _touchesBeganBlock();
    _sendIndex++;
    if (_removeKeys.count) {
        [self.paths removeObjectsForKeys:self.removeKeys];
        NSLog(@"d l aths.count:%d", (int)self.paths.count);
        _removeKeys = nil;
    }
    
    [DMNotificationCenter postNotificationName:DMNotificationWhiteBoardForwardStatusKey object:@(YES)];
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
    self.paths[@(_sendIndex)] = [@{kSourceKey: path, kFlag:@(1)} mutableCopy];

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
        [self sendSignalingControlCode:DMSignalingWhiteBoardCodeBrush success:^(NSString *messageID) {
            NSLog(@"sendSignalingControlCode: success");
        } faile:^(NSString *messageID, AgoraEcode ecode) {
            NSLog(@"sendSignalingControlCode: faile");
        }];
        _pathPoints = nil;
        _secondsNum = 0;
    }

    // 连线的点
    DMBezierPath *path = self.paths[@(_sendIndex)][kSourceKey];
    [path addLineToPoint:point];
    // 重绘
    [self setNeedsDisplay];
}

- (void)sendSignalingControlCode:(DMSignalingWhiteBoardCodeType)code success:(void(^)(NSString *messageID))success faile:(void(^)(NSString *messageID, AgoraEcode ecode))faile {
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:code sourceData:self.pathPoints index:self.sendIndex size:self.dm_size lineWidth:self.lineWidth lineColor:self.hexString synType:DMSignalingMsgSynWhiteBoard];
    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
        NSLog(@"success");
        if (success) success(messageID);
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        NSLog(@"faile ");
        if (faile) faile(messageID, ecode);
    }];
}

- (void)sendSignalingControlCode:(DMSignalingWhiteBoardCodeType)code removeIndex:(NSInteger)index success:(void(^)(NSString *messageID))success faile:(void(^)(NSString *messageID, AgoraEcode ecode))faile {
    NSString *msg = [DMSendSignalingMsg getSignalingStruct:code sourceData:self.pathPoints index:index size:self.dm_size lineWidth:self.lineWidth lineColor:self.hexString synType:DMSignalingMsgSynWhiteBoard];
    [[DMLiveVideoManager shareInstance] sendMessageSynEvent:@"" msg:msg msgID:@"" success:^(NSString *messageID) {
        NSLog(@"success");
        if (success) success(messageID);
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        NSLog(@"faile ");
        if (faile) faile(messageID, ecode);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sendSignalingControlCode:DMSignalingWhiteBoardCodeBrush success:^(NSString *messageID) {
        NSLog(@"sendSignalingControlCode: success");
    } faile:^(NSString *messageID, AgoraEcode ecode) {
        NSLog(@"sendSignalingControlCode: faile");
    }];
    self.pathPoints = nil;
    [self invalidate];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (NSString *index in self.paths) {
        NSDictionary *dict = self.paths[index];
        if (![dict[kFlag] boolValue]) continue;
        DMBezierPath *path = self.paths[index][kSourceKey];
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

- (NSMutableArray *)sendUUIDs {
    if (!_sendUUIDs) {
        _sendUUIDs = [NSMutableArray array];
    }
    
    return _sendUUIDs;
}

- (NSMutableArray *)removeKeys {
    if (!_removeKeys) {
        _removeKeys = [NSMutableArray array];
    }
    
    return _removeKeys;
}

- (NSMutableArray *)pathPoints {
    if (!_pathPoints) {
        _pathPoints = [NSMutableArray array];
    }

    return _pathPoints;
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
        [self sendSignalingControlCode:DMSignalingWhiteBoardCodeBrush success:^(NSString *messageID) {
            NSLog(@"sendSignalingControlCode: success");
        } faile:^(NSString *messageID, AgoraEcode ecode) {
            NSLog(@"sendSignalingControlCode: faile");
        }];
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

- (void)dealloc {
    DMLogFunc
    [self invalidate];
}

@end
