//
//  PictureSession.m
//  PanoramicVideo
//
//  Created by zftank on 16/8/14.
//  Copyright © 2016年 PanoramicVideo. All rights reserved.
//

#import "HBPhotoOperation.h"
#import "HPCachePhotoManager.h"

@implementation HBPhotoOperation

+ (id)createTask:(id)master details:(HTTPDetails *)details
     httpSession:(NSURLSession *)httpSession
      cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
         success:(void(^)(HTTPDetails *result))success
         failure:(void(^)(HTTPDetails *result))failure {
    
    HBPhotoOperation *operation = [[HBPhotoOperation alloc] init];
    
    operation.manager = master;
    
    operation.resultInfo = details;
    
    operation.resultInfo.timeoutInterval = 60.0f;
    
    operation.httpSession = httpSession;
    
    operation.cumulationBlock = cumulation;
    
    operation.successBlock = success;
    
    operation.failureBlock = failure;
    
    if ([master respondsToSelector:@selector(setOperationItem:)])
    {
        [master setOperationItem:operation];
    }
    
    return operation;
}

- (void)dealloc {
    
    if (self.cumulationBlock)
    {
        [self.httpTask removeObserver:self forKeyPath:kByteOfRecerver];
    }
}

#pragma mark -
#pragma mark Common Methods

- (void)setHTTPHeader:(NSMutableURLRequest *)HTTPRequest {
    
    [HTTPRequest setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    
    [HTTPRequest setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    [HTTPRequest setValue:@"filter-header" forHTTPHeaderField:@"filter-key"];
}

#pragma mark -
#pragma mark Action Methods

- (void)start {
    
    if (self.isCancelled)
    {
        [self closeOperation];
    }
    else
    {
        [self startOperation];
        
        [self createTaskWithSession];
    }
}

- (void)createTaskWithSession {
    
    NSURL *imageUrl = [NSURL URLWithString:self.resultInfo.requestUrl];
    
    NSMutableURLRequest *HTTPRequest = [NSMutableURLRequest requestWithURL:imageUrl];
    
    HTTPRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    HTTPRequest.timeoutInterval = self.resultInfo.timeoutInterval;
    
    HTTPRequest.HTTPMethod = kGetMethod;
    
    [self setHTTPHeader:HTTPRequest];
    
    self.httpTask = [self.httpSession dataTaskWithRequest:HTTPRequest
                                        completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
    
        if (self.isCancelled)
        {
            [self closeOperation];
        }
        else
        {
            [self completeTask:data respone:response error:error];
        }
    }];
    
    if (self.cumulationBlock)
    {
        [self.httpTask addObserver:self forKeyPath:kByteOfRecerver options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    [self.httpTask resume];
}

- (void)completeTask:(NSData *)data respone:(NSURLResponse *)response error:(NSError *)error {
    
    if (data && !error)
    {
        self.resultInfo.requestHeader = self.httpTask.currentRequest.allHTTPHeaderFields;
        
        self.resultInfo.resultHeader = [(NSHTTPURLResponse *)response allHeaderFields];
        
        [HPCacheImageManager checkImageType:data withInfo:self.resultInfo];
        
        if (self.resultInfo.resultData)
        {
            [HPCacheImageManager setImageForMemoryCache:self.resultInfo];
            
            [HPCacheImageManager createCache:self.resultInfo.cachePath content:data];
            
            
            [HPCacheImageManager decodeImageFromImage:self.resultInfo];
            
            [self completeImageSession:YES];
        }
        else
        {
            [self completeImageSession:NO];
        }
    }
    else
    {
        [self completeImageSession:NO];
    }
}

- (void)completeImageSession:(BOOL)complete {
    
    if (self.isCancelled)
    {
        [self closeOperation];
    }
    else
    {
        if (complete)
        {
            self.resultInfo.success = YES;
            
            if (self.manager && self.successBlock)
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    self.successBlock(self.resultInfo);
                    
                    self.successBlock = nil;
                });
            }
        }
        else
        {
            self.resultInfo.success = NO;
            
            if (self.manager && self.failureBlock)
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    self.failureBlock(self.resultInfo);
                    
                    self.failureBlock = nil;
                });
            }
        }
        
        [self completionOperation];
    }
}

#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (self.cumulationBlock)
    {
        dispatch_async(dispatch_get_main_queue(),^{
            
            CGFloat receive = (CGFloat)self.httpTask.countOfBytesReceived;
            
            CGFloat complete = (CGFloat)self.httpTask.countOfBytesExpectedToReceive;
            
            if (0 < complete)
            {
                CGFloat ratio = (CGFloat)(receive/complete);
                
                self.cumulationBlock(receive,complete,ratio);
            }
        });
    }
}

@end
