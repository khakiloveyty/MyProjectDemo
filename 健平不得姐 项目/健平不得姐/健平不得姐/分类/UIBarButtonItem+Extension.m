//
//  UIBarButtonItem+Extension.m
//  Weibo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

//创建导航栏上面的Item样式：设置一个按钮放入Item的CustomView中
/* 
 * 各个参数：
 *  target：负责按钮响应事件的对象
 *  action：响应方法
 *  imageName：图片名称
 *  highImageName：高亮的图片名称
 */
+(UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andImageName:(NSString *)imageName andHighImageName:(NSString *)highImageName{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];//自定义按钮样式
    
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];

    button.size=button.currentBackgroundImage.size;//按钮大小跟图片大小一致
    //button.currentBackgroundImage.size：获取按钮当前背景图片的size
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

/*
 * 为什么把创建Item这段代码放在分类：
 *      1.项目中有多处地方用到这段代码
 *      2.每一段代码都应该放在最合适的地方：这段代码明显在创建一个UIBarButtonItem，所以跟UIBarButtonItem相关
 *      3.按照命名习惯和规范：[UIBarButtonItem itemWith...]这种形式创建Item比较规范
 */

@end
