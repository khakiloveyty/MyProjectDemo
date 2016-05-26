//
//  JPRecommendTag.h
//  健平不得姐
//
//  Created by ios app on 16/5/16.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPRecommendTag : NSObject
/*
 image_list = http://img.spriteapp.cn/ugc/2016/03/10/092924_69853.jpg,
	theme_id = 3096,
	theme_name = 百思红人,
	is_sub = 0,
	is_default = 0,
	sub_number = 113687
 
 */
@property(nonatomic,copy)NSString *image_list;//图片
@property(nonatomic,assign)NSInteger theme_id;
@property(nonatomic,copy)NSString *theme_name;//名字
@property(nonatomic,assign)NSInteger is_sub;
@property(nonatomic,assign)NSInteger is_default;
@property(nonatomic,assign)NSInteger sub_number;//订阅数

@end
