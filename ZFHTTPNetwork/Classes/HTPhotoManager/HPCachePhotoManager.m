//
//  HPCachePhotoManager.m
//  SoYoungMobile40
//
//  Created by zftank on 2018/1/12.
//  Copyright © 2018年 soyoung. All rights reserved.
//

#import "HPCachePhotoManager.h"
#import "FilePhotoManager.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSData+UIImageType.h"
#import "FLAnimatedImage.h"
#import "UIImage+ForceDecode.h"
#import "HPCachePhotoOperation.h"

#define kCountLimit    50

@interface HPCachePhotoManager ()

@property (strong) NSCache *cacheOfImage;

@property (strong) NSOperationQueue *IOImageQueue;

@end

@implementation HPCachePhotoManager

+ (HPCachePhotoManager *)shareImageInstance {
    
    static dispatch_once_t onceToken;
    
    static HPCachePhotoManager *shareInstance = nil;
    
    dispatch_once(&onceToken,^{
        
        shareInstance = [[HPCachePhotoManager alloc] init];
        
        shareInstance.IOImageQueue = [[NSOperationQueue alloc] init];
        shareInstance.IOImageQueue.maxConcurrentOperationCount = 1;
    });
    
    return shareInstance;
}

- (void)createCacheOfPhoto {
    
    //创建硬盘缓存
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *folderPath = [FilePhotoManager getImageFolderOfCache];
    
    if ([fileManager fileExistsAtPath:folderPath])
    {
        //大于8000张图片删除文件夹
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:folderPath];
        
        NSUInteger cacheCount = fileEnumerator.allObjects.count;
        
        if (8000 < cacheCount)
        {
            [fileManager removeItemAtPath:folderPath error:NULL];
            
            [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    else
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    //删除SDWebImage缓存目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *component = @"default/com.hackemist.SDWebImageCache.default";
    NSString *sdCache = [documentsDirectory stringByAppendingPathComponent:component];
    [fileManager removeItemAtPath:sdCache error:NULL];
    
    //创建内存缓存，GIF图不缓存
    self.cacheOfImage = [[NSCache alloc] init];

    self.cacheOfImage.countLimit = kCountLimit;

    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                      object:nil queue:[NSOperationQueue currentQueue]
                                                  usingBlock:^(NSNotification *note) {
        [self.cacheOfImage removeAllObjects];
    }];
}

#pragma mark -
#pragma mark Common Methods

- (void)checkCache:(id)master details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
        completion:(void(^)(BOOL cacheImage))completion {
    
    if (details.childThreadCheckCache)
    {
        HPCachePhotoOperation *operation = [HPCachePhotoOperation create:master details:details
                                                              cumulation:cumulation completion:completion];
        
        [self.IOImageQueue addOperation:operation];
    }
    else
    {
        BOOL cacheImage = [self checkCacheOfPhoto:details];
        
        if (completion)
        {
            completion(cacheImage);
        }
    }
}

- (BOOL)checkCacheOfPhoto:(HTTPDetails *)details {
    
    [details setValue:[FilePhotoManager cacheImageName:details.requestUrl] forKey:@"cacheName"];
    
    details.resultData = [self.cacheOfImage objectForKey:details.cacheName];

    if (details.resultData)
    {
        [details setValue:[NSNumber numberWithInteger:FromCacheType] forKey:@"fromType"];
        
        [details setValue:[NSNumber numberWithInteger:UIImagePNGType] forKey:@"CGImageType"];

        return YES;
    }
    
    [details setValue:[FilePhotoManager cacheImageStoragePath:details.cacheName] forKey:@"cachePath"];
    
    //NSData *dataImage = [NSData dataWithContentsOfFile:details.cachePath options:NSDataReadingMappedIfSafe error:NULL];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    NSData *dataImage = [fileManager contentsAtPath:details.cachePath];
    
    [self checkImageType:dataImage withInfo:details];
    
    if (details.resultData)
    {
        [self setImageForMemoryCache:details];
        
        [details setValue:[NSNumber numberWithInteger:FromDiskType] forKey:@"fromType"];
        
        return YES;
    }
    else
    {
        [details setValue:[NSNumber numberWithInteger:FromServerType] forKey:@"fromType"];
        
        return NO;
    }
}

- (void)checkImageType:(NSData *)data withInfo:(HTTPDetails *)details {
    
    if (!data)
    {
        details.resultData = nil;
        
        [details setValue:[NSNumber numberWithInteger:UIImageNoneType] forKey:@"CGImageType"];
        
        return;
    }
    
    //判断图片类型
    UIImageType CGImageType = [NSData checkImageTypeFromData:data];
    
    if (CGImageType == UIImageGIFType)
    {
        FLAnimatedImage *FLImage = [FLAnimatedImage animatedImageWithGIFData:data];
        
        if (details.showPosterImageForGIF)
        {
            details.resultData = [FLImage posterImage];
        }
        else
        {
            details.resultData = FLImage;
        }
        
        [details setValue:[NSNumber numberWithInteger:UIImageGIFType] forKey:@"CGImageType"];
    }
    else
    {
        details.resultData = [[UIImage alloc] initWithData:data];
        
        [details setValue:[NSNumber numberWithInteger:UIImagePNGType] forKey:@"CGImageType"];
    }
    
    
    if (!details.resultData)
    {
        [details setValue:[NSNumber numberWithInteger:UIImageNoneType] forKey:@"CGImageType"];
    }
}

- (void)decodeImageFromImage:(HTTPDetails *)details {
    
    //图片解压缩
    if (details.CGImageType == UIImagePNGType)
    {
        UIImage *resultImage = details.resultData;

        details.resultData = [UIImage decodedImageWithImage:resultImage];
    }
}

- (void)setImageForMemoryCache:(HTTPDetails *)details {
    
    if (details.CGImageType == UIImagePNGType)
    {
        if (details.resultData && details.cacheName)
        {
            [self.cacheOfImage setObject:details.resultData forKey:details.cacheName];
        }
    }
}

- (BOOL)createCache:(NSString *)filePath content:(NSData *)content {
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *folderPath = [FilePhotoManager getImageFolderOfCache];
    
    if ([fileManager fileExistsAtPath:folderPath] == NO)
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return [fileManager createFileAtPath:filePath contents:content attributes:nil];
}

@end
