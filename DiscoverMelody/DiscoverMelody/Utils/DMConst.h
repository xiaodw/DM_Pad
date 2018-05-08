//
//  DMConst.h
//  DiscoverMelody
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const Capture_Msg;
UIKIT_EXTERN NSString * const Audio_Msg;
UIKIT_EXTERN NSString * const Photo_Msg;
//弹窗选项 权限
UIKIT_EXTERN NSString * const DMTitleDonAllow;
UIKIT_EXTERN NSString * const DMTitleAllow;
UIKIT_EXTERN NSString * const DMTitleGoSetting;
//弹窗选项 是否 比如是否重传
UIKIT_EXTERN NSString * const DMTitleYes;
UIKIT_EXTERN NSString * const DMTitleNO;
//弹窗选项 确定/取消
UIKIT_EXTERN NSString * const DMTitleOK;
UIKIT_EXTERN NSString * const DMTitleCancel;
//弹窗选项 建议升级、强制升级
UIKIT_EXTERN NSString * const DMTitleUpgrade;
UIKIT_EXTERN NSString * const DMTitleMustUpgrade;
//网络/错误
UIKIT_EXTERN NSString * const DMTitleNetworkError;
UIKIT_EXTERN NSString * const DMTitleNoTypeError;
UIKIT_EXTERN NSString * const DMTextDataLoaddingError;
UIKIT_EXTERN NSString * const DMTitleRefresh;
//通用术语
UIKIT_EXTERN NSString * const DMStringIDStudent;
UIKIT_EXTERN NSString * const DMStringIDTeacher;
//通用术语 课程状态
UIKIT_EXTERN NSString * const DMKeyStatusNotStart;
UIKIT_EXTERN NSString * const DMKeyStatusInclass;
UIKIT_EXTERN NSString * const DMKeyStatusClassEnd;
UIKIT_EXTERN NSString * const DMKeyStatusClassCancel;
UIKIT_EXTERN NSString * const DMKeyStatusClassProcessing;

/////////////////////////////////////////////////////////////////////////// 侧边栏
UIKIT_EXTERN NSString * const DMTitleHome;
UIKIT_EXTERN NSString * const DMTitleCourseList;
UIKIT_EXTERN NSString * const DMTitleContactCustomerService;
UIKIT_EXTERN NSString * const DMTitleExitLogin;
UIKIT_EXTERN NSString * const Logout_Msg; //退出登录的二次确认

/////////////////////////////////////////////////////////////////////////// 登陆页
UIKIT_EXTERN NSString * const DMTextPlaceholderAccount;
UIKIT_EXTERN NSString * const DMTextPlaceholderPassword;
UIKIT_EXTERN NSString * const DMTitleLogin;
UIKIT_EXTERN NSString * const DMTextLoginDescribe;

/////////////////////////////////////////////////////////////////////////// 首页
UIKIT_EXTERN NSString * const DMTextThisClassFile;
UIKIT_EXTERN NSString * const DMTextJoinClass;
UIKIT_EXTERN NSString * const DMTextStartClassTime;
UIKIT_EXTERN NSString * const DMClassStartTimeYMDHM;
UIKIT_EXTERN NSString * const DMTextRecentNotClass;

/////////////////////////////////////////////////////////////////////////// 视频上课页
UIKIT_EXTERN NSString * const DMTextLiveRecording;
UIKIT_EXTERN NSString * const DMTextLiveStartTimeInterval;
UIKIT_EXTERN NSString * const DMTextLiveStudentNotEnter;
UIKIT_EXTERN NSString * const DMTextLiveTeacherNotEnter;
UIKIT_EXTERN NSString * const DMTextLiveDelayTime;
//关闭视频 主副标题
UIKIT_EXTERN NSString * const DMTitleExitLiveRoom;
UIKIT_EXTERN NSString * const DMTitleLiveAutoClose;

UIKIT_EXTERN NSString * const DMAlertTitleCameraNotOpen; //作废文案，不会出现

