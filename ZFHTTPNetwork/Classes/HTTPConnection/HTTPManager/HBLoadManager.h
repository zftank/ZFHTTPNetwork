//
//  DownloadManager.h
//  HBFinance
//
//  Created by zftank on 16/9/27.
//  Copyright © 2016年 zftank. All rights reserved.
//

#import "HTTPManager.h"
#import "HBLoadOperation.h"

@interface HBLoadManager : HTTPManager

+ (HBLoadManager *)HBDownloadManager;

- (void)createTask:(id)master details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
           success:(void(^)(HTTPDetails *result))success
           failure:(void(^)(HTTPDetails *result))failure;

@end
