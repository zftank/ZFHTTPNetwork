//
//  HTTPWeakPointer.m
//  51TalkTeacher
//
//  Created by zftank on 2017/12/31.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "HTTPWeakPointer.h"

@implementation HTTPWeakPointer

- (void)dealloc {
    
    _weakPointer = nil;
}

- (instancetype)initManager:(id)object {
    
    self = [super init];
    
    if (self)
    {
        _weakPointer = object;
    }
    
    return self;
}

- (BOOL)checkManager {
    
    if (self.weakPointer)
    {
        return YES;
    }
    
    return NO;
}

@end
