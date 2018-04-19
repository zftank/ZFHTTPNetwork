//
//  HTTPDetails.h
//  JiuTianWaiApp
//
//  Created by zhangfeng on 13-6-21.
//  Copyright (c) 2013年 MasterPlate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FLAnimatedImage.h"
#import "HTTPCommon.h"

@interface HTTPDetails : NSObject

/***** 数据请求 *****/
@property (copy) NSString *requestUrl;                   //网络地址
@property (copy) NSString *requestKey;                   //请求标志

@property (assign) URLMethod requestMethod;              //默认GET方法
@property (assign) NSTimeInterval timeoutInterval;       //网络超时，默认60s
@property (assign) ResolveMode resolveMode;              //解析模式，默认JSON解析

@property (copy) NSDictionary *requestHeader;            //向header里面添加自定义参数
@property (copy) NSDictionary *commonHeader;             //向header里面添加公用参数

@property (copy) NSDictionary *requestBody;              //向body里面添加数据，字典转化为JSON
@property (copy) NSArray *listBody;                      //向body里面添加数据，数组转化为JSON

/***** 图片请求 *****/
@property (strong) UIImage *siteImage;                   //默认占位图
@property (strong) UIImage *errorImage;                  //失败占位图

@property (assign) CGFloat radiusOfRectangle;            //圆角矩形，默认0.0f

@property (assign) UIAnimationType animationType;        //动画类型，默认UIAnimationAlpha，第一次加载的图片做alpha动画
@property (copy) NSString *runLoopMode;                  //设置GIF动画的Runloop模式，默认NSDefaultRunLoopMode

@property (assign) BOOL showPosterImageForGIF;           //是否只显示GIF图片的第一张，默认NO
@property (assign) BOOL childThreadCheckCache;           //是否在子线程检查图片缓存，默认NO

@property (assign) UIViewContentMode contentMode;        //设置内容图片展示方式
@property (assign) UIViewContentMode defaultMode;        //设置占位图展示方式

@property (readonly) UIImageType CGImageType;            //图片类型，默认、请求失败都是UIImageNoneType
@property (readonly) FromSourceType fromType;            //图片来源(内存、硬盘、服务器)，默认FromServerType

@property (readonly) CGSize originalSize;                //图片的原始Size
@property (readonly,copy) NSString *cacheName;           //图片的存储名称
@property (readonly,copy) NSString *cachePath;           //图片的存储路径，可能为空

/***** 网络返回 *****/
@property (assign) BOOL success;                         //返回值状态，默认YES
@property (assign) HTTPState httpState;                  //网络状态码，默认正常(HTTPNetworkNormal)
@property (copy) NSString *message;                      //服务器提示

@property (strong) id resultHeader;                      //返回的头文件
@property (strong) id resultData;                        //返回的body（可能为NSDictionary、UIImage、FLAnimatedImage）

@end
