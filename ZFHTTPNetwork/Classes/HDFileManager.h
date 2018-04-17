//
//  FileManager.h
//  MarketWork
//
//  Created by zftank on 14-7-9.
//  Copyright (c) 2014年 MarketWork. All rights reserved.
//

typedef NS_ENUM (NSInteger,Catalog) {
    
    LogDocument = 0,      //登录信息
    
    LogCommon = 1,        //与登录无关的数据 Library/FileCommon (理论上永不删除)
    
    LogAccount = 2,       //登录后用户行为产生的数据 Library/FileAccount (退出登录会删除此文件夹)
};

/***
 
 禁用NSUserDefaults
 
 log:文件目录
 
 name:文件名称，同名name会覆盖
 
***/

#import "YYModel.h"
#import <Foundation/Foundation.h>

@interface HDFileManager : NSObject

+ (BOOL)setObject:(id)object forKey:(NSString *)name catalogue:(Catalog)log;//保存某个数据

+ (id)objectForKey:(NSString *)name catalogue:(Catalog)log;//获取某个数据

+ (BOOL)deleteObjectForKey:(NSString *)name catalogue:(Catalog)log;//删除某个数据

+ (BOOL)deleteCatalogue:(Catalog)log;//删除某个目录

#pragma mark -
#pragma mark Create FilePath

+ (NSString *)filePath:(NSString *)name catalogue:(Catalog)log;//获取文件路径

@end
