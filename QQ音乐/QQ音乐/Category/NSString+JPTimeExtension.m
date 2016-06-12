//
//  NSString+JPTimeExtension.m
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "NSString+JPTimeExtension.h"

@implementation NSString (JPTimeExtension)

+(NSString *)stringWithTime:(NSTimeInterval)time{
    //    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    //    formatter.dateFormat=@"mm:ss";
    //
    //    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    NSInteger min=time/60;
    NSInteger second=(NSInteger)time%60;
    
    return [NSString stringWithFormat:@"%02zd:%02zd",min,second];
}

@end
