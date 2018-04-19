//
//  UIImageView+UIImage.h
//  51TalkTeacher
//
//  Created by zftank on 2018/4/15.
//  Copyright © 2018年 51TalkTeacher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPDetails.h"

@interface UIImageView (UIImage)

/***
 
 必须在主线程调用下列方法
 
 ***/

#pragma mark -
#pragma mark 请求图片

- (void)closeImageRequest;//停止图片请求

- (void)startGIFAnimationAction:(NSInteger)loop;//播放GIF动画(必须在成功的block里调用)

- (void)stopGIFAnimationAction;//停止GIF动画(必须在成功的block里调用)

- (void)setImage:(HTTPDetails *)details
      cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
         success:(void(^)(HTTPDetails *result))success
         failure:(void(^)(HTTPDetails *result))failure;

#pragma mark -
#pragma mark Photo Methods

- (void)setImageWithURL:(NSString *)url;

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius
             errorImage:(UIImage *)errorImage;

- (void)setLiveImageWithURL:(NSString *)url
           placeholderImage:(UIImage *)placeholder
               cornerRadius:(CGFloat)radius
                 errorImage:(UIImage *)errorImage;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
                success:(void(^)(HTTPDetails *result))success
                failure:(void(^)(HTTPDetails *result))failure;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius
                success:(void(^)(HTTPDetails *result))success
                failure:(void(^)(HTTPDetails *result))failure;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholder
           cornerRadius:(CGFloat)radius
             cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
                success:(void(^)(HTTPDetails *result))success
                failure:(void(^)(HTTPDetails *result))failure;

@end
