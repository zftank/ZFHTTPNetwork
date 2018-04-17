//
//  UIImageView+UIImage.m
//  51TalkTeacher
//
//  Created by zftank on 2018/4/15.
//  Copyright © 2018年 51TalkTeacher. All rights reserved.
//

#import "UIImageView+UIImage.h"
#import "UIImageView+Network.h"

@implementation UIImageView (UIImage)

#pragma mark -
#pragma mark 请求图片

- (void)closeImageRequest {
    
    [self stopImageRequest];
}

- (void)startGIFAnimationAction:(NSInteger)loop {
    
    [self startGIFAnimation:loop];
}

- (void)stopGIFAnimationAction {
    
    [self stopGIFAnimation];
}

- (void)setImage:(HTTPDetails *)details
      cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
         success:(void(^)(HTTPDetails *result))success
         failure:(void(^)(HTTPDetails *result))failure {
    
    [self requestImage:details cumulation:cumulation success:^(HTTPDetails *result)
    {
        if (result.fromType == FromServerType && result.animationType == UIAnimationAlpha)
        {
            self.alpha = 0.0f;
            [UIView beginAnimations:@"IMAGEALPHA" context:NULL];
            [UIView setAnimationDuration:0.3];
            self.alpha = 1.0f;
            [UIView commitAnimations];
        }
         
        if (success)
        {
            success(result);
        }
    }
    failure:^(HTTPDetails *result)
    {
        if (failure)
        {
            failure(result);
        }
    }];
}

#pragma mark -
#pragma mark Photo Methods

- (void)setImageWithURL:(NSString *)url {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    [self setImage:details cumulation:nil success:nil failure:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    details.siteImage = placeholder;
    [self setImage:details cumulation:nil success:nil failure:nil];
}

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    details.siteImage = placeholder;
    details.radiusOfRectangle = radius;
    [self setImage:details cumulation:nil success:nil failure:nil];
}

- (void)setLiveImageWithURL:(NSString *)url
           placeholderImage:(UIImage *)placeholder
               cornerRadius:(CGFloat)radius
                 errorImage:(UIImage *)errorImage {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    details.siteImage = placeholder;
    details.errorImage = errorImage;
    details.radiusOfRectangle = radius;
    [self setImage:details cumulation:nil success:nil failure:nil];
}

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius
             errorImage:(UIImage *)errorImage {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    details.siteImage = placeholder;
    details.errorImage = errorImage;
    details.radiusOfRectangle = radius;
    [self setImage:details cumulation:nil success:nil failure:nil];
}

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
                success:(void(^)(HTTPDetails *result))success
                failure:(void(^)(HTTPDetails *result))failure {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    details.siteImage = placeholder;
    [self setImage:details cumulation:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius
                success:(void(^)(HTTPDetails *result))success
                failure:(void(^)(HTTPDetails *result))failure {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    details.siteImage = placeholder;
    details.radiusOfRectangle = radius;
    [self setImage:details cumulation:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius
             cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
                success:(void(^)(HTTPDetails *result))success
                failure:(void(^)(HTTPDetails *result))failure {
    
    HTTPDetails *details = [[HTTPDetails alloc] init];
    details.requestUrl = url;
    details.siteImage = placeholder;
    details.radiusOfRectangle = radius;
    [self setImage:details cumulation:cumulation success:success failure:failure];
}

@end
