//
//  HBPhotoSession.h
//  HBFinance
//
//  Created by zftank on 16/9/17.
//  Copyright © 2016年 zftank. All rights reserved.
//

#import "HTTPManager.h"
#import "HBPhotoOperation.h"
#import "HPCachePhotoManager.h"

@interface HBPhotoManager : HTTPManager

+ (HBPhotoManager *)HBHTTPPhotoManager;

- (void)createTask:(id)master details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
           success:(void(^)(HTTPDetails *result))success
           failure:(void(^)(HTTPDetails *result))failure;

- (void)stopImageRequest:(id)manager;

@end
