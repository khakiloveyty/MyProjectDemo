//
//  JPLrcsTool.m
//  QQ音乐
//
//  Created by ios app on 16/6/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLrcsTool.h"
#import "JPLrcLine.h"

@implementation JPLrcsTool

+(NSArray *)serializationLrcsWithLrcsName:(NSString *)lrcsName{
    
    //获取歌词文件路径
    NSString *lrcFilePath=[[NSBundle mainBundle] pathForResource:lrcsName ofType:nil];
    
    //读取歌词
    NSString *lrcsString=[NSString stringWithContentsOfFile:lrcFilePath encoding:NSUTF8StringEncoding error:nil];
    
    //根据【换行符】对总歌词进行分割
    NSArray *lrcs=[lrcsString componentsSeparatedByString:@"\n"];
    
    NSMutableArray *lrcLines=[NSMutableArray array];
    for (NSString *lrcLineString in lrcs) {
        
        //过滤歌词文件中不需要的句子
        if ([lrcLineString hasPrefix:@"[ti:"] || [lrcLineString hasPrefix:@"[ar:"] || [lrcLineString hasPrefix:@"[al:"] || ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        
        JPLrcLine *lrcLine=[JPLrcLine lrcLineWithLrcLineString:lrcLineString];
        [lrcLines addObject:lrcLine];
    }

    return lrcLines;
    
}

@end
