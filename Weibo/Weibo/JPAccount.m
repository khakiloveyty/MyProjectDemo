//
//  JPAccount.m
//  Weibo
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPAccount.h"
#import "MJExtension.h"

@implementation JPAccount

+(instancetype)accountWithDic:(NSDictionary *)dic{
    JPAccount *account=[[JPAccount alloc]init];
    account.access_token=dic[@"access_token"];
    account.expires_in=dic[@"expires_in"];
    account.uid=dic[@"uid"];
    
    //获取账号存储的时间（accessToken的产生时间：即是调用这方法的时间）
    NSDate *createdTime=[NSDate date];
    account.created_time=createdTime;
    
    return account;
}

#pragma mark - NSCoding协议的代理方法

MJCodingImplementation //NSCoding协议的代理方法的宏（相当于下面所有的代码）

////当一个对象要归档进沙盒中时，就会调用这个方法
////目的：在这个方法中说明这个对象的哪些属性要存进沙盒
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.access_token forKey:@"access_token"];
//    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
//    [aCoder encodeObject:self.uid forKey:@"uid"];
//    [aCoder encodeObject:self.created_time forKey:@"created_time"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//}
//
//
////当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
////目的：在这个方法中说明沙盒中的属性改怎么解析（需要取出哪些属性）
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    self=[super init];
//    if (self) {
//        self.access_token=[aDecoder decodeObjectForKey:@"access_token"];
//        self.expires_in=[aDecoder decodeObjectForKey:@"expires_in"];
//        self.uid=[aDecoder decodeObjectForKey:@"uid"];
//        self.created_time=[aDecoder decodeObjectForKey:@"created_time"];
//        self.name=[aDecoder decodeObjectForKey:@"name"];
//    }
//    return self;
//}

@end
