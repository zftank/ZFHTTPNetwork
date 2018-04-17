//
//  HTTPConnection.m
//  Cartoon
//
//  Created by feng zhang on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HTTPConnection.h"
#import "HBDataManager.h"
#import "HBPhotoManager.h"
#import "HBLoadManager.h"
#import "HBUploadManager.h"
#import "CheckPattern.h"

@interface HTTPConnection ()

@property (strong) HBDataManager *DATAManager;

@property (strong) HBPhotoManager *PHOTOManager;

@property (strong) HBUploadManager *UPLOADManager;

@property (strong) HBLoadManager *LOADManager;

@end

@implementation HTTPConnection

+ (HTTPConnection *)HTTPInstance {
    
    static dispatch_once_t onceToken;
    
    static HTTPConnection *shareInstance = nil;
    
    dispatch_once(&onceToken,^{
        
        shareInstance = [[HTTPConnection alloc] init];
        
        shareInstance.DATAManager = [HBDataManager HBHTTPDataManager];
        
        shareInstance.PHOTOManager = [HBPhotoManager HBHTTPPhotoManager];
        
        shareInstance.UPLOADManager = [HBUploadManager HBUPloadManager];
        
        shareInstance.LOADManager = [HBLoadManager HBDownloadManager];
    });
    
    return shareInstance;
}

#pragma mark -
#pragma mark Data 数据请求

- (void)closeCompleteRequest {
    
    [self.DATAManager closeCompleteRequest];
}

- (void)stopDataRequest:(id)manager {
    
    [self.DATAManager stopDataRequest:manager];
}

- (void)stopRequest:(id)manager withKey:(NSString *)key {
    
    [self.DATAManager stopDataRequest:manager withKey:key];
}

- (void)requestData:(id)manager details:(HTTPDetails *)details
            success:(void(^)(HTTPDetails *result))success
            failure:(void(^)(HTTPDetails *result))failure {
    
    [self.DATAManager createTask:manager details:details
                      cumulation:nil success:success failure:failure];
}

- (void)requestData:(id)manager details:(HTTPDetails *)details
         cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
            success:(void(^)(HTTPDetails *result))success
            failure:(void(^)(HTTPDetails *result))failure {
    
    [self.DATAManager createTask:manager details:details
                      cumulation:cumulation success:success failure:failure];
}

#pragma mark -
#pragma mark Photo 图片请求

- (void)stopImageRequest:(id)manager {

    [self.PHOTOManager stopImageRequest:manager];
}

- (void)requestImage:(id)manager details:(HTTPDetails *)details
          cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
             success:(void(^)(HTTPDetails *result))success
             failure:(void(^)(HTTPDetails *result))failure {

    if ([CheckPattern checkUrlValid:details.requestUrl])
    {
        [HPCacheImageManager checkCache:manager details:details cumulation:cumulation completion:^(BOOL cacheImage)
        {
            if (cacheImage)
            {
                if (success)
                {
                    success(details);
                }
            }
            else
            {
                [self.PHOTOManager createTask:manager details:details
                                   cumulation:cumulation success:success failure:failure];
            }
        }];
    }
    else
    {
        if (failure)
        {
            failure(details);
        }
    }
}

#pragma mark -
#pragma mark UPload 上传数据

- (void)stopUploadData:(id)manager {
    
    [self.UPLOADManager stopUploadData:manager];
}

- (void)uploadData:(id)manager details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
           success:(void(^)(HTTPDetails *result))success
           failure:(void(^)(HTTPDetails *result))failure {
    
    [self.UPLOADManager createTask:manager details:details
                        cumulation:cumulation success:success failure:failure];
}

#pragma mark -
#pragma mark Download 下载数据

- (void)downLoad:(id)manager details:(HTTPDetails *)details
      cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
         success:(void(^)(HTTPDetails *result))success
         failure:(void(^)(HTTPDetails *result))failure {
    
    [self.LOADManager createTask:manager details:details
                      cumulation:cumulation success:success failure:failure];
}

@end
