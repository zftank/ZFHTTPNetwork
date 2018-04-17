//
//  NSCrashFromMethod.m
//  51TalkTeacher
//
//  Created by zftank on 2017/12/19.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "NSCrashFromMethod.h"

@implementation NSCrashFromMethod

- (void)replaceMethod {
    
    NSString *message = [NSString stringWithFormat:@"%@ 异常调用",self.methodName];
    
    [NSCrashFromMethod showMessage:self.claseName crashMessage:message];
}

+ (void)showCrashMessage:(NSString *)cName crashMethod:(NSString *)mName {
    
    [NSCrashFromMethod showMessage:cName crashMessage:mName];
}

+ (void)showMessage:(NSString *)className crashMessage:(NSString *)message {
    
#if DEBUG
    
//    NSArray *callArray = [NSThread callStackSymbols];
//
//    NSArray *stackArray = [NSThread callStackReturnAddresses];
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        [[[UIAlertView alloc] initWithTitle:className message:message
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil,nil] show];
    });
    
#endif

}

- (void)dealloc {
    
    _claseName = nil;
    
    _methodName = nil;
}

@end
