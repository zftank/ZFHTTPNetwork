//
//  NSObject+Archive.m
//  HBFinance
//
//  Created by zftank on 16/9/21.
//  Copyright © 2016年 zftank. All rights reserved.
//

#import "NSObject+Archive.h"

@implementation NSObject (Archive)

//- (id)copyWithZone:(NSZone *)zone {
//    
//    return [self yy_modelCopy];
//}

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [self init];

    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [self yy_modelEncodeWithCoder:aCoder];
}

@end
