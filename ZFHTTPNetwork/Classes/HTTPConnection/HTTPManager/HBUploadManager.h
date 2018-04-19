//
//  HBUploadManager.h
//  HBankXLoan
//
//  Created by zftank on 2016/10/29.
//  Copyright © 2016年 HBankXLoan. All rights reserved.
//

#import "HTTPManager.h"
#import "HTTPDetails.h"

@interface HBUploadManager : HTTPManager

+ (HBUploadManager *)HBUPloadManager;

- (void)createTask:(id)master details:(HTTPDetails *)details
        cumulation:(void(^)(int64_t receive,int64_t complete,CGFloat ratio))cumulation
           success:(void(^)(HTTPDetails *result))success
           failure:(void(^)(HTTPDetails *result))failure;

- (void)stopUploadData:(id)manager;

@end
