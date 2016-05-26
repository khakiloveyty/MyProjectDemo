//
//  NSDate+Extension.h
//  Weibo
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
//判断微博的发布时间是否今年
//参数：微博的发布时间
-(BOOL)isThisYear;

//判断微博的发布时间是否昨天
//参数：微博的发布时间
-(BOOL)isYesterday;

//判断微博的发布时间是否今天
//参数：微博的发布时间
-(BOOL)isToday;
@end
