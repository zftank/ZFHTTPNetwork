//
//  NSCrashFromMethod.h
//  51TalkTeacher
//
//  Created by zftank on 2017/12/19.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCrashFromMethod : NSObject

@property (nonatomic,copy) NSString *claseName;

@property (nonatomic,copy) NSString *methodName;

+ (void)showCrashMessage:(NSString *)cName crashMethod:(NSString *)mName;

- (void)replaceMethod;

@end
