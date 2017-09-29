//
//  DMConst.m
//  DiscoverMelody
//

#import "DMConst.h"

#pragma NSString - 文案信息

#if LANGUAGE_ENVIRONMENT == 0 //中文

/////////////////////////////////////////////////////////////////////////// 通用
//权限
NSString * const Capture_Msg = @"“寻律”需要访问您的摄像头";
NSString * const Audio_Msg = @"“寻律”需要访问您的麦克风";
NSString * const Photo_Msg = @"“寻律”需要访问您的相册";
//弹窗选项 权限
NSString * const DMTitleDonAllow = @"不允许";
NSString * const DMTitleAllow = @"允许";
NSString * const DMTitleGoSetting = @"去设置";
//弹窗选项 是否 比如是否重传
NSString * const DMTitleYes = @"是";
NSString * const DMTitleNO = @"否";
//弹窗选项 确定/取消
NSString * const DMTitleOK = @"确定";
NSString * const DMTitleCancel = @"取消";
//弹窗选项 建议升级、强制升级
NSString * const DMTitleUpgrade = @"升级";
NSString * const DMTitleMustUpgrade = @"立即升级";
//网络/错误
NSString * const DMTitleNetworkError = @"网络连接错误";
NSString * const DMTitleNoTypeError = @"未知错误";
NSString * const DMTextDataLoaddingError = @"数据加载失败";
NSString * const DMTitleRefresh = @"刷新";
//通用术语
NSString * const DMStringIDStudent = @"学生";
NSString * const DMStringIDTeacher = @"老师";
//通用术语 课程状态
NSString * const DMKeyStatusNotStart = @"尚未开始";
NSString * const DMKeyStatusInclass = @"上课中...";
NSString * const DMKeyStatusClassEnd = @"课程结束";
NSString * const DMKeyStatusClassCancel = @"本课取消";

/////////////////////////////////////////////////////////////////////////// 侧边栏
NSString * const DMTitleHome = @"首页";
NSString * const DMTitleCourseList = @"课程列表";
NSString * const DMTitleContactCustomerService = @"联系客服";
NSString * const DMTitleExitLogin = @"退出登录";
NSString * const Logout_Msg = @"确定退出登录吗？";    //退出登录的二次确认

/////////////////////////////////////////////////////////////////////////// 登陆页
NSString * const DMTextPlaceholderAccount = @"请输入用户名";
NSString * const DMTextPlaceholderPassword = @"请输入密码";
NSString * const DMTitleLogin = @"登录";
NSString * const DMTextLoginDescribe = @"本应用目前只提供给已购课的用户体验，未购课的用户请访问 %@ 了解更多信息";

/////////////////////////////////////////////////////////////////////////// 首页
NSString * const DMTextThisClassFile = @"本课文件";
NSString * const DMTextJoinClass = @"进入课堂";
NSString * const DMTextStartClassTime = @"上课时间：";
NSString * const DMClassStartTimeYMDHM = @"MM月dd日 HH:mm";
NSString * const DMTextRecentNotClass = @"您暂时还没有课程哦";

/////////////////////////////////////////////////////////////////////////// 视频上课页
NSString * const DMTextLiveStartTimeInterval = @"距离上课还有%zd分钟";
NSString * const DMTextLiveStudentNotEnter = @"学生尚未进入课堂";
NSString * const DMTextLiveTeacherNotEnter = @"老师尚未进入课堂";
NSString * const DMTextLiveDelayTime = @"本课将于%zd分钟后自动关闭";
//关闭视频 主副标题
NSString * const DMTitleExitLiveRoom = @"确定要退出课程吗?";
NSString * const DMTitleLiveAutoClose = @"确定后视频将自动关闭, 并结束课程";

NSString * const DMAlertTitleCameraNotOpen = @"您的摄像头未开启"; //作废文案，不会出现

