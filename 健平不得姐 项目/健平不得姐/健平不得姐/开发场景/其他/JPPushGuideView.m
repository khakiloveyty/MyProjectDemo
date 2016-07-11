//
//  JPPushGuideView.m
//  健平不得姐
//
//  Created by ios app on 16/5/17.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPPushGuideView.h"

@implementation JPPushGuideView

+(void)showPushGuideView{
    //进入主界面
    NSString *key=@"CFBundleShortVersionString";
    
    //获取上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //获取当前软件的版本号（从Info.plist中获得）
    NSDictionary *info=[NSBundle mainBundle].infoDictionary;
    NSString *currentVersion=info[key];
    
    if (![currentVersion isEqualToString:lastVersion]) { //如果版本号不一样
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        
        JPPushGuideView *pushGuideView=[self viewLoadFromNib];
        pushGuideView.frame=window.bounds;
        [window addSubview:pushGuideView];
        
        //将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];//强制将数据保存到沙盒中
        //因为系统默认是定时（每隔一段时间）保存数据，所以设置强制即时保存数据，以防数据丢失
    }
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}


@end
