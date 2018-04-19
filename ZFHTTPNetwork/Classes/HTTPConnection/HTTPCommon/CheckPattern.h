//
//  CheckMeasure.h
//  PanoramicVideo
//
//  Created by zftank on 16/8/28.
//  Copyright © 2016年 PanoramicVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckPattern : NSObject

//判断URL是否有效
+ (BOOL)checkUrlValid:(NSString *)string;

//编码不合法字符
+ (NSString *)DECodeValue:(NSString *)string;

//URL编码
+ (NSString *)URLEncode:(NSString *)string;

//URL解码
+ (NSString *)URLDecoded:(NSString *)string;

@end
