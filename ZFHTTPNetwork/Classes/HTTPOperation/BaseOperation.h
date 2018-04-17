//
//  BaseOperation.h
//  GJDD
//
//  Created by zftank on 14-10-28.
//  Copyright (c) 2014年 zftank. All rights reserved.
//

#import "HTTPConnection.h"
#import "HPMessageManager.h"
#import "CheckPattern.h"

#define kGetMethod         @"GET"

#define kPostMethod        @"POST"

#define kByteOfRecerver    @"countOfBytesReceived"

@interface BaseOperation : NSOperation

@property (weak) id manager;
@property (strong) HTTPDetails *resultInfo;

@property (weak) NSURLSession *httpSession;
@property (strong) NSURLSessionTask *httpTask;

@property (assign) BOOL finishTask;
@property (assign) BOOL executingTask;

@property (copy) void(^cumulationBlock)(int64_t receive,int64_t complete,CGFloat ratio);
@property (copy) void(^successBlock)(HTTPDetails *result);
@property (copy) void(^failureBlock)(HTTPDetails *result);

+ (id)createTask:(id)master details:(HTTPDetails *)details
     httpSession:(NSURLSession *)httpSession
      cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
         success:(void(^)(HTTPDetails *result))success
         failure:(void(^)(HTTPDetails *result))failure;

- (void)stopOperation;
- (void)checkOperation:(id)master;
- (void)checkOperation:(id)master withKey:(NSString *)key;

- (void)checkServerStatus;
- (void)checkNetworkStatus:(NSError *)error;
- (void)checkUserStatus;

- (void)setHTTPHeader:(NSMutableURLRequest *)HTTPRequest;
- (void)setRequestHTTPHeader:(NSMutableURLRequest *)HTTPRequest;
- (void)setRequestHTTPBody:(NSMutableURLRequest *)HTTPRequest;

- (void)startOperation;
- (void)closeOperation;
- (void)completionOperation;

@end
