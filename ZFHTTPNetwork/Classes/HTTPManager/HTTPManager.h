//
//  HTTPSession.h
//  HBFinance
//
//  Created by zftank on 16/9/17.
//  Copyright © 2016年 zftank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPManager : NSObject <NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (strong) NSURLSession *httpSession;

@property (strong) NSOperationQueue *taskQueue;

@end
