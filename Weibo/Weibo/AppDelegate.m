//
//  AppDelegate.m
//  Weibo
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "AppDelegate.h"
#import "JPOAuthViewController.h"
#import "JPAccountTool.h"
#import "UIWindow+Extension.h"
#import "SDWebImageManager.h"

//RGB颜色
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//随机色 arc4random_uniform(256)：0~255的随机数
#define RandomColor Color(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //iOS8之后要注册通知（需要在应用程序右上角添加未读数的徽章）
    UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    //settingsForTypes：设置类型，设置通知类型为徽章类型
    [application registerUserNotificationSettings:setting];
    
    //1.创建窗口
    self.window=[[UIWindow alloc]init];
    self.window.frame=[UIScreen mainScreen].bounds;
    self.window.backgroundColor=RandomColor;
    
    //2.设置根控制器
    
    //解档（取出沙盒中保存对象的文件）
    JPAccount *account=[JPAccountTool account];
    
//    if (account) {  //如果之前已经登录成功过，即account有值
    
        //进入主界面
        [self.window switchRootViewController];
        

//    }else{  //如果还没有登录成功过，将首页设为登录页面
//        
//        //进入登陆界面
//        self.window.rootViewController=[[JPOAuthViewController alloc]init];
//        
//    }
    
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//当app进入后台时调用：
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     * app状态：
     * 1.死亡状态：没有打开app
     * 2.前台运行状态
     * 3.后台暂停状态：停止一切动画、定时器、多媒体操作、联网操作，很难再作其他操作
     * 4.后台运行状态
     */
    
    //向操作系统申请后台运行的资格，能维持多久，是不确定的（当内存不够用就会结束）
    __block UIBackgroundTaskIdentifier task=[application beginBackgroundTaskWithExpirationHandler:^{
        //当申请的后台运行时间已经结束（过期），就会调用这个block
        
        //赶紧结束任务
        [application endBackgroundTask:task];
    }];
    //根据block的特性，在block调用的task只会一直调用task的初值（因为task是局部变量），而调用时task为空值，但不能调用空值
    //所以要在task前面添加__block修饰符，或者让task成为属性，保存在内存中不被销毁，让block能够动态访问这个task变量
    //这里不能用static修饰，static只能赋直接值（固定或已经计算好的值），不能牵扯到方法调用
    
    
    //在Info.plist中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay（还可以设置其他模式）
    //设置一个0kb的MP3文件，没有声音，循环播放
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//使用SDWebImage很容易造成内存警告
//当程序发生内存警告时：
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    SDWebImageManager *manger=[SDWebImageManager sharedManager];
    //1.取消下载
    [manger cancelAll];
    //2.清除内存中的所有图片
    [manger.imageCache clearMemory];
}

@end
