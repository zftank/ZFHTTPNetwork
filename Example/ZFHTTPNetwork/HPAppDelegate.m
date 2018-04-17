//
//  HPAppDelegate.m
//  ZFHTTPNetwork
//
//  Created by zhangfeng on 04/17/2018.
//  Copyright (c) 2018 zhangfeng. All rights reserved.
//

#import "HPAppDelegate.h"
#import "HPViewController.h"

@implementation HPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.statusBarHidden = NO;
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = [[HPViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
