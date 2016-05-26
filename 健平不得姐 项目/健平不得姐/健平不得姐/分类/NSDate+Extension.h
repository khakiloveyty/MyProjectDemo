//
//  NSDate+Extension.h
//  健平不得姐
//
//  Created by ios app on 16/5/19.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 * 比较指定时间与自身时间的差值
 */
-(NSDateComponents *)deltaFromDate:(NSDate *)fromDate;

/**
 * 是否今年
 */
-(BOOL)isThisYear;

/**
 * 是否今天
 */
-(BOOL)isToday;

/**
 * 是否昨天
 */
-(BOOL)isYesterday;
@end
