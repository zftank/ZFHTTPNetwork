//
//  NSString+SafeAccess.m
//  51TalkTeacher
//
//  Created by zftank on 2017/12/20.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "NSString+SafeAccess.h"
#import "NSObject+SafeSelection.h"

@implementation NSString (SafeAccess)

+ (void)load {
    
#if DEBUG
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        
        @autoreleasepool
        {
            [objc_getClass("NSTaggedPointerString") classReplaceMethod:@selector(substringWithRange:)
                                                            hookMethod:@selector(hookTP_substringWithRange:)];
            
            [objc_getClass("__NSCFConstantString") classReplaceMethod:@selector(substringWithRange:)
                                                           hookMethod:@selector(hookFT_substringWithRange:)];
            
            [objc_getClass("__NSCFString") classReplaceMethod:@selector(substringWithRange:)
                                                   hookMethod:@selector(hookCF_substringWithRange:)];
        }
    });
    
#endif

}

- (NSString *)hookTP_substringWithRange:(NSRange)range {
    
    if ([self cutStringWithRange:range])
    {
        return [self hookTP_substringWithRange:range];
    }
    
    return nil;
}

- (NSString *)hookFT_substringWithRange:(NSRange)range {
    
    if ([self cutStringWithRange:range])
    {
        return [self hookFT_substringWithRange:range];
    }
    
    return nil;
}

- (NSString *)hookCF_substringWithRange:(NSRange)range {
    
    if ([self cutStringWithRange:range])
    {
        return [self hookCF_substringWithRange:range];
    }
    
    return nil;
}

- (BOOL)cutStringWithRange:(NSRange)range {
    
    if ((range.location + range.length) <= self.length)
    {
        return YES;
    }
    
    NSString *message = @"substringWithRange: 越界";
    
    [NSCrashFromMethod showCrashMessage:NSStringFromClass(self.class) crashMethod:message];
    
    return NO;
}

@end
