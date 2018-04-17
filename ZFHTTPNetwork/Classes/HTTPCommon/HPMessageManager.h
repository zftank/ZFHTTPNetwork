//
//  HPMessageManager.h
//  51TalkTeacher
//
//  Created by zftank on 2017/11/14.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPDetails.h"

@interface HPMessageManager : NSObject

+ (void)showTips:(HTTPDetails *)details duration:(CGFloat)duration;

@end
