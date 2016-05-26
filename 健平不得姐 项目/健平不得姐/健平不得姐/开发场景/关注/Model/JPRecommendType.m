//
//  JPRecommendType.m
//  健平不得姐
//
//  Created by ios app on 16/5/13.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPRecommendType.h"

@implementation JPRecommendType

-(NSMutableArray *)users {
    if (!_users) {
        _users=[NSMutableArray array];
    }
    return _users;
}

//MJExtension框架方法：将服务器返回的属性名转化为自定义的属性名
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    /*
     @key：自定义的属性名
     @value：服务器返回的属性名
     */
    
    return @{
             @"ID":@"id"
             };
}

@end
