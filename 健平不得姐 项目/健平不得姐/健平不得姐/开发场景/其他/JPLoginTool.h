//
//  JPLoginTool.h
//  健平不得姐
//
//  Created by ios app on 16/6/4.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPLoginTool : NSObject
+(void)setUid:(NSString *)uid;
+(NSString *)getUid;
+(NSString *)getUidAndGoLogin:(BOOL)goLogin;
@end
