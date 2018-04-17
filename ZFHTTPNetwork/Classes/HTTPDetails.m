//
//  HTTPDetails.m
//  JiuTianWaiApp
//
//  Created by zhangfeng on 13-6-21.
//  Copyright (c) 2013年 MasterPlate. All rights reserved.
//

#import "HTTPDetails.h"

@implementation HTTPDetails

- (instancetype)init {

    self = [super init];
    
    if (self)
    {
        _requestUrl = nil;
        _requestKey = nil;
        
        _requestMethod = GetMethod;
        _timeoutInterval = 60.0f;
        _resolveMode = JSONResolver;
        
        _requestHeader = nil;
        _requestBody = nil;
        _listBody = nil;
        
        _siteImage = nil;
        _errorImage = nil;
        
        _radiusOfRectangle = 0.0f;
        _runLoopMode = NSDefaultRunLoopMode;
        
        _showPosterImageForGIF = NO;
        _childThreadCheckCache = NO;
        
        _contentMode = UIViewContentModeScaleAspectFill;
        _defaultMode = UIViewContentModeScaleAspectFill;
        
        _CGImageType = UIImageNoneType;
        
        _animationType = UIAnimationAlpha;
        _fromType = FromServerType;
        
        _cacheName = nil;
        _cachePath = nil;
        
        _success = YES;
        _httpState = HTTPNetworkNormal;
        _message = @"";
        
        _resultHeader = nil;
        _resultData = nil;
    }
    
    return self;
}

- (CGSize)originalSize {
    
    if (self.resultData)
    {
        if ([self.resultData isKindOfClass:UIImage.class])
        {
            UIImage *resultImage = (UIImage *)self.resultData;
            
            return [resultImage size];
        }
        else if ([self.resultData isKindOfClass:FLAnimatedImage.class])
        {
            FLAnimatedImage *animationImage = (FLAnimatedImage *)self.resultData;
            
            return [animationImage size];
        }
    }
    
    return CGSizeMake(0.0,0.0);
}

- (NSDictionary *)defaultHeader {
    
    static NSMutableDictionary *currentHeader = nil;
    
    if (!currentHeader)
    {
        currentHeader = [[NSMutableDictionary alloc] init];
    }
    
    return currentHeader;
}

@end
