#import <UIKit/UIKit.h>

@class DMLiveController, DMUploadController;

@protocol DMUploadControllerDelegate <NSObject>

- (void)uploadController:(DMUploadController *)uploadController successAsset:(NSArray *)assets;

@end

@interface DMUploadController : UIViewController

@property (strong, nonatomic) DMLiveController *liveVC;
@property (strong, nonatomic) NSString *lessonID;

@property (weak, nonatomic) id<DMUploadControllerDelegate> delegate;

@end
