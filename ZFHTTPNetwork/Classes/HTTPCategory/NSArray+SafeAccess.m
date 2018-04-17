//
//  NSArray+SafeAccess.m
//  51TalkTeacher
//
//  Created by zftank on 2017/12/19.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "NSArray+SafeAccess.h"
#import "NSObject+SafeSelection.h"

/*
 
NSArray *array1 = @[@"1",@"2"];

NSArray *array2 = [[NSArray alloc] init];

NSArray *array3 = [[NSArray alloc] initwithobjocts:@"1",nil];

NSArray *array4 = [NSArray alloc];

NSMutbleArray *array5 = [NSMutbleArray array];


1、array2 类名叫 __NSArray0
 
2、未init的array4，类名叫做 __NSPlaceHolderArray
 
3、初始化后的可变数组类名都叫 __NSArrayM
 
4、初始化后的不可变数组类名都叫 __NSArrayI
 
 */

@implementation NSArray (SafeAccess)

+ (void)load {

#if DEBUG
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        
        @autoreleasepool
        {
            [objc_getClass("__NSArray0") classReplaceMethod:@selector(objectAtIndex:) hookMethod:@selector(hook0_objectAtIndex:)];
            
            [objc_getClass("__NSArrayI") classReplaceMethod:@selector(objectAtIndex:) hookMethod:@selector(hookI_objectAtIndex:)];
            
            [objc_getClass("__NSArrayM") classReplaceMethod:@selector(objectAtIndex:) hookMethod:@selector(hookM_objectAtIndex:)];
        }
    });
    
#endif

}

- (id)hook0_objectAtIndex:(NSUInteger)index {
    
    if (index < self.count)
    {
        return [self hook0_objectAtIndex:index];
    }
    else
    {
        [NSCrashFromMethod showCrashMessage:NSStringFromClass(self.class) crashMethod:@"数组越界"];
        
        return nil;
    }
}

- (id)hookI_objectAtIndex:(NSUInteger)index {
    
    if (index < self.count)
    {
        return [self hookI_objectAtIndex:index];
    }
    else
    {
        [NSCrashFromMethod showCrashMessage:NSStringFromClass(self.class) crashMethod:@"数组越界"];
        
        return nil;
    }
}

- (id)hookM_objectAtIndex:(NSUInteger)index {
    
    if (index < self.count)
    {
        return [self hookM_objectAtIndex:index];
    }
    else
    {
        [NSCrashFromMethod showCrashMessage:NSStringFromClass(self.class) crashMethod:@"数组越界"];
        
        return nil;
    }
}

@end
