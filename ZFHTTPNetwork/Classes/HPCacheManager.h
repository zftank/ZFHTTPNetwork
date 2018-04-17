//
//  HPCacheManager.h
//  SoYoungMobile40
//
//  Created by zftank on 2018/1/16.
//  Copyright © 2018年 soyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPCacheManager : NSObject

#pragma mark -
#pragma mark Photo Methods

+ (void)clearDiskCacheCompletion:(void(^)(BOOL complete))resultBlock;//删除图片硬盘缓存文件夹

+ (void)calculationDiskCacheCompletion:(void(^)(unsigned long long complete))resultBlock;//计算硬盘缓存大小

@end
