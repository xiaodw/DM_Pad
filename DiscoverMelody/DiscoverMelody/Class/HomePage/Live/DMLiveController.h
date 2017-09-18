#import <UIKit/UIKit.h>
#import "DMBaseMoreController.h"

@interface DMLiveController : DMBaseMoreController

@property (assign, nonatomic) NSInteger totalTime;
@property (assign, nonatomic) NSInteger alreadyTime;
@property (assign, nonatomic) NSInteger warningTime;
@property (assign, nonatomic) NSInteger delayTime;

@property (weak, nonatomic) UINavigationController *navigationVC;

@end
