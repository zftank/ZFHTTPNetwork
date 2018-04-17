//
//  HPCacheManager.m
//  SoYoungMobile40
//
//  Created by zftank on 2018/1/16.
//  Copyright © 2018年 soyoung. All rights reserved.
//

#import "HPCacheManager.h"
#import "FilePhotoManager.h"

@implementation HPCacheManager

#pragma mark -
#pragma mark Photo Methods

+ (void)clearDiskCacheCompletion:(void(^)(BOOL complete))resultBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        NSString *folderPath = [FilePhotoManager getImageFolderOfCache];
        
        BOOL complete = [fileManager removeItemAtPath:folderPath error:NULL];
        
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
        
        if (resultBlock)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                
                resultBlock(complete);
            });
        }
    });
}

+ (void)calculationDiskCacheCompletion:(void(^)(unsigned long long complete))resultBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        unsigned long long size = [FilePhotoManager calculationDiskCacheForImage];
        
        if (resultBlock)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                
                resultBlock(size);
            });
        }
    });
}

@end