/////////////////////////////////////////////////////////////////////////// 课件
NSString * const DMTextNotCourse = @"暂无课件";
//课件浮层 tab
NSString * const DMTitleMyUploadFild = @"我上传的文件";
NSString * const DMTitleStudentUploadFild = @"学生上传的文件";
NSString * const DMTitleTeacherUploadFild = @"老师上传的文件";
//icon按钮
NSString * const DMTitleSelected = @"选择";
NSString * const DMTitleUpload = @"上传";
NSString * const DMTitleDeleted = @"删除";
NSString * const DMTitleSync = @"同步";
//课件 同步
NSString * const DMAlertTitleNotSync = @"学生未上线, 不能同步操作";
NSString * const DMTitleImmediatelySync = @"立即同步";
NSString * const DMTitleCloseSync = @"您确定要结束同步吗?";
NSString * const DMTitleCloseSyncMessage = @"";
//课件 删除确认 主副标题
NSString * const DMTitleDeletedPhotos = @"确定要删除课件吗?";
NSString * const DMTitleDeletedPhotosMessage = @"";
NSString * const DMTitleDeletedPhoto = @"确定要删除课件吗?";
NSString * const DMTitleDeletedPhotoMessage = @"";
//课件 上传重传 主副标题
NSString * const DMTitleUploadFail = @"有图片上传失败, 是否重新上传";
NSString * const DMTitleUploadFailMessage = @"";

//课件 本地相册
NSString * const DMTitleAllPhotos = @"相册";
NSString * const DMTitlePhoto = @"相册";
//课件 上传
NSString * const DMTitleUploadCount = @"一次最多选择%d张图片";
NSString * const DMTitlePhotoUpload = @"确定上传";
NSString * const DMTitlePhotoUploadCount = @"确定上传(%zd)";

/////////////////////////////////////////////////////////////////////////// 课程列表页
NSString * const DMTextNotClass = @"暂无课程";
//课程筛选
NSString * const DMTitleAllCourse = @"全部课程";
NSString * const DMTitleAlreadyCourse = @"已上课程";
NSString * const DMTitleNotStartCourse = @"未上课程";
//列表项
NSString * const DMTextClassNumber = @"课程编号";
NSString * const DMTextClassName = @"课程名称";
NSString * const DMTextStudentName = @"学生姓名";
NSString * const DMTextTeacherName = @"老师姓名";
NSString * const DMTextDate = @"日期";
NSString * const DMTextDetailDate = @"时间";
NSString * const DMTextPeriod = @"课时";
NSString * const DMTextStauts = @"状态";
NSString * const DMTextFiles = @"课程文件";
NSString * const DMTextQuestionnaire = @"课后小结";
NSString * const DMTextMinutes = @"分钟";
NSString * const DMTitleClassRelook = @"回顾";

/////////////////////////////////////////////////////////////////////////// 问卷总结

NSString * const DMDateFormatterYMD = @"YYYY年MM月dd日";

NSString * const DMTitleStudentQuestionFild = @"我的小结";
NSString * const DMTitleTeacherQuestionFild = @"老师小结";

NSString * const DMTextPlaceholderMustFill = @"请填写";
NSString * const DMTitleSubmit = @"提交";
NSString * const DMQuestCommitStatusSuccess = @"提交成功";
NSString * const DMQuestCommitStatusFailed = @"提交失败";
NSString * const DMTitleNoTeacherQuestionComFild = @"老师暂未填写问卷";
//老师问卷状态
NSString * const DMTitleTeacherQuestionReviewFild = @"  正在审核中...";
NSString * const DMTitleTeacherQuestionFailedFild = @"  审核未通过，请修改后重新提交";
NSString * const DMTitleTeacherQuestionSuccessFild = @"  审核通过";


/////////////////////////////////////////////////////////////////////////// 客服页
NSString * const DMStringWeChatNumber = @"微信号：%@";
NSString * const DMTextCustomerServiceDescribe = @"如需修改上课时间，了解更多详情，请联系以上任意客服";

/////////////////////////////////////////////////////////////////////////// 点播
NSString * const DMAlertTitleVedioNotExist = @"视频资源不存在";
NSString * const DMTitleVedioRetry = @"视频加载失败，点击重试";

/////////////////////////////////////////////////////////////////////////// 下拉、上拉
NSString * const DMRefreshHeaderIdleText = @"下拉可以刷新";
NSString * const DMRefreshHeaderPullingText = @"松开立即刷新";
NSString * const DMRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString * const DMRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString * const DMRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString * const DMRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString * const DMRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString * const DMRefreshBackFooterPullingText = @"松开立即加载更多";
NSString * const DMRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString * const DMRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";

