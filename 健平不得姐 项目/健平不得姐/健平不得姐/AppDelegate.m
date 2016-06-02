//
//  AppDelegate.m
//  健平不得姐
//
//  Created by ios app on 16/5/12.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "AppDelegate.h"
#import "JPTabBarController.h"
#import "JPPushGuideView.h"
#import "KMCGeigerCounter.h"
#import "JPTopWindow.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#warning 设置SVProgressHUD样式
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    
    JPTabBarController *tabBarController=[[JPTabBarController alloc] init];
//    tabBarController.delegate=self;
    
    self.window.rootViewController=tabBarController;
    
    [self.window makeKeyAndVisible];
    
    //判断版本号：是否展示提示页面
    [JPPushGuideView showPushGuideView];
    
    //在应用顶部添加窗口
    //作用：点击这个窗口让所有scrollView能回滚到最上面（注意：Xcode7需要所有UIWindow必须有一个rootViewController，不然在这里调用会崩溃）
    [JPTopWindow show];
    
//    [KMCGeigerCounter sharedGeigerCounter].enabled = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    SDWebImageManager *manger=[SDWebImageManager sharedManager];
    //1.取消下载
    [manger cancelAll];
    //2.清除内存中的所有图片
    [manger.imageCache clearMemory];
}

//#pragma mark - UITabBarControllerDelegate
////选择tabBarController的子控制器时的回调
//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    
//    //发出通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:JPTabBarDidSelectedNotification object:nil userInfo:nil];
//    
//}

@end
