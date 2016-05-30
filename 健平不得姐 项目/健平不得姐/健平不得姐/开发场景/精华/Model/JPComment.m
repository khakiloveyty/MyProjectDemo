//
//  JPComment.m
//  健平不得姐
//
//  Created by ios app on 16/5/27.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPComment.h"
#import "NSDate+Extension.h"

@implementation JPComment

//MJExtension框架方法：将【服务器返回的属性名】转化为【自定义的属性名】
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    /*
     @key：自定义的属性名
     @value：服务器返回的属性名
     */
    
    return @{
             @"commentID":@"id"
             };
}

-(NSString *)ctime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//按服务器返回的格式设置
    
    //获取评论时间NSDate类
    NSDate *commentDate=[formatter dateFromString:_ctime]; //NSString ---> NSDate
    
    //判断是否为今年
    if ([commentDate isThisYear]) {
        if ([commentDate isToday]) {
            //今天
            NSDateComponents *components=[[NSDate date] deltaFromDate:commentDate]; //获取差值
            if (components.hour>=1) {
                //今天之内，大于1小时
                return [NSString stringWithFormat:@"%zd小时前",components.hour];
            }else if (components.minute>=1) {
                //大于1分钟且1小时之内（components.hour==0 && components.minute>=1）
                return [NSString stringWithFormat:@"%zd分钟前",components.minute];
            }else{
                //1分钟之内（components.hour==0 && components.minute==0）
                return @"刚刚";
            }
        }else if ([commentDate isYesterday]){
            //昨天
            formatter.dateFormat=@"昨天 HH:mm:ss";
            return [formatter stringFromDate:commentDate];
        }else{
            //比昨天更早之前，今年之内
            formatter.dateFormat=@"MM-dd HH:mm:ss"; //今年之内的就不用显示年份
            return [formatter stringFromDate:commentDate];
        }
    }else{
        //如果不是今年，则按yyyy-MM-dd HH:mm:ss格式显示
        return _ctime;
    }
}

@end
