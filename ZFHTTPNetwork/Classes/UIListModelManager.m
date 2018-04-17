//
//  UIListModelManager.m
//  51TalkTeacher
//
//  Created by zftank on 2017/11/20.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "UIListModelManager.h"
#import "HTTPConnection.h"

#define kListDataSource  @"ListDataSource"

@interface UIListModelManager ()

@property (nonatomic,strong) NSMutableArray *listData;

@property (nonatomic) BOOL haveMore;

@property (nonatomic) NSInteger numberOfPage;

@end

@implementation UIListModelManager

- (instancetype)init {
    
    self = [super init];
    
    if (self)
    {
        _haveMore = YES;
        
        _numberOfBegin = 0;
        
        _numberOfPage = 0;
        
        _countOfPage = 10;
        
        _listData = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark -
#pragma mark 请求列表数据的方法

- (void)requestListData:(BOOL)refresh result:(void(^)(HTTPDetails *result))retHandler {
    
    if (refresh)
    {
        [HTTPLink stopRequest:self withKey:kListDataSource];
    }
    
    HTTPDetails *details = nil;
    
    if (refresh)
    {
        details = [self datails:self.numberOfBegin count:self.countOfPage];
    }
    else
    {
        details = [self datails:self.numberOfPage count:self.countOfPage];
    }
    
    details.requestKey = kListDataSource;
    
    [HTTPLink requestData:self details:details success:^(HTTPDetails *result)
    {
        NSArray *listItem = [self resolveDataSource:result.resultData];
         
        if (listItem && [listItem isKindOfClass:[NSArray class]])
        {
            if (0 < listItem.count)
            {
                self.haveMore = YES;
                 
                if (refresh)
                {
                    self.numberOfPage = self.numberOfBegin;
                     
                    self.listData = [NSMutableArray arrayWithArray:listItem];
                }
                else
                {
                    [self.listData addObjectsFromArray:listItem];
                }
                 
                ++self.numberOfPage;
            }
            else
            {
                self.haveMore = NO;
            }
        }
        else
        {
            self.haveMore = NO;
        }
         
        if (retHandler)
        {
            retHandler(result);
        }
    }
    failure:^(HTTPDetails *result)
    {
        if (retHandler)
        {
            retHandler(result);
        }
    }];
}

#pragma mark -
#pragma mark 子类复写的方法

- (HTTPDetails *)datails:(NSInteger)number count:(NSInteger)count {
    
    return nil;
}

- (NSArray *)resolveDataSource:(id)response {
    
    return nil;
}

@end
