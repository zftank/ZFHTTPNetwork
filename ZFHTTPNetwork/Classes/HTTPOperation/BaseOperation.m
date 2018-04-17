//
//  BaseOperation.m
//  GJDD
//
//  Created by zftank on 14-10-28.
//  Copyright (c) 2014年 zftank. All rights reserved.
//

#import "BaseOperation.h"

@implementation BaseOperation

+ (id)createTask:(id)master details:(HTTPDetails *)details
     httpSession:(NSURLSession *)httpSession
      cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
         success:(void(^)(HTTPDetails *result))success
         failure:(void(^)(HTTPDetails *result))failure {
    
    BaseOperation *operation = [[[self class] alloc] init];
    
    operation.manager = master;
    
    operation.resultInfo = details;
    
    operation.httpSession = httpSession;
    
    operation.cumulationBlock = cumulation;
    
    operation.successBlock = success;
    
    operation.failureBlock = failure;
    
    return operation;
}

- (void)dealloc {
    
    _manager = nil;
    
    _resultInfo = nil;
    
    _cumulationBlock = nil;
    
    _successBlock = nil;
    
    _failureBlock = nil;
    
    _httpSession = nil;
    
    _httpTask = nil;
}

#pragma mark -
#pragma mark HTTPHeader Methods

- (void)setHTTPHeader:(NSMutableURLRequest *)HTTPRequest {
    
    [HTTPRequest setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    
    [HTTPRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [HTTPRequest setValue:@"filter-header" forHTTPHeaderField:@"filter-key"];
}

- (void)setRequestHTTPHeader:(NSMutableURLRequest *)HTTPRequest {
    
    NSMutableDictionary *allHeader = [NSMutableDictionary dictionary];
    
    if (self.resultInfo.commonHeader)
    {
        [allHeader addEntriesFromDictionary:self.resultInfo.commonHeader];
    }
    
    if (self.resultInfo.requestHeader && 0 < self.resultInfo.requestHeader.count)
    {
        [allHeader addEntriesFromDictionary:self.resultInfo.requestHeader];
    }
    
    HTTPRequest.allHTTPHeaderFields = allHeader;
    
    [self setHTTPHeader:HTTPRequest];
}

#pragma mark -
#pragma mark HTTPBody Methods

- (void)setRequestHTTPBody:(NSMutableURLRequest *)HTTPRequest {
    
    BOOL existenceBody = NO;
    
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    
    if (self.resultInfo.requestBody && 0 < self.resultInfo.requestBody.count)
    {
        NSDictionary *content = self.resultInfo.requestBody;
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:content options:0 error:nil];
        
        if (data)
        {
            existenceBody = YES;[bodyData appendData:data];
        }
    }
    
    if (self.resultInfo.listBody && 0 < self.resultInfo.listBody.count)
    {
        NSArray *content = self.resultInfo.listBody;
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:content options:0 error:nil];
        
        if (data)
        {
            existenceBody = YES;[bodyData appendData:data];
        }
    }
    
    if (existenceBody)
    {
        [HTTPRequest setHTTPBody:bodyData];
    }
}

#pragma mark -
#pragma mark Check Methods

- (void)checkServerStatus {
    
    NSDictionary *dictionary = self.resultInfo.resultData;
    
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        NSString *status = [dictionary customForKey:@"status"];
        
        if (status && 0 < status.length)
        {
            self.resultInfo.httpState = status.integerValue;
            
            self.resultInfo.message = [dictionary customForKey:@"message"];
        }
        else
        {
            self.resultInfo.httpState = HTTPServerErrorState;
            
            self.resultInfo.message = [dictionary customForKey:@"message"];
        }
    }
    else
    {
        self.resultInfo.success = NO;
        
        self.resultInfo.httpState = HTTPServerErrorState;
    }
    
    //判断服务器状态
    if (self.resultInfo.httpState == HTTPNetworkNormal)
    {
        self.resultInfo.success = YES;
    }
    else
    {
        self.resultInfo.success = NO;
        
        if (self.resultInfo.httpState == AccountTokenInvalid)
        {
            self.resultInfo.message = nil;
        }
        else
        {
            [HPMessageManager showTips:self.resultInfo duration:3.0f];
        }
    }
}

- (void)checkUserStatus {
    
    if (self.resultInfo.httpState == AccountTokenInvalid)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAccountTokenInvalid object:nil];
    }
}

- (void)checkNetworkStatus:(NSError *)error {

    if (error.code == -1009)
    {
        self.resultInfo.httpState = HTTPNotNetworkState;
    }
    else if (error.code == -1001)
    {
        self.resultInfo.httpState = HTTPNetworkTimedOut;
    }
    else
    {
        self.resultInfo.httpState = HTTPServerErrorState;
    }
    
    [HPMessageManager showTips:self.resultInfo duration:5.0f];
}

#pragma mark -
#pragma mark Cancel Methods

- (BOOL)atOperations:(id)master {
    
    return [self.manager isEqual:master];
}

- (BOOL)isRequestKey:(NSString *)code {
    
    return [self.resultInfo.requestKey isEqualToString:code];
}

- (void)checkOperation:(id)master {
    
    if ([self atOperations:master])
    {
        [self stopOperation];
    }
}

- (void)checkOperation:(id)master withKey:(NSString *)key {
    
    if ([self atOperations:master])
    {
        if ([self isRequestKey:key])
        {
            [self stopOperation];
        }
    }
}

- (void)stopOperation {

    [self completionOperation];
    
    self.manager = nil;
    
    self.successBlock = nil;
    
    self.failureBlock = nil;
}

#pragma mark -
#pragma mark Operation Methods

- (void)startOperation {
    
    [self willChangeValueForKey:@"isExecuting"];
    _executingTask = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    _finishTask = NO;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)closeOperation {
    
    self.resultInfo.success = NO;
    self.resultInfo.httpState = HTTPCancelNetworkState;
    
    [self completionOperation];
}

- (void)completionOperation {
    
    [self.httpTask cancel];
    
    [self cancel];
    
    [self willChangeValueForKey:@"isExecuting"];
    _executingTask = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    _finishTask = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isAsynchronous {
    
    return YES;
}

- (BOOL)isFinished {
    
    return _finishTask;
}

- (BOOL)isExecuting {
    
    return _executingTask;
}

@end
