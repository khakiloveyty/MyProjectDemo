//
//  JPLrcLine.m
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLrcLine.h"

@implementation JPLrcLine

-(instancetype)initWithLrcLineString:(NSString *)lrcLineString{
    if (self=[super init]) {
        
        //[00:00.00]月半小夜曲 李克勤
        
        //以“]”为分隔符对歌词进行分隔
        NSArray *lrcsLine=[lrcLineString componentsSeparatedByString:@"]"];
        
        _text=[lrcsLine lastObject];    //拿到后面的歌词
        
        _time=[self timeIntWithTimeString:[lrcsLine firstObject]]; //解析前面的时间
    }
    return self;
}

+(instancetype)lrcLineWithLrcLineString:(NSString *)lrcLineString{
    return [[self alloc] initWithLrcLineString:lrcLineString];
}

-(NSTimeInterval)timeIntWithTimeString:(NSString *)timeString{
    
    //[02:50.98
    
    //获取“[”之后的字符串
    timeString=[timeString substringFromIndex:1];
    
    //分：拿到“:”前面那部分
    NSInteger min=[[[timeString componentsSeparatedByString:@":"] firstObject] integerValue];
    
    //秒：拿到从第3个位置起，2个长度的字符串
    NSInteger second=[[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    
    //毫秒：拿到“.”后面那部分
    NSInteger millisecond=[[[timeString componentsSeparatedByString:@"."] lastObject] integerValue];
    
    return min*60+second+millisecond/100.0;
}

@end
