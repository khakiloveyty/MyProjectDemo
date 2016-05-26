//
//  NSDate+Extension.m
//  Weibo
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

//-(BOOL)isThisYear:(NSDate *)date
//写成分类不需要再传参，参数date就是self，直接用self即可
//谁调用就是算谁跟现在的时间差，用微博的发布时间调用这些分类，所以这里的self就是微博的发布时间

//判断微博的发布时间是否今年
//参数：微博的发布时间
-(BOOL)isThisYear{
    //创建日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //获取某个时间的年月日时分秒（可自定义unit设置返回的时间类型）
    //获取微博发布时间
    NSDateComponents *dateCmps=[calendar components:NSCalendarUnitYear fromDate:self];
    //获取当前时间
    NSDateComponents *nowCmps=[calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return dateCmps.year==nowCmps.year;
    //同一年 --> 1 --> YES
    //不同年 --> 0 --> NO
}

//判断微博的发布时间是否昨天
//参数：微博的发布时间
-(BOOL)isYesterday{
    
    //获取当前时间
    NSDate *nowDate=[NSDate date];
    
    /*
     计算是否昨天不需要时分秒，所有：
     (NSDate)2015-07-16 21:24:43 --> (NSString)2015-07-16 --> (NSDate)2015-07-16 00:00:00
     */
    
    //(NSDate)2015-07-16 21:24:43 --> (NSString)2015-07-16
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd";
    NSString *dateStr=[fmt stringFromDate:self];
    NSString *nowDateStr=[fmt stringFromDate:nowDate];
    
    //(NSString)2015-07-16 --> (NSDate)2015-07-16 00:00:00
    //需要利用**(NSDate)2015-07-16 00:00:00**这种类型的值来计算NSDateComponents
    NSDate *date=[fmt dateFromString:dateStr];
    nowDate=[fmt dateFromString:nowDateStr];
    
    
    //1.创建日历对象
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //2.创建要比较的时间类型的枚举（这里只需要年、月、日）
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    //3.计算两个日期之间的差值（微博发布时间和当前时间的差值）
    NSDateComponents *cmps=[calendar components:unit fromDate:date toDate:nowDate options:0];
    
    return cmps.year==0 && cmps.month==0 && cmps.day==1;
    //只要是相差一天（不能直接用日期相减，要使用NSDateComponents来计算），就是昨天发布的
}

//判断微博的发布时间是否今天
//参数：微博的发布时间
-(BOOL)isToday{
    
    //获取当前时间
    NSDate *nowDate=[NSDate date];
    
    //(NSDate)2015-07-16 21:24:43 --> (NSString)2015-07-16
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd";
    //(NSDate)2015-07-16 21:24:43 --> (NSString)2015-07-16
    NSString *dateStr=[fmt stringFromDate:self];
    NSString *nowDateStr=[fmt stringFromDate:nowDate];
    
    return [dateStr isEqualToString:nowDateStr];
    //只要年月日相等，肯定就是今天
    
}

@end
