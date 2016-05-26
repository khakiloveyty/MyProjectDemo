//
//  JPAccountTool.m
//  Weibo
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//沙盒路径 --> 宏
//    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filePath=[doc stringByAppendingPathComponent:@"account.archive"];
//    NSLog(@"%@",filePath);

#define JPAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

#import "JPAccountTool.h"

@implementation JPAccountTool

+(void)saveAccount:(JPAccount *)account{
    
    //自定义对象的存储必须用NSKeyedArchiver，不需要用writeToFile方法
    //使用归档技术保存对象到沙盒中
    [NSKeyedArchiver archiveRootObject:account toFile:JPAccountPath];
    
}

+(JPAccount *)account{
    
    //加载模型
    JPAccount *account=[NSKeyedUnarchiver unarchiveObjectWithFile:JPAccountPath];
    
    /* 验证账号是否过期 */
    
    //可使用的秒数
    long long expires_in=[account.expires_in longLongValue];
    //获取过期时间（创建时间+可使用的秒数=过期的时间）
    NSDate *expiresTime=[account .created_time dateByAddingTimeInterval:expires_in];
    //获取当前时间
    NSDate *nowTime=[NSDate date];
    /*
     * 如果expiresTime <= now，过期
     *
     * NSOrderedAscending = -1L, 升序（左边<右边）
     * NSOrderedSame, 一样（左边=右边）
     * NSOrderedDescending 降序（左边>右边）
     *
     */
    NSComparisonResult result=[expiresTime compare:nowTime];
    if (result==NSOrderedAscending||result==NSOrderedSame) {    //如果 过期时间<＝当前时间＝已经过期
        return nil;
    }else{
        return account;
    }
    
}

@end
