//
//  DMConfig.h
//  DiscoverMelody
//

//#define appID @"093d35a4b6754c8f9125f04e0209c2c0"
//声网appID
//#define AgoraAppID @"f8101ce899cc4da8807b3eb81bed86e3"

//声网
#define AgoraSAppID [DMConfigManager shareInstance].agoraAppId    //@"2f4301adc17b415c98eba18b7f1066d4"
//#define certificate1 @"62950fd5459c472fbeb14ae42e79b99e"


//登录成功的通知
#define DMNotification_Login_Success_Key @"Login_Success_Key"
//切换到首页的通知
#define DMNotification_HomePage_Key @"DMNotification_HomePage_Key"
//切换到课程列表的通知
#define DMNotification_CourseList_Key @"DMNotification_CourseList_Key"
//切换到客服的通知
#define DMNotification_CustomerService_Key @"DMNotification_CustomerService_Key"

//强制退出登录的通知
#define DMNotification_Must_Logout_Key @"DMNotification_Must_Logout_Key"

#pragma mark -

//上传图片最大界限 比如2M
#define kMaxUploadSize   [DMConfigManager shareInstance].uploadMaxSize
