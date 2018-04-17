//
//  HTTPCommon.h
//  51TalkTeacher
//
//  Created by zftank on 2018/4/13.
//  Copyright © 2018年 51TalkTeacher. All rights reserved.
//

@class HTTPConnection;

#define kAccountTokenInvalid    @"kAccountTokenInvalid"//token失效的通知

typedef NS_ENUM (NSInteger,URLMethod) {
    
    GetMethod = 0,           //get请求，默认值
    
    PostMethod = 1,          //post请求
};

typedef NS_ENUM (NSInteger,ResolveMode) {
    
    OriginalMode = 0,       //不进行解析
    
    JSONResolver = 1,       //JSON解析，默认值
};

typedef NS_ENUM (NSInteger,UIAnimationType) {
    
    UIAnimationNone = 0,       //没有动画
    
    UIAnimationAlpha = 1,      //第一次加载的图片做alpha动画，默认值
};

typedef NS_ENUM (NSInteger,UIImageType) {
    
    UIImageNoneType = 0,      //未知类型，默认值
    
    UIImagePNGType = 1,
    
    UIImageJPEGType = 2,
    
    UIImageGIFType = 3,
    
    UIImageWebPType = 4,
    
    UIImageTIFFType = 5,
    
    UIImageHEICType = 6,
};

typedef NS_ENUM (NSInteger,FromSourceType) {
    
    FromCacheType = 0,       //来自内存
    
    FromDiskType = 1,        //来自硬盘
    
    FromServerType = 2,      //来自服务器，默认值
};

typedef NS_ENUM (NSInteger,HTTPState) {
    
    HTTPNetworkNormal = 0,             //数据正常返回，默认值
    
    HTTPCancelNetworkState = 900100,   //请求被取消
    
    HTTPNotNetworkState = 900300,      //没有网络
    
    HTTPNetworkTimedOut = 900500,      //网络超时
    
    HTTPServerErrorState = 900700,     //服务器错误
    
    AccountTokenInvalid = 900000,      //Token失效
};


@protocol HTTPCommon <NSObject>

@optional

#pragma mark -
#pragma mark HTTPConnection

+ (HTTPConnection *)HTTPInstance;

- (void)closeCompleteRequest;

- (void)stopImageRequest:(id)manager;

#pragma mark -
#pragma mark Photo Category

- (void)setOperationItem:(id)operation;

@end
