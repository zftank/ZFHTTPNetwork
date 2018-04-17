//
//  UIButton+Network.h
//  PanoramicVideo
//
//  Created by zftank on 16/8/28.
//  Copyright © 2016年 PanoramicVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPDetails.h"
#import "HTTPCommon.h"
#import "HTTPWeakPointer.h"

@interface UIButton (Network) <HTTPCommon>

- (void)stopImageRequest;

- (void)startGIFAnimation:(NSInteger)loop;

- (void)stopGIFAnimation;

#pragma mark -
#pragma mark 请求图片

- (void)requestImage:(HTTPDetails *)details
          cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
             success:(void(^)(HTTPDetails *result))success
             failure:(void(^)(HTTPDetails *result))failure;

@end
