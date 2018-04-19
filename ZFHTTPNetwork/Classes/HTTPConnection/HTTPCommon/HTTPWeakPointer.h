//
//  HTTPWeakPointer.h
//  51TalkTeacher
//
//  Created by zftank on 2017/12/31.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPWeakPointer : NSObject

@property (weak) id weakPointer;

- (instancetype)initManager:(id)object;

- (BOOL)checkManager;

@end