NSString * const DMRefreshHeaderLastTimeText = @"最后更新：";
NSString * const DMRefreshHeaderDateTodayText = @"今天";
NSString * const DMRefreshHeaderNoneLastDateText = @"无记录";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#elif LANGUAGE_ENVIRONMENT == 1 //英文
/////////////////////////////////////////////////////////////////////////// 通用
//权限
NSString * const Capture_Msg = @"Discover Melody will need to access your camera.";
NSString * const Audio_Msg = @"Discover Melody will need to access your microphone.";
NSString * const Photo_Msg = @"Discover Melody would like to access your photos";
//弹窗选项 权限
NSString * const DMTitleDonAllow = @"Don’t Allow";
NSString * const DMTitleAllow = @"OK";
NSString * const DMTitleGoSetting = @"去设置";
//弹窗选项 是否 比如是否重传
NSString * const DMTitleYes = @"Yes";
NSString * const DMTitleNO = @"No";
//弹窗选项 确定/取消
NSString * const DMTitleOK = @"Confirm";
NSString * const DMTitleCancel = @"Cancel";
//弹窗选项 建议升级、强制升级
NSString * const DMTitleUpgrade = @"升级";
NSString * const DMTitleMustUpgrade = @"立即升级";
//网络/错误
NSString * const DMTitleNetworkError = @"网络连接错误";
NSString * const DMTitleNoTypeError = @"未知错误";
NSString * const DMTextDataLoaddingError = @"数据加载失败";
NSString * const DMTitleRefresh = @"REFRESH";
//通用术语
NSString * const DMStringIDStudent = @"Student";
NSString * const DMStringIDTeacher = @"Teacher";
//通用术语 课程状态
NSString * const DMKeyStatusNotStart = @"Not Started";
NSString * const DMKeyStatusInclass = @"In Progress";
NSString * const DMKeyStatusClassEnd = @"Completed";
NSString * const DMKeyStatusClassCancel = @"Cancelled";

/////////////////////////////////////////////////////////////////////////// 侧边栏
NSString * const DMTitleHome = @"Home Page";
NSString * const DMTitleCourseList = @"Course List";
NSString * const DMTitleContactCustomerService = @"Contact Us";
NSString * const DMTitleExitLogin = @"Log Out";
NSString * const Logout_Msg = @"Are you sure you want to log out?";	//退出登录的二次确认

/////////////////////////////////////////////////////////////////////////// 登陆页
NSString * const DMTextPlaceholderAccount = @"Username";
NSString * const DMTextPlaceholderPassword = @"Password";
NSString * const DMTitleLogin = @"LOGIN";
NSString * const DMTextLoginDescribe = @"This BETA version is for registered student only. For more information, please visit www.discovermelody.com";

/////////////////////////////////////////////////////////////////////////// 首页
NSString * const DMTextThisClassFile = @"Session Document";
NSString * const DMTextJoinClass = @"Start Session";
NSString * const DMTextStartClassTime = @"Session Time: ";
NSString * const DMClassStartTimeYMDHM = @"MM/dd HH:mm";
NSString * const DMTextRecentNotClass = @"您暂时还没有课程哦";

/////////////////////////////////////////////////////////////////////////// 视频上课页
NSString * const DMTextLiveStartTimeInterval = @"Your session will start in %zd minutes";
NSString * const DMTextLiveStudentNotEnter = @"The student hasn’t entered the session";
NSString * const DMTextLiveTeacherNotEnter = @"The teacher hasn’t entered the session";
NSString * const DMTextLiveDelayTime = @"You session will be disconnected in %zd minutes";
//关闭视频 主副标题
NSString * const DMTitleExitLiveRoom = @"Are you sure you want to end the session?";
NSString * const DMTitleLiveAutoClose = @"After confirmation, your session will be disconnected";

NSString * const DMAlertTitleCameraNotOpen = @"您的摄像头未开启"; //作废文案，不会出现

