//
//  FilePhotoManager.h
//  SoYoungMobile40
//
//  Created by zftank on 2018/1/16.
//  Copyright © 2018年 soyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePhotoManager : NSObject

+ (NSString *)getImageFolderOfCache;


+ (NSString *)cacheImageName:(NSString *)imageUrl;


+ (NSString *)cacheImageStoragePath:(NSString *)imageName;


+ (unsigned long long)calculationDiskCacheForImage;

@end
