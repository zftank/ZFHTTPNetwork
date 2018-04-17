//
//  NSDictionary+SafeAccess.m
//  51TalkTeacher
//
//  Created by zftank on 2017/12/20.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "NSDictionary+SafeAccess.h"
#import "NSObject+SafeSelection.h"

@implementation NSDictionary (SafeAccess)

+ (void)load {

#if DEBUG
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        
        @autoreleasepool
        {
            Class dictionaryM = objc_getClass("__NSDictionaryM");
            
            [dictionaryM classReplaceMethod:@selector(setObject:forKey:)
                                 hookMethod:@selector(hookM_setObject:forKey:)];
        }
    });
    
#endif

}

- (void)hookM_setObject:(id)anObject forKey:(id)aKey {
    
    if (anObject && aKey)
    {
        [self hookM_setObject:anObject forKey:aKey];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"setObject:forKey: 不能设置nil"];
        
        [NSCrashFromMethod showCrashMessage:NSStringFromClass(self.class) crashMethod:message];
    }
}

@end
