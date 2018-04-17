//
//  CheckMeasure.m
//  PanoramicVideo
//
//  Created by zftank on 16/8/28.
//  Copyright © 2016年 PanoramicVideo. All rights reserved.
//

#import "CheckPattern.h"

@implementation CheckPattern

+ (BOOL)checkUrlValid:(NSString *)string {
    
    if (string && [string isKindOfClass:[NSString class]])
    {
        if (1 < string.length)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)DECodeValue:(NSString *)string {
    
    static NSString * const kCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kCharactersGeneralDelimitersToEncode stringByAppendingString:kCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length)
    {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

+ (NSString *)URLEncode:(NSString *)string {
    
    if ([CheckPattern checkUrlValid:string] == NO)
    {
        return @"";
    }
    
    NSCharacterSet *code = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:code];
}

+ (NSString *)URLDecoded:(NSString *)string {
    
    return [string stringByRemovingPercentEncoding];
}

@end
