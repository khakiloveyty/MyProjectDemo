//
//  JPStatusTool.h
//  Weibo
//
//  Created by 业余班 on 15/8/11.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//微博工具类：用来处理微博数据的缓存（保存到数据库中）
//作用于：打开app时显示已经缓存好的微博

#import <Foundation/Foundation.h>

@interface JPStatusTool : NSObject

/**
 * 根据请求参数去沙盒中（数据库）加载缓存的微博数据
 *
 * @param params：请求参数
 */
+(NSArray *)statusesWithParams:(NSDictionary *)params;

/**
 * 存储微博数据到沙盒中（数据库）
 *
 * @param statuses：需要存储的微博数据
 */
+(void)saveStatuses:(NSArray *)statuses;
@end