/////////////////////////////////////////////////////////////////////////// 课件
UIKIT_EXTERN NSString * const DMTextNotCourse;
//课件浮层 tab
UIKIT_EXTERN NSString * const DMTitleMyUploadFild;
UIKIT_EXTERN NSString * const DMTitleStudentUploadFild;
UIKIT_EXTERN NSString * const DMTitleTeacherUploadFild;
//icon按钮
UIKIT_EXTERN NSString * const DMTitleSelected;
UIKIT_EXTERN NSString * const DMTitleUpload;
UIKIT_EXTERN NSString * const DMTitleDeleted;
UIKIT_EXTERN NSString * const DMTitleSync;
UIKIT_EXTERN NSString * const DMTitleClean;
UIKIT_EXTERN NSString * const DMTitleWhiteBoard;
UIKIT_EXTERN NSString * const DMTitleClose;
//课件 同步
UIKIT_EXTERN NSString * const DMTitleImmediatelySync;
UIKIT_EXTERN NSString * const DMTitleCloseSync;
UIKIT_EXTERN NSString * const DMTitleCloseSyncMessage;
UIKIT_EXTERN NSString * const DMAlertTitleNotSync;
//课件 删除确认 主副标题
UIKIT_EXTERN NSString * const DMTitleDeletedPhotos;
UIKIT_EXTERN NSString * const DMTitleDeletedPhotosMessage;
UIKIT_EXTERN NSString * const DMTitleDeletedPhoto;
UIKIT_EXTERN NSString * const DMTitleDeletedPhotoMessage;
//课件 上传重传 主副标题
UIKIT_EXTERN NSString * const DMTitleUploadFail;
UIKIT_EXTERN NSString * const DMTitleUploadFailMessage;

//课件 本地相册
UIKIT_EXTERN NSString * const DMTitleAllPhotos;
UIKIT_EXTERN NSString * const DMTitlePhoto;
//课件 上传
UIKIT_EXTERN NSString * const DMTitleUploadCount;
UIKIT_EXTERN NSString * const DMTitlePhotoUpload;
UIKIT_EXTERN NSString * const DMTitlePhotoUploadCount;

/////////////////////////////////////////////////////////////////////////// 课程列表页
UIKIT_EXTERN NSString * const DMTextNotClass;
//课程筛选
UIKIT_EXTERN NSString * const DMTitleAllCourse;
UIKIT_EXTERN NSString * const DMTitleAlreadyCourse;
UIKIT_EXTERN NSString * const DMTitleNotStartCourse;
//列表项
UIKIT_EXTERN NSString * const DMTextClassNumber;
UIKIT_EXTERN NSString * const DMTextClassName;
UIKIT_EXTERN NSString * const DMTextStudentName;
UIKIT_EXTERN NSString * const DMTextTeacherName;
UIKIT_EXTERN NSString * const DMTextDate;
UIKIT_EXTERN NSString * const DMTextDetailDate;
UIKIT_EXTERN NSString * const DMTextPeriod;
UIKIT_EXTERN NSString * const DMTextStauts;
UIKIT_EXTERN NSString * const DMTextFiles;
UIKIT_EXTERN NSString * const DMTextQuestionnaire;
UIKIT_EXTERN NSString * const DMTextMinutes;
UIKIT_EXTERN NSString * const DMTitleClassRelook;

/////////////////////////////////////////////////////////////////////////// 问卷总结
UIKIT_EXTERN NSString * const DMDateFormatterYMD;
UIKIT_EXTERN NSString * const DMTitleStudentQuestionFild;
UIKIT_EXTERN NSString * const DMTitleTeacherQuestionFild;

UIKIT_EXTERN NSString * const DMTextPlaceholderMustFill;
UIKIT_EXTERN NSString * const DMTitleSubmit;
//UIKIT_EXTERN NSString * const DMQuestCommitStatusSuccess;
//UIKIT_EXTERN NSString * const DMQuestCommitStatusFailed;
UIKIT_EXTERN NSString * const DMTitleNoTeacherQuestionComFild;
//老师问卷状态
UIKIT_EXTERN NSString * const DMTitleTeacherQuestionReviewFild;
UIKIT_EXTERN NSString * const DMTitleTeacherQuestionFailedFild;
UIKIT_EXTERN NSString * const DMTitleTeacherQuestionSuccessFild;


/////////////////////////////////////////////////////////////////////////// 客服页
UIKIT_EXTERN NSString * const DMStringWeChatNumber;
UIKIT_EXTERN NSString * const DMTextCustomerServiceDescribe;

/////////////////////////////////////////////////////////////////////////// 点播
UIKIT_EXTERN NSString * const DMAlertTitleVedioNotExist;
UIKIT_EXTERN NSString * const DMTitleVedioRetry;

/////////////////////////////////////////////////////////////////////////// 下拉、上拉
UIKIT_EXTERN NSString * const DMRefreshHeaderIdleText;
UIKIT_EXTERN NSString * const DMRefreshHeaderPullingText;
UIKIT_EXTERN NSString * const DMRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString * const DMRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString * const DMRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString * const DMRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString * const DMRefreshBackFooterIdleText;
UIKIT_EXTERN NSString * const DMRefreshBackFooterPullingText;
UIKIT_EXTERN NSString * const DMRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString * const DMRefreshBackFooterNoMoreDataText;

UIKIT_EXTERN NSString * const DMRefreshHeaderLastTimeText;
UIKIT_EXTERN NSString * const DMRefreshHeaderDateTodayText;
UIKIT_EXTERN NSString * const DMRefreshHeaderNoneLastDateText;

