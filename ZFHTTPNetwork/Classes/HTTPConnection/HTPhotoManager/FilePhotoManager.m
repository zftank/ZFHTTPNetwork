//
//  FilePhotoManager.m
//  SoYoungMobile40
//
//  Created by zftank on 2018/1/16.
//  Copyright © 2018年 soyoung. All rights reserved.
//

#import "FilePhotoManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FilePhotoManager

//获取图片缓存目录
+ (NSString *)getImageFolderOfCache {
    
    static NSString *cacheCatalogue = nil;
    
    if (cacheCatalogue)
    {
        return cacheCatalogue;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    cacheCatalogue = [documentsDirectory stringByAppendingPathComponent:@"com.cacheImage.default"];
    
    return cacheCatalogue;
}

//生成图片存储名称
+ (NSString *)cacheImageName:(NSString *)imageUrl {
    
    const char *cStr = [imageUrl UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(CC_LONG)strlen(cStr),result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
}

//生成图片存储路径
+ (NSString *)cacheImageStoragePath:(NSString *)imageName {
    
    NSString *folderPath = [FilePhotoManager getImageFolderOfCache];
    
    return [folderPath stringByAppendingPathComponent:imageName];
}

//计算硬盘缓存的大小
+ (unsigned long long)calculationDiskCacheForImage {
    
    NSString *filePath = [FilePhotoManager getImageFolderOfCache];
    
    unsigned long long size = 0;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    //是否为文件夹
    BOOL isDirectory = NO;
    
    BOOL exists = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    if (!exists)
    {
        return size;
    }
    
    if (isDirectory)
    {
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:filePath];
        
        for (NSString *subpath in enumerator)
        {
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            
            size += [fileManager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    }
    else
    {
        size = [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    
    return size;
}

@end
