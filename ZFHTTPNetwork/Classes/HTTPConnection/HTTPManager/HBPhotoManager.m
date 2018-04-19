//
//  HBPhotoSession.m
//  HBFinance
//
//  Created by zftank on 16/9/17.
//  Copyright © 2016年 zftank. All rights reserved.
//

#import "HBPhotoManager.h"

@implementation HBPhotoManager

+ (HBPhotoManager *)HBHTTPPhotoManager {
    
    //创建缓存空间
    [HPCacheImageManager createCacheOfPhoto];
    
    HBPhotoManager *manager = [[HBPhotoManager alloc] init];
    
    //创建并行队列
    manager.taskQueue = [[NSOperationQueue alloc] init];
    manager.taskQueue.maxConcurrentOperationCount = 3;
    
    //创建NSURLSession
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    configuration.URLCache = nil;configuration.HTTPCookieStorage = nil;
    
    manager.httpSession = [NSURLSession sessionWithConfiguration:configuration
                                                        delegate:manager delegateQueue:manager.taskQueue];
    
    return manager;
}

- (void)createTask:(id)master details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
           success:(void(^)(HTTPDetails *result))success
           failure:(void(^)(HTTPDetails *result))failure {
    
    HBPhotoOperation *operation = [HBPhotoOperation createTask:master details:details
                                                   httpSession:self.httpSession
                                                    cumulation:cumulation
                                                       success:success failure:failure];
    
    [self.taskQueue addOperation:operation];
}

#pragma mark -
#pragma mark Cancel Methods

- (void)stopImageRequest:(id)manager {
    
    if ([manager respondsToSelector:@selector(stopOperation)])
    {
        [manager stopOperation];
    }
}

@end
