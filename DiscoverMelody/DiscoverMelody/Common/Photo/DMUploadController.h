#import <UIKit/UIKit.h>

@class DMLiveController, DMUploadController;

@protocol DMUploadControllerDelegate <NSObject>

// 上传成功回调
- (void)uploadController:(DMUploadController *)uploadController successAsset:(NSArray *)assets;

@end

@interface DMUploadController : UIViewController

@property (strong, nonatomic) DMLiveController *liveVC; // 直播控制器, 为了课程结束强制退出所用, 如果停留在当前控制器需要遍历上层显示的所有控制器做一次dismiss, 然后直播控制器退出
@property (strong, nonatomic) NSString *lessonID; // 课程ID
@property (weak, nonatomic) id<DMUploadControllerDelegate> delegate;

@end
