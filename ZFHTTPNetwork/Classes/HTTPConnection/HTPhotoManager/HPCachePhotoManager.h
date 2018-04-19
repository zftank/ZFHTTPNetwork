//
//  HPCachePhotoManager.h
//  SoYoungMobile40
//
//  Created by zftank on 2018/1/12.
//  Copyright © 2018年 soyoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HTTPDetails.h"

#define HPCacheImageManager  [HPCachePhotoManager shareImageInstance]

@interface HPCachePhotoManager : NSObject

+ (HPCachePhotoManager *)shareImageInstance;

- (void)createCacheOfPhoto;//创建图片缓存(硬盘、内存)

#pragma mark -
#pragma mark Common Methods

- (void)checkCache:(id)master details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
        completion:(void(^)(BOOL cacheImage))completion;

- (BOOL)checkCacheOfPhoto:(HTTPDetails *)details;

- (void)checkImageType:(NSData *)data withInfo:(HTTPDetails *)details;//判断、解析图片类型

- (void)decodeImageFromImage:(HTTPDetails *)details;//图片解压缩


- (void)setImageForMemoryCache:(HTTPDetails *)details;//缓存到内存

- (BOOL)createCache:(NSString *)filePath content:(NSData *)content;//缓存到硬盘

@end
