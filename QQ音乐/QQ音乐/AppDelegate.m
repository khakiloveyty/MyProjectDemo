//
//  AppDelegate.m
//  QQ音乐
//
//  Created by ios app on 16/6/7.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
        1.首先要在项目的 Capabilities 中开启 Background Modes
        2.然后选择 Audio,AirPlay,and Picture in Picture
     */
    
    //1.获取音频会话
    AVAudioSession *session=[AVAudioSession sharedInstance];
    
    //2.设置后台播放类别（AVAudioSessionCategoryPlayback：后台播放类别）
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //3.激活会话
    [session setActive:YES error:nil];
    
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
//    NSLog(@"回来");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterForeground" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
