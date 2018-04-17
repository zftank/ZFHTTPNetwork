//
//  HPMessageManager.m
//  51TalkTeacher
//
//  Created by zftank on 2017/11/14.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "HPMessageManager.h"

@implementation HPMessageManager

+ (void)showTips:(HTTPDetails *)details duration:(CGFloat)duration {

    if (details.success)
    {
        return;
    }
    
    if (details.httpState == HTTPNotNetworkState)
    {
        
    }
    else if (details.httpState == HTTPNetworkTimedOut)
    {
        
    }
    else if (details.httpState == HTTPServerErrorState)
    {
        
    }
    else
    {
        
    }
}

@end
