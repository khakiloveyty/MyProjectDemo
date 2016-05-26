//
//  JPAccount.h
//  Weibo
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//账号属性：用于获取服务器的数据

#import <Foundation/Foundation.h>

@interface JPAccount : NSObject <NSCoding> //当需要用到归档技术把这个类的对象保存到沙盒中，就要遵守NSCoding协议，并设置好协议中的方法

/* 用于调用access_token，接口获取授权后的access token */
@property(nonatomic,copy)NSString *access_token;

/* access_token的生命周期，单位是秒数 */
@property(nonatomic,copy)NSNumber *expires_in;

/* 当前授权用户的UID（用户唯一标识） */
@property(nonatomic,copy)NSString *uid;

/* accessToken的获取时间 */
@property(nonatomic,strong)NSDate *created_time;

/* 用户的昵称 */
@property(nonatomic,copy)NSString *name;

+(instancetype)accountWithDic:(NSDictionary *)dic;
@end
