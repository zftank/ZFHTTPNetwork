//
//  HTTPDataSession.m
//  PanoramicVideo
//
//  Created by zftank on 16/8/17.
//  Copyright © 2016年 PanoramicVideo. All rights reserved.
//

#import "HBDataOperation.h"

@implementation HBDataOperation

- (void)dealloc {
    
    
}

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
    
    NSURL *strUrl = [NSURL URLWithString:[CheckPattern URLEncode:self.resultInfo.requestUrl]];
    
    NSMutableURLRequest *HTTPRequest = [NSMutableURLRequest requestWithURL:strUrl];
    
    HTTPRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    HTTPRequest.timeoutInterval = self.resultInfo.timeoutInterval;
    
    if (self.resultInfo.requestMethod == GetMethod)
    {
        HTTPRequest.HTTPMethod = kGetMethod;
    }
    else if (self.resultInfo.requestMethod == PostMethod)
    {
        HTTPRequest.HTTPMethod = kPostMethod;
    }
    
    [self setRequestHTTPHeader:HTTPRequest];
    
    [self setRequestHTTPBody:HTTPRequest];
    
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
    
    [self.httpTask resume];
}

- (void)completeTask:(NSData *)data respone:(NSURLResponse *)response error:(NSError *)error {
    
    if (data && !error)
    {
        self.resultInfo.requestHeader = self.httpTask.currentRequest.allHTTPHeaderFields;
        
        self.resultInfo.resultHeader = [(NSHTTPURLResponse *)response allHeaderFields];
        
        if (self.resultInfo.resolveMode == JSONResolver)
        {
            self.resultInfo.resultData = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:nil];
            //判断服务器返回值
            [self checkServerStatus];
        }
        else if (self.resultInfo.resolveMode == OriginalMode)
        {
            self.resultInfo.success = YES;
            
            self.resultInfo.resultData = data;
        }
        
        //结束NSOperation
        [self completionOperation];
        
        //回调主线程
        if (self.manager && self.successBlock)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                
                self.successBlock(self.resultInfo);
                
                self.successBlock = nil;
            
                [self checkUserStatus];
            });
        }
    }
    else
    {
        self.resultInfo.success = NO;
        
        self.resultInfo.requestHeader = self.httpTask.currentRequest.allHTTPHeaderFields;
        
        self.resultInfo.resultHeader = [(NSHTTPURLResponse *)response allHeaderFields];
        
        [self checkNetworkStatus:error];
        
        //结束NSOperation
        [self completionOperation];
        
        //回调主线程
        if (self.manager && self.failureBlock)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                
                self.failureBlock(self.resultInfo);
                
                self.failureBlock = nil;
            });
        }
    }
}

@end
