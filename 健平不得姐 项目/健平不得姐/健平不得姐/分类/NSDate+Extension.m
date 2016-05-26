//
//  NSDate+Extension.m
//  健平不得姐
//
//  Created by ios app on 16/5/19.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 * 比较指定时间与自身时间的差值
 */
-(NSDateComponents *)deltaFromDate:(NSDate *)fromDate{
    
    //日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
//    //获取年份
//    NSInteger year=[calendar component:NSCalendarUnitYear fromDate:nowDate];
//
//    //获取月份
//    NSInteger month=[calendar component:NSCalendarUnitMonth fromDate:nowDate];
//
//    //获取日
//    NSInteger day=[calendar component:NSCalendarUnitDay fromDate:nowDate];

//    NSDateComponents *components=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate];
//    JPLog(@"%zd %zd %zd",components.year,components.month,components.day);
    
    
    NSCalendarUnit unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    
    //NSDateComponents：能获取时间所有元素（年、月、日、时、分、秒....）的类
    NSDateComponents *components=[calendar components:unit fromDate:fromDate toDate:self options:0];
    
    return components;
    
}


/**
 * 是否今年
 */
-(BOOL)isThisYear{
    //日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    NSInteger nowYear=[calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear=[calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear==selfYear;
}


/**
 * 是否今天
 */
-(BOOL)isToday{
    //日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    NSCalendarUnit unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *nowComponents=[calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents=[calendar components:unit fromDate:self];
    
    return nowComponents.year==selfComponents.year
        && nowComponents.month==selfComponents.month
        && nowComponents.day==selfComponents.day;
    
    
//    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
//    formatter.dateFormat=@"yyyy-MM-dd";
//    
//    NSString *nowStr=[formatter stringFromDate:[NSDate date]];
//    NSString *selfStr=[formatter stringFromDate:self];
//    
//    return [nowStr isEqualToString:selfStr];
}


/**
 * 是否昨天
 */
-(BOOL)isYesterday{
    //日期格式化类
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy-MM-dd";

    //NSDate ---> NSString
    NSString *nowStr=[formatter stringFromDate:[NSDate date]];
    NSString *selfStr=[formatter stringFromDate:self];
    
    /**
     * 先将日期转换成yyyy-MM-dd格式，这样就能获取到当天的0时0分0秒的NSDate类
     * 不然直接用NSCalendar类来比较的话，如果2015-12-31 23:59:59跟2016-01-01 00:00:02，明明是去年，不格式化的话components.year、components.month、components.day都为0
     */
    
    //NSString ---> NSDate
    NSDate *nowZeroDate=[formatter dateFromString:nowStr];
    NSDate *selfZeroDate=[formatter dateFromString:selfStr];
    
    //日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    NSCalendarUnit unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    NSDateComponents *components=[calendar components:unit fromDate:selfZeroDate toDate:nowZeroDate options:0];
    
    return components.year==0
        && components.month==0
        && components.day==1;
}

@end
