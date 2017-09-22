//
//  DMBOSClientManager.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/22.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMBOSClientManager.h"
#import <BaiduBCEBOS/BaiduBCEBOS.h>
#import <BaiduBCESTS/BaiduBCESTS.h>
#import <BaiduBCEBasic/BaiduBCEBasic.h>

@interface DMBOSClientManager ()
@property (nonatomic, strong) BOSClient *client;

@property (nonatomic, strong) NSString *lessonID;
@property (nonatomic, strong) DMCloudConfigData *cloudObj;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) DMFormatUploadFileType formatType;
@property (nonatomic, strong) NSString *fileExt;

@end

static DMBOSClientManager *bosinstance = nil;

@implementation DMBOSClientManager

- (void)initBOSClient {
    BCESTSCredentials* credentials = [[BCESTSCredentials alloc] init];
    credentials.accessKey = self.cloudObj.access_key;//@"<access key>"; // 临时返回的AK
    credentials.secretKey = self.cloudObj.secret_key;//@"<secret key>"; // 临时返回的SK
    credentials.sessionToken = self.cloudObj.session_token;//@"<session token>"; // 临时返回的SessionToken
    
    BOSClientConfiguration* configuration = [[BOSClientConfiguration alloc] init];
    configuration.credentials = credentials;
    //configuration.scheme = @"https";
    
    self.client = [[BOSClient alloc] initWithConfiguration:configuration];
    //[self createBucket];
}

- (void)putObjectRequest {
    WS(weakSelf);
    BOSObjectContent* content = [[BOSObjectContent alloc] init];
    // 以下两行设置一种。
    if (self.formatType == DMFormatUploadFileType_FilePath) {
        content.objectData.file = self.filePath;//@"<FilePath>";
    } else {
        content.objectData.data = self.fileData;//@"<NSData object>";
    }
    
    BOSPutObjectRequest* request = [[BOSPutObjectRequest alloc] init];
    request.bucket = self.cloudObj.bucketname;//@"<bucketname>";
    request.key = [self.cloudObj.objectname stringByAppendingString:self.fileExt];//@"<ObjectName>";
    request.objectContent = content;
    
    __block BOSPutObjectResponse* response;
    BCETask* task = [_client putObject:request];
    task.then(^(BCEOutput* output) {
        if (output.progress) {
            // 打印进度
//            NSLog(@"put object progress is %@", output.progress);
        }
        
        if (output.response) {
            response = (BOSPutObjectResponse*)output.response;
            // 打印eTag
//            NSLog(@"The metadata is %@", response.metadata);
//            NSLog(@"The eTag is %@", response.metadata.eTag);
            [weakSelf uploadSuccess];
        }
        
        if (output.error) {
//            NSLog(@"put object failure with %@", output.error);
            if (weakSelf.blockUploadFailed) {
                weakSelf.blockUploadFailed(nil);
            }
            
        }
    });
}

- (void)uploadObjectToBD {
    [self initBOSClient];
    [self putObjectRequest];
}

- (void)startUploadFileToBD:(NSString *)lessonID
                 formatType:(DMFormatUploadFileType)type
                   fileData:(NSData *)fileData
                   filePath:(NSString *)filePath
                    fileExt:(NSString *)fileExt
{
    self.lessonID = lessonID;
    self.formatType = type;
    self.filePath = filePath;
    self.fileData = fileData;
    self.fileExt = fileExt;
    
    [self getCloudConfig];
}

- (void)getCloudConfig {
    WS(weakSelf);
    [DMApiModel getUploadConfigInfo:self.lessonID block:^(BOOL result, DMCloudConfigData *obj) {
        weakSelf.cloudObj = obj;
        [weakSelf uploadObjectToBD];
    }];
}

- (void)uploadSuccess {
    WS(weakSelf);
    [DMApiModel getUploadSuccess:self.lessonID
                      attachment:self.cloudObj.ID
                         fileExt:self.fileExt
                           block:^(BOOL result, DMClassFileDataModel *obj) {
                               if (result) {
                                   if (weakSelf.blockUploadSuccess) {
                                       weakSelf.blockUploadSuccess(result, obj);
                                   }
                               } else {
                                   if (weakSelf.blockUploadFailed) {
                                       weakSelf.blockUploadFailed(nil);
                                   }
                               }
                           }];
}


- (void)shutdownClient {
    //[_client shutdown];
}

-(void)bdUploadSuccess:(BlockUploadSuccess)blockUploadSuccess {
    self.blockUploadSuccess = blockUploadSuccess;
}

-(void)bdUploadFailed:(BlockUploadFailed)blockUploadFailed {
    self.blockUploadFailed = blockUploadFailed;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bosinstance = [[super allocWithZone:NULL] init];
    });
    return bosinstance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [DMBOSClientManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [DMBOSClientManager shareInstance];
}

@end
