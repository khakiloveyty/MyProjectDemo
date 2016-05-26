//
//  UIWindow+Extension.m
//  Weibo
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "JPTabBarController.h"
#import "JPNewfeatureViewController.h"

@implementation UIWindow (Extension)
-(void)switchRootViewController{
    //进入主界面
    NSString *key=@"CFBundleVersion";
    
    //获取上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //获取当前软件的版本号（从Info.plist中获得）
    NSDictionary *info=[NSBundle mainBundle].infoDictionary;
    NSString *currentVersion=info[key];
    
//    if ([currentVersion isEqualToString:lastVersion]) { //如果版本号一样
    
        self.rootViewController=[[JPTabBarController alloc]init];
        //不用打开新特性
        
//    }else{ //如果版本不一样
//        
//        self.rootViewController=[[JPNewfeatureViewController alloc]init];
//        //打开新特性
//        
//        //将当前的版本号存进沙盒
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];//强制将数据保存到沙盒中
//        //因为系统默认是定时（每隔一段时间）保存数据，所以设置强制即时保存数据，以防数据丢失
//    }
}
@end
