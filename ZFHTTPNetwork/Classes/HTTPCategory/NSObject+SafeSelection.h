//
//  NSObject+SafeSelection.h
//  51TalkTeacher
//
//  Created by zftank on 2017/12/12.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "NSCrashFromMethod.h"

#import "NSDictionary+Resolve.h"
#import "NSDictionary+SafeAccess.h"

#import "NSArray+SafeAccess.h"

#import "NSString+Resolve.h"
#import "NSString+SafeAccess.h"

@interface NSObject (SafeSelection)

+ (void)classImplementationAction;

+ (void)classReplaceMethod:(SEL)currentMethod hookMethod:(SEL)hookMethod;

@end
