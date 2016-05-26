//
//  JPStatusTool.m
//  Weibo
//
//  Created by 业余班 on 15/8/11.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPStatusTool.h"
#import "FMDB.h"

@implementation JPStatusTool

//类方法不能使用成员变量，只能使用全局变量
static FMDatabase *_db;

//initialize：当第一次使用类时，自动调用+initialize方法
//类在使用之前会执行此方法，且只会执行一次

//在initialize方法中进行打开数据库、创表的操作（只需要执行一次）
+(void)initialize{
    //创建数据库路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    //NSLog(@"11111 %@",filePath);
    
    //打开数据库
    _db=[FMDatabase databaseWithPath:filePath];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_status (id integer PRIMARY KEY, status blob NOT NULL, idstr text NOT NULL);"];
}

//读
+(NSArray *)statusesWithParams:(NSDictionary *)params{
    //根据请求参数生成对应的查询SQL语句
    NSString *sql=nil;
    
    if (params[@"since_id"]) {
        //1.不是第一次查询数据库：加载最新的20条数据（返回的是个空值，因为数据库不能从新浪服务器获取新数据，所以返回空值，这样就可以执行控制器的网络请求）
        
        sql=[NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr > %@ ORDER BY idstr DESC LIMIT 20;",params[@"since_id"]];
        //查询 以idstr的降序排序后的数据库 最新的20条微博
        
    }else if (params[@"max_id"]){
        //2.不是第一次查询数据库：加载最后的20条数据
        
        sql=[NSString stringWithFormat:@"SELECT * FROM t_status WHERE idstr <= %@ ORDER BY idstr DESC LIMIT 20;",params[@"since_id"]];
        //查询 以idstr的降序排序后的数据库 最后的20条微博
        
    }else{
        //3.第一次查询数据库：加载最前的20条数据
        
        sql=@"SELECT * FROM t_status ORDER BY idstr DESC LIMIT 20;";
        //查询 以idstr的降序排序后的数据库 最前的20条微博
    }
    
    //执行SQL语句
    FMResultSet *set=[_db executeQuery:sql];
    
    NSMutableArray *statuses=[NSMutableArray array];
    while (set.next) {
        NSData *statusData=[set objectForColumnName:@"status"];
        //objectForColumnName：获取该表指定的字段
        
        //NSData --> NSDictionary
        NSDictionary *statusDic=[NSKeyedUnarchiver unarchiveObjectWithData:statusData];
        [statuses addObject:statusDic];
    }
    
    return statuses;
}

//写
+(void)saveStatuses:(NSArray *)statuses{
    
    //要将一个对象存进数据库的blob（二进制格式，即NSData）字段，最好先转为NSData
    //不然，保存的会是NSString类型
    
    //如果是一个对象要转成NSData，这个对象要遵守NSCoding协议，实现协议中相应的方法，才能转成NSData
    
    for (NSDictionary *status in statuses) {
        //NSDictionary --> NSData
        NSData *statusData=[NSKeyedArchiver archivedDataWithRootObject:status];
        [_db executeUpdateWithFormat:@"INSERT INTO t_status(status, idstr) VALUES (%@, %@);",statusData,status[@"idstr"]];
    }
}
@end