/////////////////////////////////////////////////////////////////////////// 课件
NSString * const DMTextNotCourse = @"No document at this time";
//课件浮层 tab
NSString * const DMTitleMyUploadFild = @"My Uploads";
NSString * const DMTitleStudentUploadFild = @"Student's Uploads";
NSString * const DMTitleTeacherUploadFild = @"Teacher's Uploads";
//icon按钮
NSString * const DMTitleSelected = @"Select";
NSString * const DMTitleUpload = @"Upload";
NSString * const DMTitleDeleted = @"Delete";
NSString * const DMTitleSync = @"Synchronize";
//课件 同步
NSString * const DMAlertTitleNotSync = @"学生未上线, 不能同步操作";
NSString * const DMTitleImmediatelySync = @"Synchronize Now";
NSString * const DMTitleCloseSync = @"Are you sure you want to end the synchronize?";
NSString * const DMTitleCloseSyncMessage = @"";
//课件 删除确认 主副标题
NSString * const DMTitleDeletedPhotos = @"Are you sure you want to delete the document?";
NSString * const DMTitleDeletedPhotosMessage = @"";
NSString * const DMTitleDeletedPhoto = @"Are you sure you want to delete the document?";
NSString * const DMTitleDeletedPhotoMessage = @"";
//课件 上传重传 主副标题
NSString * const DMTitleUploadFail = @"有图片上传失败, 是否重新上传";
NSString * const DMTitleUploadFailMessage = @"";

//课件 本地相册
NSString * const DMTitleAllPhotos = @"Albums";
NSString * const DMTitlePhoto = @"Albums";
//课件 上传
NSString * const DMTitleUploadCount = @"一次最多选择%d张图片";
NSString * const DMTitlePhotoUpload = @"Upload Now";
NSString * const DMTitlePhotoUploadCount = @"Upload Now(%zd)";

/////////////////////////////////////////////////////////////////////////// 课程列表页
NSString * const DMTextNotClass = @"No sessions at this time";
//课程筛选
NSString * const DMTitleAllCourse = @"All Sessions";
NSString * const DMTitleAlreadyCourse = @"Previous Sessions";
NSString * const DMTitleNotStartCourse = @"Future Sessions";
//列表项
NSString * const DMTextClassNumber = @"Number";
NSString * const DMTextClassName = @"Session";
NSString * const DMTextStudentName = @"Student";
NSString * const DMTextTeacherName = @"Teacher";
NSString * const DMTextDate = @"Date";
NSString * const DMTextDetailDate = @"Time";
NSString * const DMTextPeriod = @"Length";
NSString * const DMTextStauts = @"Status";
NSString * const DMTextFiles = @"Document";
NSString * const DMTextQuestionnaire = @"Survey";
NSString * const DMTextMinutes = @" mins";
NSString * const DMTitleClassRelook = @"Review";

/////////////////////////////////////////////////////////////////////////// 问卷总结

NSString * const DMDateFormatterYMD = @"MM/dd/YYYY";

NSString * const DMTitleStudentQuestionFild = @"My Survey";
NSString * const DMTitleTeacherQuestionFild = @"Teacher's Survey";

NSString * const DMTextPlaceholderMustFill = @"请填写";
NSString * const DMTitleSubmit = @"Submit";
NSString * const DMQuestCommitStatusSuccess = @"提交成功";
NSString * const DMQuestCommitStatusFailed = @"提交失败";
NSString * const DMTitleNoTeacherQuestionComFild = @"老师暂未填写问卷";
//老师问卷状态
NSString * const DMTitleTeacherQuestionReviewFild = @"  正在审核中...";
NSString * const DMTitleTeacherQuestionFailedFild = @"  审核未通过，请修改后重新提交";
NSString * const DMTitleTeacherQuestionSuccessFild = @"  审核通过";


/////////////////////////////////////////////////////////////////////////// 客服页
NSString * const DMStringWeChatNumber = @"WeChat: %@";
NSString * const DMTextCustomerServiceDescribe = @"Contact our customer service team for any support";

/////////////////////////////////////////////////////////////////////////// 点播
NSString * const DMAlertTitleVedioNotExist = @"视频资源不存在";
NSString * const DMTitleVedioRetry = @"视频加载失败，点击重试";


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 后加
NSString * const DMRefreshHeaderIdleText = @"下拉可以刷新";
NSString * const DMRefreshHeaderPullingText = @"松开立即刷新";
NSString * const DMRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString * const DMRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString * const DMRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString * const DMRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString * const DMRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString * const DMRefreshBackFooterPullingText = @"松开立即加载更多";
NSString * const DMRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString * const DMRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";

NSString * const DMRefreshHeaderLastTimeText = @"最后更新：";
NSString * const DMRefreshHeaderDateTodayText = @"今天";
NSString * const DMRefreshHeaderNoneLastDateText = @"无记录";

#endif
