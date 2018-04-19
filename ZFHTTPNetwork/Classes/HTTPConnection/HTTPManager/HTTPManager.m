//
//  HTTPSession.m
//  HBFinance
//
//  Created by zftank on 16/9/17.
//  Copyright © 2016年 zftank. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager

#pragma mark -
#pragma mark NSURLSession Delegate Methods

/***
 
 https双向认证：
 1、客户端请求服务器，如果是第一次请求，服务器返回向客户端返回证书
 2、客户端需要处理是否同意安装证书，如果同意安装，以后的所有通信都需要用这个证书来加密。（手机端需要自动处理证书）
 3、服务器拿到数据以后，利用自己的私钥解密数据。（数据只有私钥才能解密）
 
 单向认证：保证server是真的，通道是安全的（对称密钥）；
 双向认证：保证client和server是真的，通道是安全的（对称密钥）；
 
 单向认证：
 1.clinet<——server
 2.clinet——>server
 1.client从server处拿到server的证书，通过公司的CA去验证该证书，以确认server是真实的；
 2.从server的证书中取出公钥，对client端产生的一个密钥加密（该密钥即对称密钥）。将加密后的密钥发送到server端。server端用其私钥解密出数据，即得到了对称密钥；
 3.以后的交易都是http+该对称密钥加密的方式来处理；
 
 双向认证：
 与单向认证的区别就是在1.2步骤中产生的是二分之一的对称密钥。
 即对称密钥是client与server各自产生一半；
 
 ***/

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,NSURLCredential *credential))completionHandler {
    
    NSURLCredential *myCredential = nil;
    NSURLSessionAuthChallengeDisposition myDisposition = 0;
    
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        myCredential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        if (myCredential)
        {
            myDisposition = NSURLSessionAuthChallengeUseCredential;
        }
        else
        {
            myDisposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }
    else
    {
        myDisposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    if (completionHandler)
    {
        completionHandler(myDisposition,myCredential);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {
    
    //允许服务器重定向
    if (completionHandler)
    {
        completionHandler(request);
    }
}

@end
