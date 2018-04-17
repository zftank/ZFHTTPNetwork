//
//  UIButton+Network.m
//  PanoramicVideo
//
//  Created by zftank on 16/8/28.
//  Copyright © 2016年 PanoramicVideo. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+Network.h"
#import "HTTPConnection.h"
#import "CheckPattern.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@implementation UIButton (Network)

#pragma mark -
#pragma mark Associated Methods

- (id)operationItem {
    
    HTTPWeakPointer *weakObject = objc_getAssociatedObject(self,_cmd);
    
    return weakObject.weakPointer;
}

- (void)setOperationItem:(id)operation {
    
    if (operation)
    {
        HTTPWeakPointer *object = [[HTTPWeakPointer alloc] initManager:operation];
        
        objc_setAssociatedObject(self,@selector(operationItem),object,OBJC_ASSOCIATION_RETAIN);
    }
    else
    {
        objc_setAssociatedObject(self,@selector(operationItem),nil,OBJC_ASSOCIATION_RETAIN);
    }
}


- (NSString *)serverImageUrl {
    
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setServerImageUrl:(NSString *)imageUrl {
    
    objc_setAssociatedObject(self,@selector(serverImageUrl),imageUrl,OBJC_ASSOCIATION_COPY);
}


- (FLAnimatedImageView *)animationGIFView {
    
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setAnimationGIFView:(FLAnimatedImageView *)animationView {
    
    objc_setAssociatedObject(self,@selector(animationGIFView),animationView,OBJC_ASSOCIATION_RETAIN);
}

#pragma mark -
#pragma mark Photo Methods

- (void)stopImageRequest {
    
    id operation = self.operationItem;
    
    if (operation)
    {
        [HTTPLink stopImageRequest:operation];
    }
}

- (void)setContentImage:(UIImage *)content mode:(UIViewContentMode)mode {
    
    self.imageView.image = content;
    [self setImage:content forState:UIControlStateNormal];
    self.imageView.contentMode = mode;
    self.imageView.contentScaleFactor = [UIScreen mainScreen].scale;
    self.imageView.clipsToBounds = YES;
}

- (void)setImage:(id)content resultInfo:(HTTPDetails *)details mode:(UIViewContentMode)mode {
    
    [self.animationGIFView removeFromSuperview];
    self.animationGIFView = nil;
    
    if (details && details.CGImageType == UIImageGIFType)
    {
        if (details.showPosterImageForGIF)
        {
            [self setContentImage:content mode:mode];
        }
        else
        {
            self.imageView.image = nil;
            [self setImage:nil forState:UIControlStateNormal];
            
            self.animationGIFView = [[FLAnimatedImageView alloc] initWithFrame:self.bounds];
            self.animationGIFView.backgroundColor = [UIColor clearColor];
            self.animationGIFView.userInteractionEnabled = NO;
            self.animationGIFView.runLoopMode = details.runLoopMode;
            self.animationGIFView.animatedImage = content;
            
            self.autoresizesSubviews = YES;
            UIViewAutoresizing autoMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            self.animationGIFView.autoresizingMask = autoMask;
            
            self.animationGIFView.contentMode = mode;
            self.animationGIFView.contentScaleFactor = [UIScreen mainScreen].scale;
            self.animationGIFView.clipsToBounds = YES;
            
            [self addSubview:self.animationGIFView];
            [self sendSubviewToBack:self.animationGIFView];
        }
        
        
    }
    else
    {
        [self setContentImage:content mode:mode];
    }
}

- (void)roundedRectAllCornersAngle:(CGFloat)angle {
    
    if (angle <= 0.0f)
    {
        return;
    }

    if (self.layer.cornerRadius == angle)
    {
        return;
    }

    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = angle;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = angle;
}

- (void)startGIFAnimation:(NSInteger)loop {
    
    if (self.animationGIFView)
    {
        [self.animationGIFView startAnimating];
        
        NSUInteger current = self.animationGIFView.animatedImage.loopCount-self.animationGIFView.loopCountdown-1;
        
        if (loop <= current)
        {
            [self stopGIFAnimation];
        }
        else
        {
            self.animationGIFView.loopCompletionBlock = ^(NSUInteger loopCountRemaining)
            {
                NSUInteger current = self.animationGIFView.animatedImage.loopCount-loopCountRemaining-1;
                
                if (loop <= current)
                {
                    [self.animationGIFView stopAnimating];
                }
            };
        }
    }
}

- (void)stopGIFAnimation {
    
    if (self.animationGIFView)
    {
        [self.animationGIFView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.0f];
    }
}

#pragma mark -
#pragma mark 请求图片

- (void)requestImage:(HTTPDetails *)details
          cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
             success:(void(^)(HTTPDetails *result))success
             failure:(void(^)(HTTPDetails *result))failure {
    
    if ([CheckPattern checkUrlValid:details.requestUrl])
    {
        [self stopImageRequest];
        
        if ([self.serverImageUrl isEqualToString:details.requestUrl])
        {
            if (!self.currentImage && !self.animationGIFView.animatedImage)
            {
                [self setImage:details.siteImage resultInfo:nil mode:details.defaultMode];
            }
        }
        else
        {
            self.serverImageUrl = details.requestUrl;
            
            [self setImage:details.siteImage resultInfo:nil mode:details.defaultMode];
        }
        
        [self roundedRectAllCornersAngle:details.radiusOfRectangle];
        
        [HTTPLink requestImage:self details:details cumulation:cumulation success:^(HTTPDetails *result)
        {
            if (self.serverImageUrl && [result.requestUrl isEqualToString:self.serverImageUrl])
            {
                [self setImage:result.resultData resultInfo:result mode:result.contentMode];
                
                if (success)
                {
                    success(result);
                }
            }
        }
        failure:^(HTTPDetails *result)
        {
            if (self.serverImageUrl && [result.requestUrl isEqualToString:self.serverImageUrl])
            {
                if (result.errorImage)
                {
                    [self setImage:result.errorImage resultInfo:nil mode:result.defaultMode];
                }
                
                if (failure)
                {
                    failure(result);
                }
            }
        }];
    }
    else
    {
        [self stopImageRequest];
        
        self.serverImageUrl = nil;
        
        if (details.errorImage)
        {
            [self setImage:details.errorImage resultInfo:nil mode:details.defaultMode];
        }
        else
        {
            [self setImage:details.siteImage resultInfo:details mode:details.defaultMode];
        }
        
        [self roundedRectAllCornersAngle:details.radiusOfRectangle];
        
        if (failure)
        {
            failure(details);
        }
    }
}

@end
