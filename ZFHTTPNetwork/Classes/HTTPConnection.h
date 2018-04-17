//
//  HTTPConnection.h
//  Cartoon
//
//  Created by feng zhang on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HTTPDetails.h"
#import "HDFileManager.h"
#import "HPCacheManager.h"
#import "UIButton+UIImage.h"
#import "UIImageView+UIImage.h"
#import "NSModelManager.h"
#import "UIListModelManager.h"
#import "HTTPCommon.h"

#define HTTPLink  [HTTPConnection HTTPInstance]

@interface HTTPConnection : NSObject <HTTPCommon>

#pragma mark -
#pragma mark Data 数据请求

- (void)stopDataRequest:(id)manager;

- (void)stopRequest:(id)manager withKey:(NSString *)key;

- (void)requestData:(id)manager details:(HTTPDetails *)details
            success:(void(^)(HTTPDetails *result))success
            failure:(void(^)(HTTPDetails *result))failure;

#pragma mark -
#pragma mark Photo 图片请求

- (void)requestImage:(id)manager details:(HTTPDetails *)details
          cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
             success:(void(^)(HTTPDetails *result))success
             failure:(void(^)(HTTPDetails *result))failure;

#pragma mark -
#pragma mark UPload 上传数据

- (void)stopUploadData:(id)manager;

- (void)uploadData:(id)manager details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
           success:(void(^)(HTTPDetails *result))success
           failure:(void(^)(HTTPDetails *result))failure;

#pragma mark -
#pragma mark Download 下载数据

- (void)downLoad:(id)manager details:(HTTPDetails *)details
      cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
         success:(void(^)(HTTPDetails *result))success
         failure:(void(^)(HTTPDetails *result))failure;

@end
