//
//  DownloadOperation.m
//  HBFinance
//
//  Created by zftank on 16/9/27.
//  Copyright © 2016年 zftank. All rights reserved.
//

#import "HBLoadOperation.h"

@implementation HBLoadOperation

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
    
    HTTPRequest.HTTPMethod = kGetMethod;
    
    [self setRequestHTTPHeader:HTTPRequest];
    
    [self setRequestHTTPBody:HTTPRequest];
    
    self.httpTask = [self.httpSession downloadTaskWithRequest:HTTPRequest
                                            completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error) {
    
        if (self.isCancelled)
        {
            [self closeOperation];
        }
        else
        {
            [self completeTask:location respone:response error:error];
        }
    }];
    
    [self.httpTask resume];
}

- (void)completeTask:(NSURL *)location respone:(NSURLResponse *)response error:(NSError *)error {
    
    if (location && !error)
    {
        self.resultInfo.success = YES;
        
        self.resultInfo.requestHeader = self.httpTask.currentRequest.allHTTPHeaderFields;
        
        self.resultInfo.resultHeader = [(NSHTTPURLResponse *)response allHeaderFields];
        
//        if ([CheckPattern checkUrlValid:self.resultInfo.filePath])
//        {
//            NSURL *saveUrl = [NSURL fileURLWithPath:self.resultInfo.filePath];
//            
//            NSFileManager *fileManager = [[NSFileManager alloc] init];
//            
//            [fileManager moveItemAtURL:location toURL:saveUrl error:nil];
//            
//            dispatch_async(dispatch_get_main_queue(),^{
//                
//                if (self.manager && self.successBlock)
//                {
//                    self.successBlock(self.resultInfo);
//                }
//                
//                self.successBlock = nil;
//            
//                [self checkUserStatus];
//            });
//        }
//        else
//        {
//            [self completeTaskRespone:response error:nil];
//        }
    }
    else
    {
        [self completeTaskRespone:response error:error];
    }
    
    [self completionOperation];
}

- (void)completeTaskRespone:(NSURLResponse *)response error:(NSError *)error {
    
    self.resultInfo.success = NO;
    
    self.resultInfo.requestHeader = self.httpTask.currentRequest.allHTTPHeaderFields;
    
    self.resultInfo.resultHeader = [(NSHTTPURLResponse *)response allHeaderFields];
    
    [self checkNetworkStatus:error];
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        if (self.manager && self.failureBlock)
        {
            self.failureBlock(self.resultInfo);
        }
        
        self.failureBlock = nil;
    });
}

@end
