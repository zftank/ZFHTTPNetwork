//
//  NSData+UIImageType.m
//  AFNetworking
//
//  Created by zftank on 2018/1/5.
//

#import "NSData+UIImageType.h"

/***
 
    图片数据的第一个字节是固定的,一种类型的图片第一个字节就是它的标识, 通过data来判断未知图片的类型
 
 ***/

@implementation NSData (UIImageType)

+ (UIImageType)checkImageTypeFromData:(NSData *)data {
    
    NSString *type = [NSData contentTypeForImageData:data];
    
    if ([type isEqualToString:@"jpeg"])
    {
        return UIImageJPEGType;
    }
    else if ([type isEqualToString:@"png"])
    {
        return UIImagePNGType;
    }
    else if ([type isEqualToString:@"gif"])
    {
        return UIImageGIFType;
    }
    else if ([type isEqualToString:@"webp"])
    {
        return UIImageWebPType;
    }
    else if ([type isEqualToString:@"tiff"])
    {
        return UIImageTIFFType;
    }
    
    return UIImageNoneType;
}

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

@end
