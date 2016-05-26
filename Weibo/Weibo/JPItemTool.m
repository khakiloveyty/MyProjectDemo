//
//  JPItemTool.m
//  Weibo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "JPItemTool.h"

@implementation JPItemTool

//创建导航栏上面的Item样式：设置一个按钮放入Item的CustomView中
+(UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andImageName:(NSString *)imageName andHighImageName:(NSString *)highImageName{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];//自定义按钮样式
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.size=button.currentBackgroundImage.size;//按钮大小跟图片大小一致
    //button.currentBackgroundImage.size：获取按钮当前背景图片的size
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

@end
