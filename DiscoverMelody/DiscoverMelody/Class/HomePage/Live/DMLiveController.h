#import <UIKit/UIKit.h>
#import "DMBaseMoreController.h"

@interface DMLiveController : DMBaseMoreController

@property (assign, nonatomic) NSInteger totalTime;      // 课程总时长
@property (assign, nonatomic) NSInteger alreadyTime;    // 提前／迟到/ 经过时间(提前为负，迟到为正)
@property (assign, nonatomic) NSInteger warningTime;    // 警告时间
@property (assign, nonatomic) NSInteger delayTime;      // 拖堂时间
@property (strong, nonatomic) NSString *lessonID;       // 当前上课的id
@property (strong, nonatomic) NSMutableArray *presentVCs; // 上层显示的所有controller
@property (assign, nonatomic) BOOL isRemoteUserOnline; // 远端是否上线

@property (weak, nonatomic) UINavigationController *navigationVC;
- (void)quitLiveVideoClickSure; //消息通知需要
@end
