//
//  JPAccountTool.h
//  Weibo
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

/*
 *   此类专门处理账号相关的所有操作：存储账号、取出账号、验证账号
 */

#import <Foundation/Foundation.h>
#import "JPAccount.h"

@interface JPAccountTool : NSObject

//存储账号到沙盒中
+(void)saveAccount:(JPAccount *)account;

//取出账号（如果账号过期，返回nil）
+(JPAccount *)account;

@end
