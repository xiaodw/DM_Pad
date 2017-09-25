//
//  DMBOSClientManager.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/22.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMCloudConfigData.h"
#import <Photos/Photos.h>
typedef void (^BlockUploadSuccess)(BOOL result, DMClassFileDataModel* obj);//上传成功
typedef void (^BlockUploadFailed)(NSError *error);//上传失败

@interface DMBOSClientManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) BlockUploadSuccess blockUploadSuccess;
@property (nonatomic, strong) BlockUploadFailed blockUploadFailed;
/**
 *
 * @param lessonID  课程ID
 * @param type      上传文件的格式化（流或者路径）
 * @param fileData  文件的数据流，type为DMFormatUploadFileType_FileData 有效
 * @param filePath  文件的路径 ，type为DMFormatUploadFileType_FilePath 有效
 * @param fileExt   文件后缀名, 比如 @".jpg"    @".png"
 */
- (void)startUploadFileToBD:(NSString *)lessonID
                 formatType:(DMFormatUploadFileType)type
                   fileData:(NSData *)fileData
                   filePath:(NSString *)filePath
                    fileExt:(NSString *)fileExt
                      angle:(UIImageOrientation)tation;
@end
