//
//  HBUploadManager.m
//  HBankXLoan
//
//  Created by zftank on 2016/10/29.
//  Copyright © 2016年 HBankXLoan. All rights reserved.
//

#import "HBUploadManager.h"
#import "HBUploadOperation.h"

@implementation HBUploadManager

+ (HBUploadManager *)HBUPloadManager {

    HBUploadManager *manager = [[HBUploadManager alloc] init];
    
    //创建并行队列
    manager.taskQueue = [[NSOperationQueue alloc] init];
    manager.taskQueue.maxConcurrentOperationCount = 2;
    
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
    
    HBUploadOperation *upload = [HBUploadOperation createTask:master details:details
                                                  httpSession:self.httpSession
                                                   cumulation:cumulation
                                                      success:success failure:failure];
    
    [self.taskQueue addOperation:upload];
}

#pragma mark -
#pragma mark Cancel Methods

- (void)stopUploadData:(id)manager {
    
    if (manager)
    {
        NSArray *commons = self.taskQueue.operations;
        
        for (id commonTask in commons)
        {
            if ([commonTask respondsToSelector:@selector(checkOperation:)])
            {
                [commonTask checkOperation:manager];
            }
        }
    }
}

@end
