//
//  NSString+Extension.m
//  Weibo
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
/** 规定了最大宽度自动分配合适的Size（适合有多行的字符串） */
-(CGSize)sizeWithFont:(UIFont *)font andMaxWidth:(CGFloat)maxW{
    
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=font;
    
    //设定最大的宽度（当超过最大宽度则换行，不需要最大高度）
    CGSize maxSize=CGSizeMake(maxW, MAXFLOAT);
    
    //根据字符串的内容，结合指定的size区域，算出适合的能够完整装下字符串的矩形区域
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    //boundingRectWithSize 设定矩形区域可创建的最大上限
    //NSStringDrawingUsesLineFragmentOrigin 从头开始计算（保证精确）
}

/** 没有规定最大限度自动分配合适的Size（适合只有一小段的字符串） */
-(CGSize)sizeWithFont:(UIFont *)font{
    return [self sizeWithFont:font andMaxWidth:MAXFLOAT];
}


/** 计算当前文件\文件夹的内容大小 */
-(NSInteger)fileSize{
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    //判断是否为文件夹
    BOOL dir=NO;
    BOOL exists=[manager fileExistsAtPath:self isDirectory:&dir];
    //返回值：判断这个文件\文件夹是否存在
    //参数2：通过外部的变量地址来修改这个变量的值（布尔值，用于判断是否为文件夹）
    
    if (exists==NO) {   //不是一个文件\文件夹路径
        return 0;
    }
    
    if (dir==YES) { //self是一个文件夹，遍历
    
        //直接内容（文件夹里面的所有内容，不包括子文件夹里面的内容）
        //NSArray *contents=[manager contentsOfDirectoryAtPath:caches error:nil];
        
        //直接和间接内容（文件夹里面的所有内容，包括子文件夹里面的所有文件和文件夹及其里面的所有内容）
        NSArray *subpaths=[manager subpathsAtPath:self];
        
        //遍历
        NSInteger totalByteSize=0; //用来记录caches文件夹里面所有内容的总大小
        for (NSString *subpath in subpaths) {
            //获取（拼接）该文件的全路径
            NSString *fullSubpath=[self stringByAppendingPathComponent:subpath];
            
            //判断是否为文件夹
            BOOL dir=NO;
            [manager fileExistsAtPath:fullSubpath isDirectory:&dir];
            //参数2：通过外部的变量地址来修改这个变量的值（布尔值，用于判断是否为文件夹）
            
            if (dir==NO) {  //不是文件夹，是文件
                
                //叠加这个文件的大小
                totalByteSize+=[[manager attributesOfItemAtPath:fullSubpath error:nil][NSFileSize] integerValue];//将对象类型转为数据类型
                
                //[manager attributesOfItemAtPath:fullSubpath error:nil]：获取该文件的属性，是一个字典类型，其中一个键为NSFileSize，它的值是这个文件的大小
            }
        }
        
        //得出caches文件夹的总大小
        return totalByteSize;
        
    }else{  //self是一个文件，直接返回
        return [[manager attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
}


/*
 获取文件\文件夹的属性：
 NSDictionary *attrs=[manager attributesOfItemAtPath:fullSubpath error:nil]
 
 注意：文件夹是没有大小的属性，只有文件才有大小属性
 */

@end
