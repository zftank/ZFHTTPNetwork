//
//  HBUploadOperation.m
//  HBankXLoan
//
//  Created by zftank on 2016/10/29.
//  Copyright © 2016年 HBankXLoan. All rights reserved.
//

#import "HBUploadOperation.h"

@implementation HBUploadOperation

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
    
    HTTPRequest.HTTPMethod = kPostMethod;
    
    [self setRequestHTTPHeader:HTTPRequest];
    
    [self setRequestHTTPBody:HTTPRequest];
    
    self.httpTask = [self.httpSession uploadTaskWithRequest:HTTPRequest fromData:nil
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
        
        self.resultInfo.resultData = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:nil];
        [self checkServerStatus];
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            if (self.manager && self.successBlock)
            {
                self.successBlock(self.resultInfo);
            }
            
            self.successBlock = nil;
            
            [self checkUserStatus];
        });
    }
    else
    {
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
    
    [self completionOperation];
}

@end
