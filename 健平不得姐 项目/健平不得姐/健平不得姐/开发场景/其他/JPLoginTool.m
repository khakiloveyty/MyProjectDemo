//
//  JPLoginTool.m
//  健平不得姐
//
//  Created by ios app on 16/6/4.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPLoginTool.h"
#import "JPLoginRegisterViewController.h"

@implementation JPLoginTool

+(void)setUid:(NSString *)uid{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getUidAndGoLogin:(BOOL)goLogin{
    NSString *uid=[[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    if (uid) {
        return uid;
    }else{
        
        if (goLogin) {
            JPLoginRegisterViewController *lrVC=[[JPLoginRegisterViewController alloc] init];
            [KeyWindow.rootViewController presentViewController:lrVC animated:YES completion:nil];
        }
        
        return nil;
    }
}

+(NSString *)getUid{
    return [self getUidAndGoLogin:NO];
}

@end
