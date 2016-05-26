//
//  JPSpecial.h
//  Weibo
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

//保存微博内容中某段特殊文字的内容和范围

#import <Foundation/Foundation.h>

@interface JPSpecial : NSObject
@property(nonatomic,copy)NSString *text;//文字内容
@property(nonatomic,assign)NSRange range;//文字范围

//特殊文字区域的数组：因为选择的字符串区域有可能出现分行的情况，前部分在行末端，后部分在下一行的前端，或者多行等，分成好几块区域，所以是数组类型
@property(nonatomic,strong)NSArray *rects;
@end
