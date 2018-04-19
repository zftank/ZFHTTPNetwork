//
//  HPCachePhotoOperation.m
//  HTTPNetwork
//
//  Created by zftank on 2018/2/2.
//

#import "HPCachePhotoOperation.h"
#import "HPCachePhotoManager.h"

@implementation HPCachePhotoOperation

+ (id)create:(id)master details:(HTTPDetails *)details
  cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
  completion:(void(^)(BOOL cacheImage))completion {
    
    HPCachePhotoOperation *operation = [[HPCachePhotoOperation alloc] init];
    
    operation.breakSession = NO;
    
    operation.manager = master;
    
    operation.resultInfo = details;
    
    operation.cumulationBlock = cumulation;
    
    operation.completeBlock = completion;
    
    if ([master respondsToSelector:@selector(setOperationItem:)])
    {
        [master setOperationItem:operation];
    }
    
    return operation;
}

- (void)dealloc {
    
    _manager = nil;
    
    _resultInfo = nil;
    
    _cumulationBlock = nil;
    
    _completeBlock = nil;
}

- (void)stopOperation {
    
    [self cancel];
    
    self.breakSession = YES;
}

- (BOOL)checkCurrentSession {
    
    if (self.isCancelled || self.breakSession)
    {
        return NO;
    }
    
    return YES;
}

- (void)main {
    
    if ([self checkCurrentSession])
    {
        BOOL haveCache = [HPCacheImageManager checkCacheOfPhoto:self.resultInfo];
        
        if ([self checkCurrentSession])
        {
            if (haveCache)
            {
                [HPCacheImageManager decodeImageFromImage:self.resultInfo];
            }
            
            if ([self checkCurrentSession])
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    if (haveCache)
                    {
                        if (self.cumulationBlock)
                        {
                            self.cumulationBlock(1,1,1.0f);
                        }
                    }
                    
                    self.completeBlock(haveCache);
                    
                    self.completeBlock = nil;
                });
            }
        }
    }
}

@end
