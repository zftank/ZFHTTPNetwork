//
//  HPViewController.m
//  ZFHTTPNetwork
//
//  Created by zhangfeng on 04/17/2018.
//  Copyright (c) 2018 zhangfeng. All rights reserved.
//

#import "HPViewController.h"
#import "HTTPConnection.h"

@interface HPViewController ()

@end

@implementation HPViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor redColor];
    
    
    [HTTPLink requestData:self details:nil success:^(HTTPDetails *result) {
        
    } failure:^(HTTPDetails *result) {
        
    }];
}

@end
