//
//  NSString+Extension.h
//  Weibo
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/** 规定了最大宽度自动分配合适的Size（适合有多行的字符串） */
-(CGSize)sizeWithFont:(UIFont *)font andMaxWidth:(CGFloat)maxW;

/** 没有规定最大限度自动分配合适的Size（适合只有一小段的字符串） */
-(CGSize)sizeWithFont:(UIFont *)font;


/** 计算当前文件\文件夹的内容大小 */
-(NSInteger)fileSize;
@end
