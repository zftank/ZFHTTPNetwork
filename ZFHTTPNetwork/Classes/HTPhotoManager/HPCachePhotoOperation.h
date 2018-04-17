//
//  HPCachePhotoOperation.h
//  HTTPNetwork
//
//  Created by zftank on 2018/2/2.
//

#import "HTTPConnection.h"

@interface HPCachePhotoOperation : NSOperation

@property (weak) id manager;

@property (strong) HTTPDetails *resultInfo;

@property (assign) BOOL breakSession;

@property (copy) void(^cumulationBlock)(int64_t receive,int64_t complete,CGFloat ratio);

@property (copy) void(^completeBlock)(BOOL cacheImage);

+ (id)create:(id)master details:(HTTPDetails *)details
  cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
  completion:(void(^)(BOOL cacheImage))completion;

@end
