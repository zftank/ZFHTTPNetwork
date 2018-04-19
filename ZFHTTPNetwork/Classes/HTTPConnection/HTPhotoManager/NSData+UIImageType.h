//
//  NSData+UIImageType.h
//  AFNetworking
//
//  Created by zftank on 2018/1/5.
//

#import <Foundation/Foundation.h>
#import "HTTPDetails.h"

@interface NSData (UIImageType)

+ (UIImageType)checkImageTypeFromData:(NSData *)data;

@end
