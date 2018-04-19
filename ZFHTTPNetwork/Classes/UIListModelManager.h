//
//  UIListModelManager.h
//  51TalkTeacher
//
//  Created by zftank on 2017/11/20.
//  Copyright © 2017年 51TalkTeacher. All rights reserved.
//

#import "NSModelManager.h"

@interface UIListModelManager : NSModelManager

@property (nonatomic,readonly,strong) NSMutableArray *listData;//列表数据


@property (nonatomic,readonly) BOOL haveMore;//是否还有数据

@property (nonatomic,readonly) NSInteger numberOfPage;//当前页码


@property (nonatomic,assign) NSInteger numberOfBegin;//起始页码，服务器确定

@property (nonatomic,assign) NSInteger countOfPage;//每页的数量

#pragma mark -
#pragma mark 请求列表数据的方法

- (void)requestListData:(BOOL)refresh result:(void(^)(HTTPDetails *result))retHandler;

#pragma mark -
#pragma mark 子类复写的方法

- (HTTPDetails *)datails:(NSInteger)number count:(NSInteger)count;//构造httpDetails

- (NSArray *)resolveDataSource:(id)response;//解析数据

@end
